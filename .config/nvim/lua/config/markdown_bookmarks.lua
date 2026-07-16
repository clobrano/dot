-- File: lua/config/markdown_bookmarks.lua
-- Support for Bookmarks and Cheatsheets in Neovim.
-- Bookmarks.txt: reference links opened with xdg-open
-- Cheatsheet.txt: CLI commands copied to system clipboard

local M = {}

-- Resolve a file inside the Obsidian vault
local function get_vault_file(filename)
  local has_obsidian, obsidian = pcall(require, "obsidian")
  if not has_obsidian then return nil end

  local ok, client = pcall(obsidian.get_client)
  if not ok or not client or not client.dir then return nil end

  return tostring(client.dir) .. "/" .. filename
end

-- Copy text to system clipboard
local function copy_to_clipboard(text)
  if vim.fn.executable("wl-copy") == 1 then
    vim.fn.system({"wl-copy"}, text)
  elseif vim.fn.executable("xclip") == 1 then
    vim.fn.system({"xclip", "-selection", "clipboard"}, text)
  elseif vim.fn.executable("xsel") == 1 then
    vim.fn.system({"xsel", "-b"}, text)
  else
    vim.fn.setreg("+", text)
  end
end

-- Parse [name]: value lines from a file
local function parse_references(filepath)
  if not filepath or vim.fn.filereadable(filepath) ~= 1 then
    return {}
  end

  local entries = {}
  for line in io.lines(filepath) do
    local ref_name, value = string.match(line, "^%[(.-)%]:%s*(.+)$")
    if ref_name and value then
      table.insert(entries, {
        name = ref_name,
        value = vim.trim(value),
        display = string.format("%-30s  %s", ref_name, value),
      })
    end
  end
  return entries
end

-- Find entry by display line
local function find_entry(entries, line)
  local ref_name = vim.trim(line:match("^(.-)%s%s+"))
  if not ref_name then
    ref_name = vim.trim(line)
  end
  for _, entry in ipairs(entries) do
    if entry.name == ref_name then
      return entry
    end
  end
  return nil
end

