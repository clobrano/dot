-- lua/plugins/gh-review-ext.lua
-- Extends gh-review.nvim with :GHReviewInfo
--   PR description + conversation (comments and review summaries)
--
--   r  quote-reply to the comment under cursor
--   c  new top-level comment
--   R  refresh from GitHub
--   H  toggle cleaned / raw HTML view
--   gy copy the URL of the comment under cursor to the clipboard
--   q  close
--
-- Compose buffer:
--   <C-s>        send
--   <C-q> / q    cancel

local state = {} -- info bufnr -> { arg, url, data, entries, raw }

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------

local function split(text)
  text = (text or ""):gsub("\r", "")
  return vim.split(text, "\n", { plain = true })
end

local function login(x)
  return (x and x.author and x.author.login) or "ghost"
end

-- case-insensitive tag pattern: "img" -> "[iI][mM][gG]"
local function ci(s)
  return (s:gsub("%a", function(c)
    return "[" .. c:lower() .. c:upper() .. "]"
  end))
end

-- apply fn only to text outside fenced code blocks
local function outside_fences(text, fn)
  local out, buf, fence = {}, {}, nil
  local function flush()
    if #buf > 0 then
      table.insert(out, fn(table.concat(buf, "\n")))
      buf = {}
    end
  end
  for _, line in ipairs(vim.split(text, "\n", { plain = true })) do
    if fence then
      table.insert(out, line)
      local close = line:match("^%s*([`~]+)%s*$")
      if close and close:sub(1, 1) == fence:sub(1, 1) and #close >= #fence then
        fence = nil
      end
    else
      local open = line:match("^%s*(```+)") or line:match("^%s*(~~~+)")
      if open then
        flush()
        fence = open
        table.insert(out, line)
      else
        table.insert(buf, line)
      end
    end
  end
  flush()
  return table.concat(out, "\n")
end

local function html_to_md(s)
  -- PR template comments
  s = s:gsub("<!%-%-.-%-%->", "")

  -- void elements
  s = s:gsub("<" .. ci("br") .. "%s*/?>", "\n")
  s = s:gsub("<" .. ci("hr") .. "%s*/?>", "\n---\n")
  s = s:gsub("<" .. ci("img") .. "%f[%s>/][^>]*>", function(tag)
    local alt = tag:match('alt="([^"]*)"') or "image"
    local src = tag:match('src="([^"]*)"') or ""
    return ("![%s](%s)"):format(alt, src)
  end)

  -- links (after images, so linked images become [![alt](src)](href))
  s = s:gsub(
    "<" .. ci("a") .. "%f[%s>][^>]-href=\"([^\"]*)\"[^>]*>(.-)</" .. ci("a") .. ">",
    "[%2](%1)"
  )

  -- <details><summary>…</summary> -> ▸ summary
  s = s:gsub("<" .. ci("summary") .. "%f[%s>][^>]*>(.-)</" .. ci("summary") .. ">", function(t)
    return "\n**▸ " .. vim.trim((t:gsub("%s+", " "))) .. "**\n"
  end)

  -- headings
  s = s:gsub("<[hH](%d)%f[%s>][^>]*>(.-)</[hH]%d>", function(n, t)
    return "\n" .. ("#"):rep(tonumber(n)) .. " " .. vim.trim(t) .. "\n"
  end)

  -- inline formatting
  local inline = {
    b = "**", strong = "**",
    i = "*", em = "*",
    code = "`", kbd = "`",
    del = "~~", s = "~~",
  }
  for tag, mark in pairs(inline) do
    s = s:gsub(
      "<" .. ci(tag) .. "%f[%s>][^>]*>(.-)</" .. ci(tag) .. ">",
      mark .. "%1" .. mark
    )
  end

  -- wrappers: drop the tags, keep the content
  for _, tag in ipairs({
    "details", "p", "div", "span", "center", "sub", "sup",
    "picture", "source", "ul", "ol", "li", "table",
  }) do
    s = s:gsub("</?" .. ci(tag) .. "%f[%s>/][^>]*>", "")
  end

  -- entities (&amp; last)
  s = s:gsub("&nbsp;", " ")
  s = s:gsub("&lt;", "<")
  s = s:gsub("&gt;", ">")
  s = s:gsub("&quot;", '"')
  s = s:gsub("&#39;", "'")
  s = s:gsub("&amp;", "&")

  -- collapse runs of blank lines
  s = s:gsub("\n[ \t]*\n%s*\n", "\n\n")
  return s