function M.setup()
  -- Note: markdown_refs cmp source is now registered in obsidian.lua

  -- ── Add command (shared logic, different file) ──────────────
  local function create_add_command(cmd_name, filename, label)
    vim.api.nvim_create_user_command(cmd_name, function(opts)
      local filepath = get_vault_file(filename)
      if not filepath then
        vim.notify("Could not locate Obsidian vault", vim.log.levels.ERROR)
        return
      end

      local ref_name = opts.fargs[1]
      if not ref_name then
        ref_name = vim.fn.input("Reference name: ")
        if ref_name == "" then return end
      end

      local value = opts.fargs[2]
      if not value then
        value = vim.fn.input(label .. ": ")
        if value == "" then return end
      end

      local entry = string.format("[%s]: %s", ref_name, value)
      local file = io.open(filepath, "a")
      if file then
        file:write(entry .. "\n")
        file:close()
        vim.notify(string.format("Added: [%s]", ref_name), vim.log.levels.INFO)
      else
        vim.notify("Could not write to " .. filename, vim.log.levels.ERROR)
      end
    end, {
      nargs = "*",
      desc = "Add entry to " .. filename,
    })
  end

  -- ── Open command (shared logic, different file) ─────────────
  local function create_open_command(cmd_name, filename)
    vim.api.nvim_create_user_command(cmd_name, function()
      local filepath = get_vault_file(filename)
      if not filepath then
        vim.notify("Could not locate Obsidian vault", vim.log.levels.ERROR)
        return
      end

      if vim.fn.filereadable(filepath) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(filepath))
      else
        vim.notify(filename .. " not found", vim.log.levels.ERROR)
      end
    end, {
      desc = "Open " .. filename,
    })
  end

  -- ── Bookmarks ──────────────────────────────────────────────

  create_add_command("AddBookmark", "Bookmarks.txt", "URL")
  create_open_command("OpenBookmarks", "Bookmarks.txt")

  vim.api.nvim_set_keymap('n', '<leader>bf', ':FindBookmarks<cr>', { desc='[B]ookmarks [F]ind', noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ba', ':AddBookmark<cr>', { desc='[B]ookmarks [A]dd', noremap = true, silent = true })

  vim.api.nvim_create_user_command("FindBookmarks", function()
    local has_fzf, fzf = pcall(require, "fzf-lua")
    if not has_fzf then
      vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
      return
    end

    local bookmarks = parse_references(get_vault_file("Bookmarks.txt"))
    if #bookmarks == 0 then
      vim.notify("No bookmarks found in Bookmarks.txt", vim.log.levels.WARN)
      return
    end

    local entries = {}
    for _, b in ipairs(bookmarks) do
      table.insert(entries, b.display)
    end

    fzf.fzf_exec(entries, {
      prompt = "Bookmarks> ",
      winopts = {
        preview = {
          layout = "horizontal",
          horizontal = "down:30%",
        },
      },
      preview = function(items)
        if not items or #items == 0 then return "" end
        local b = find_entry(bookmarks, items[1])
        if b then
          return string.format("Name: %s\nURL:  %s\n\nMarkdown link: [%s](%s)",
            b.name, b.value, b.name, b.value)
        end
        return ""
      end,
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local b = find_entry(bookmarks, selected[1])
          if b then
            vim.fn.jobstart({"xdg-open", b.value}, {
              detach = true,
              on_exit = function(_, exit_code)
                vim.schedule(function()
                  vim.notify(string.format("xdg-open exit code: %d for %s", exit_code, b.value), vim.log.levels.INFO)
                end)
              end
            })
          end
        end,
        ["ctrl-y"] = function(selected)
          if not selected or #selected == 0 then return end
          local b = find_entry(bookmarks, selected[1])
          if b then
            copy_to_clipboard(b.value)
            vim.notify(string.format("Yanked URL: %s", b.value), vim.log.levels.INFO)
          end
        end,
        ["alt-y"] = function(selected)
          if not selected or #selected == 0 then return end
          local b = find_entry(bookmarks, selected[1])
          if b then
            local md_link = string.format("[%s](%s)", b.name, b.value)
            copy_to_clipboard(md_link)
            vim.notify(string.format("Yanked markdown: %s", md_link), vim.log.levels.INFO)
          end
        end,
      },
      fzf_opts = {
        ["--header"] = "Enter: open | Ctrl-y: yank URL | Alt-y: yank markdown",
      },
    })
  end, {
    desc = "Fuzzy find and open bookmarks",
  })

  -- ── Preview markdown with Bookmarks.txt references ──────────
  vim.api.nvim_set_keymap('n', '<leader>mp', ':PreviewMarkdown<cr>', { desc='[M]arkdown [P]review with bookmarks', noremap = true, silent = true })

  vim.api.nvim_create_user_command("PreviewMarkdown", function(opts)
    if vim.fn.executable("pandoc") ~= 1 then
      vim.notify("pandoc is not installed (sudo dnf install pandoc)", vim.log.levels.ERROR)
      return
    end

    local buffile = vim.api.nvim_buf_get_name(0)
    if buffile == "" then
      vim.notify("Buffer has no file", vim.log.levels.ERROR)
      return
    end

    local bookmarks = get_vault_file("Bookmarks.txt")
    local output = "/tmp/nvim-preview.html"
    if opts.args ~= "" then
      output = opts.args
      if not output:match("^/") then
        output = "/tmp/" .. output
      end
      if not output:match("%.html$") then
        output = output .. ".html"
      end
    end

    local style = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/markdown-preview.html"

    -- Sanitize YAML frontmatter (backtick values) and render wikilinks as styled spans
    local shell_cmd = string.format(
      "sed -e '/^---$/,/^---$/{ /^---$/!{ s/`\\([^`]*\\)`/\"\\1\"/g } }' -e 's/\\[\\[\\([^]|]*\\)|\\([^]]*\\)\\]\\]/<span class=\"wikilink\">\\2<\\/span>/g' -e 's/\\[\\[\\([^]]*\\)\\]\\]/<span class=\"wikilink\">\\1<\\/span>/g' %s",
      vim.fn.shellescape(buffile)
    )
    if bookmarks and vim.fn.filereadable(bookmarks) == 1 then
      shell_cmd = string.format("%s; echo; cat %s", shell_cmd, vim.fn.shellescape(bookmarks))
    end
    shell_cmd = string.format(
      "{ %s; } | pandoc -s -f markdown+hard_line_breaks --metadata title=Preview --include-in-header %s -o %s 2>&1",
      shell_cmd, vim.fn.shellescape(style), vim.fn.shellescape(output)
    )

    local result = vim.fn.system(shell_cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("pandoc failed: " .. vim.trim(result), vim.log.levels.ERROR)
      return
    end

    vim.fn.jobstart({"xdg-open", output}, { detach = true })
  end, {
    nargs = "?",
    desc = "Preview current markdown file with Bookmarks.txt references",
  })

  -- ── Cheatsheet ─────────────────────────────────────────────

  create_add_command("AddCheatsheet", "Cheatsheet.txt", "Command")
  create_open_command("OpenCheatsheet", "Cheatsheet.txt")

  vim.api.nvim_set_keymap('n', '<leader>cf', ':FindCheatsheet<cr>', { desc='[C]heatsheet [F]ind', noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ca', ':AddCheatsheet<cr>', { desc='[C]heatsheet [A]dd', noremap = true, silent = true })

  vim.api.nvim_create_user_command("FindCheatsheet", function()
    local has_fzf, fzf = pcall(require, "fzf-lua")
    if not has_fzf then
      vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
      return
    end

    local cheats = parse_references(get_vault_file("Cheatsheet.txt"))
    if #cheats == 0 then
      vim.notify("No entries found in Cheatsheet.txt", vim.log.levels.WARN)
      return
    end

    local entries = {}
    for _, c in ipairs(cheats) do
      table.insert(entries, c.display)
    end

    fzf.fzf_exec(entries, {
      prompt = "Cheatsheet> ",
      winopts = {
        preview = {
          layout = "horizontal",
          horizontal = "down:30%",
        },
      },
      preview = function(items)
        if not items or #items == 0 then return "" end
        local c = find_entry(cheats, items[1])
        if c then
          return string.format("Name:    %s\nCommand: %s", c.name, c.value)
        end
        return ""
      end,
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then return end
          local c = find_entry(cheats, selected[1])
          if c then
            copy_to_clipboard(c.value)
            vim.notify(string.format("Copied: %s", c.value), vim.log.levels.INFO)
          end
        end,
        ["ctrl-y"] = function(selected)
          if not selected or #selected == 0 then return end
          local c = find_entry(cheats, selected[1])
          if c then
            local full = string.format("%s: %s", c.name, c.value)
            copy_to_clipboard(full)
            vim.notify(string.format("Copied with name: %s", full), vim.log.levels.INFO)
          end
        end,
      },
      fzf_opts = {
        ["--header"] = "Enter: copy command | Ctrl-y: copy with name",
      },
    })
  end, {
    desc = "Fuzzy find cheatsheet and copy command to clipboard",
  })
end

return M