end

local function clean(body)
  local text = (body or ""):gsub("\r", "")
  return vim.trim(outside_fences(text, html_to_md))
end

---------------------------------------------------------------------------
-- data
---------------------------------------------------------------------------

local function fetch(arg)
  local cmd = { "gh", "pr", "view" }
  if arg and arg ~= "" then
    table.insert(cmd, arg)
  end
  vim.list_extend(cmd, { "--json", "number,title,url,author,body,comments,reviews" })
  local res = vim.system(cmd, { text = true }):wait()
  if res.code ~= 0 then
    return nil, res.stderr
  end
  local ok, data = pcall(vim.json.decode, res.stdout)
  if not ok then
    return nil, data
  end
  return data
end

---------------------------------------------------------------------------
-- rendering
---------------------------------------------------------------------------

local function render(data, raw)
  local lines, entries = {}, {}

  local function add(header, author, body, url)
    local start = #lines + 1
    vim.list_extend(lines, header)
    local text = raw and (body or "") or clean(body)
    local shown = text ~= "" and text or "_(empty)_"
    vim.list_extend(lines, split(shown))
    -- entries keep the RAW body, so quote-replies match GitHub exactly
    table.insert(entries, {
      start = start,
      stop = #lines,
      author = author,
      body = body or "",
      url = url,
    })
  end

  add(
    { ("# #%d %s (@%s)"):format(data.number, data.title, login(data)), data.url, "" },
    login(data),
    data.body,
    data.url
  )

  -- merge review summaries and comments chronologically
  local items = {}
  for _, r in ipairs(data.reviews or {}) do
    if r.body and r.body ~= "" then
      table.insert(items, {
        title = ("## Review @%s [%s]"):format(login(r), r.state or "?"),
        author = login(r),
        at = r.submittedAt or "",
        body = r.body,
        url = r.url,
      })
    end
  end
  for _, c in ipairs(data.comments or {}) do
    table.insert(items, {
      title = ("## @%s"):format(login(c)),
      author = login(c),
      at = c.createdAt or "",
      body = c.body,
      url = c.url,
    })
  end
  table.sort(items, function(a, b) return a.at < b.at end)

  for _, it in ipairs(items) do
    vim.list_extend(lines, { "", "---", "" })
    local when = (it.at:sub(1, 16):gsub("T", " "))
    local url = it.url or data.url
    -- URL is display-only: quote-replies use entry.body, never these header lines
    add({ it.title .. " · " .. when, url, "" }, it.author, it.body, url)
  end

  return lines, entries
end

local function draw(buf, data)
  local lines, entries = render(data, state[buf].raw)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  state[buf].data = data
  state[buf].url = data.url
  state[buf].entries = entries
end

local function refresh(buf)
  local data, err = fetch(state[buf].arg)
  if not data then
    vim.notify(err or "gh pr view failed", vim.log.levels.ERROR)
    return
  end
  draw(buf, data)
end

local function entry_at_cursor(buf)
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  for _, e in ipairs(state[buf].entries or {}) do
    if lnum >= e.start and lnum <= e.stop then
      return e
    end
  end
end

---------------------------------------------------------------------------
-- compose
---------------------------------------------------------------------------

local function compose(info_buf, entry)
  local st = state[info_buf]
  local init = { "" }
  if entry then
    init = {}
    for _, l in ipairs(split(entry.body)) do
      table.insert(init, l == "" and ">" or ("> " .. l))
    end
    vim.list_extend(init, { "", "@" .. entry.author .. " " })
  end

  vim.cmd("botright 12new")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.wo.winbar = (entry and ("Reply to @" .. entry.author) or "New comment")
    .. "  ·  <C-s> send  ·  <C-q> cancel"
  vim.wo.wrap = true
  vim.wo.linebreak = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, init)
  vim.api.nvim_win_set_cursor(0, { #init, #init[#init] })
  vim.cmd("startinsert!")

  local sending = false
  local function send()
    if sending then
      return
    end
    local body = vim.trim(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"))
    if body == "" then
      vim.notify("Empty comment, not sent", vim.log.levels.WARN)
      return
    end
    sending = true
    vim.cmd("stopinsert")
    vim.notify("Posting comment…")
    vim.system(
      { "gh", "pr", "comment", st.url, "--body-file", "-" },
      { stdin = body, text = true },
      function(res)
        vim.schedule(function()
          sending = false
          if res.code ~= 0 then
            -- keep the draft so nothing is lost
            vim.notify("gh pr comment failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
            return
          end
          vim.notify("Comment posted")
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
          if vim.api.nvim_buf_is_valid(info_buf) then
            refresh(info_buf)
          end
        end)
      end
    )
  end

  local function cancel()
    vim.cmd("stopinsert")
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  local o = { buffer = buf, silent = true }
  vim.keymap.set({ "n", "i" }, "<C-s>", send, o)
  vim.keymap.set({ "n", "i" }, "<C-q>", cancel, o)
  vim.keymap.set("n", "q", cancel, o)
end

---------------------------------------------------------------------------
-- info buffer
---------------------------------------------------------------------------

local function open_info(opts)
  local data, err = fetch(opts.args)
  if not data then
    vim.notify(err or "gh pr view failed", vim.log.levels.ERROR)
    return
  end

  vim.cmd("tabnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.wo.winbar = "r reply  ·  c comment  ·  gy copy URL  ·  R refresh  ·  H raw/clean  ·  q close"
  vim.wo.wrap = true
  vim.wo.linebreak = true

  -- pin to the URL so refresh hits the same PR even if you switch branch
  state[buf] = { arg = data.url, raw = false }
  draw(buf, data)

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      state[buf] = nil
    end,
  })

  local function map(lhs, fn, desc)
    vim.keymap.set("n", lhs, fn, { buffer = buf, silent = true, desc = desc })
  end

  map("r", function()
    local e = entry_at_cursor(buf)
    if not e then
      vim.notify("Cursor is not on a comment", vim.log.levels.WARN)
      return
    end
    compose(buf, e)
  end, "Quote-reply")

  map("c", function() compose(buf, nil) end, "New comment")
  map("R", function() refresh(buf) end, "Refresh")

  map("gy", function()
    local e = entry_at_cursor(buf)
    if not e or not e.url then
      vim.notify("Cursor is not on a comment", vim.log.levels.WARN)
      return
    end
    vim.fn.setreg('"', e.url)
    local ok = pcall(vim.fn.setreg, "+", e.url)
    if ok then
      vim.notify("Copied " .. e.url)
    else
      vim.notify("No clipboard provider; URL is in the unnamed register", vim.log.levels.WARN)
    end
  end, "Copy comment URL")

  map("H", function()
    state[buf].raw = not state[buf].raw
    draw(buf, state[buf].data)
    vim.notify(state[buf].raw and "Raw view" or "Cleaned view")
  end, "Toggle raw/cleaned HTML")

  map("q", function()
    -- closes the whole info tab (including an open compose split)
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd("tabclose")
    else
      vim.cmd("bwipeout")
    end
  end, "Close")
end

---------------------------------------------------------------------------
-- lazy.nvim spec (merged with your main gh-review.nvim spec)
---------------------------------------------------------------------------

return {
  "gh-tui-tools/gh-review.nvim",
  cmd = { "GHReview", "GHReviewInfo" },
  keys = {
    { "<leader>gi", "<cmd>GHReviewInfo<cr>", desc = "GH Review: PR description & comments" },
  },
  config = function(_, opts)
    -- setup() is optional; only call it if some spec provided opts
    if opts and next(opts) ~= nil then
      require("gh_review").setup(opts)
    end
    vim.api.nvim_create_user_command("GHReviewInfo", open_info, {
      nargs = "?",
      desc = "Show PR description and conversation comments",
    })
  end,
}
