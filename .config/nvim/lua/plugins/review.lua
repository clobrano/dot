return {
  "georgeguimaraes/review.nvim",
  version = "*",
  dependencies = {
    "esmuellert/codediff.nvim",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>rr", "<cmd>Review<cr>",         desc = "Review working tree" },
    { "<leader>rc", "<cmd>Review commits<cr>", desc = "Review commits" },
    { "<leader>rb", "<cmd>Review branch<cr>",  desc = "Review branch" },
    { "<leader>rv", ":Review note<cr>",        mode = { "n", "v" },          desc = "[R]e[v]iew: ask a question" },
    { "<leader>re", "<cmd>Review edit<cr>",    desc = "Review: edit comment" },
    { "<leader>rd", "<cmd>Review delete<cr>",  desc = "Review: delete comment" },
    { "<leader>rx", "<cmd>ReviewExportCustom<cr>", desc = "Review: export custom format" },
  },
  config = function()
    local function excerpt(c)
      local ok, lines = pcall(vim.fn.readfile, c.file)
      if not ok or c.line == 0 then return {} end
      local first = math.max(c.line, 1)
      local last = math.max(first, c.line_end or first)
      local fence_length = 3
      for i = first, last do
        for run in (lines[i] or ""):gmatch("~+") do
          fence_length = math.max(fence_length, #run + 1)
        end
      end
      local fence = string.rep("~", fence_length)
      local filetype = vim.filetype.match({ filename = c.file }) or "text"
      local out = { fence .. filetype }
      for i = first, last do table.insert(out, lines[i] or "") end
      table.insert(out, fence)
      return out
    end

    local function location(c)
      local path = c.file
      local root = require("review.utils").git_root()
      if root and not path:match("^/") then
        path = root .. "/" .. path
      end
      path = vim.fn.fnamemodify(path, ":p")
      if c.line and c.line > 0 then
        path = path .. ":" .. c.line
        if c.line_end and c.line_end > c.line then
          path = path .. "-" .. c.line_end
        end
      end
      return path
    end

    local function format_comments(comments)
      local md = {
        "Feedback on your previous output. Review each comment with its quoted context.",
        "Reply to QUESTION comments without changing code. Make changes for ACTION or ISSUE comments. Treat PRAISE as positive feedback.",
        "",
      }
      local type_labels = { note = "QUESTION", suggestion = "ACTION" }
      for i, c in ipairs(comments) do
        local type_name = type_labels[c.type] or c.type:upper()
        table.insert(md, ("%d. **[%s]** %s\n   Source file: `%s`"):format(i, type_name, c.text, location(c)))
        vim.list_extend(md, excerpt(c))
      end
      return table.concat(md, "\n")
    end

    require("review").setup({
      comment_types = {
        note = { key = "q", name = "Question", icon = "🙋", hl = "ReviewQuestion" },
        suggestion = { key = "a", name = "Action", icon = "💡", hl = "ReviewAction" },
        issue = { key = "i", name = "Issue", icon = "⚠️", hl = "ReviewIssue" },
        praise = { key = "p", name = "Praise", icon = "✨", hl = "ReviewPraise" },
      },
    })

    require("tmux_review").configure_tmux_review()

    vim.api.nvim_create_user_command("ReviewExportCustom", function()
      local review_export = require("review.export")
      local original_generate_markdown = review_export.generate_markdown
      review_export.generate_markdown = function()
        return format_comments(require("review.store").get_all())
      end
      local ok, err = pcall(review_export.to_clipboard)
      review_export.generate_markdown = original_generate_markdown
      if not ok then
        vim.notify("Custom review export failed: " .. tostring(err), vim.log.levels.ERROR)
      end
    end, {})

    vim.api.nvim_set_hl(0, "ReviewQuestion", { link = "DiagnosticInfo", default = true })

    vim.keymap.set("n", "]c", function()
      require("codediff").next_hunk()
    end, { desc = "Next diff change (hunk)" })

    vim.keymap.set("n", "[c", function()
      require("codediff").prev_hunk()
    end, { desc = "Previous diff change (hunk)" })


    -- Review a PR (Review commits <first commit in PR>...HEAD)
    vim.api.nvim_create_user_command("ReviewPR", function(opts)
      local pr_arg = opts.args ~= "" and opts.args or ""

      -- 1. If an explicit PR number was provided, check it out first
      if opts.args ~= "" then
        local checkout_res = vim.fn.system("gh pr checkout " .. opts.args)
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to checkout PR #" .. opts.args .. "\n" .. checkout_res, vim.log.levels.ERROR)
          return
        end
      end

      -- 2. Fetch the first commit OID of the PR (works for current branch if no arg given)
      local cmd = string.format("gh pr view %s --json commits --jq '.commits[0].oid'", pr_arg)
      local first_commit = vim.fn.systemlist(cmd)[1]

      if vim.v.shell_error ~= 0 or not first_commit or first_commit == "" then
        vim.notify("Could not retrieve the first commit for this PR.", vim.log.levels.ERROR)
        return
      end

      -- 3. Launch review.nvim using the exact <first_commit>...HEAD range
      local review_range = string.format("Review commits %s...HEAD", first_commit)
      vim.cmd(review_range)
    end, { nargs = "?" })



    local function review_full_commit_blame()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local cursor_row = vim.api.nvim_win_get_cursor(0)[1]

      if buf_name == "" then
        vim.notify("Buffer has no name.", vim.log.levels.WARN)
        return
      end

      local target_file = buf_name

      -- Handle codediff:// URI prefix cleanup
      if target_file:match("^codediff://") then
        local path_part = target_file:gsub("^codediff://%/*/+", "/")
        local sha_pattern = "/%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x/"
        local _, finish_idx = path_part:find(sha_pattern)
        if finish_idx then
          target_file = path_part:sub(finish_idx + 1)
        else
          target_file = path_part:gsub("^home/", "/home/")
        end
      end

      if not vim.loop.fs_stat(target_file) then
        vim.notify("Could not resolve file on disk: " .. target_file, vim.log.levels.ERROR)
        return
      end

      -- Run git blame for the exact line to get the commit SHA
      local cmd = string.format("git blame -u -L %d,+1 --porcelain %s", cursor_row, vim.fn.shellescape(target_file))
      local output = vim.fn.systemlist(cmd)

      if vim.v.shell_error ~= 0 or #output == 0 then
        vim.notify("Could not retrieve git blame for this line.", vim.log.levels.ERROR)
        return
      end

      local commit_sha = output[1]:match("^(%w+)")
      if not commit_sha or commit_sha:match("^0+$") then
        vim.notify("Line is uncommitted or has no valid commit SHA.", vim.log.levels.WARN)
        return
      end

      -- Open the full commit (message + diff) in a vertical split
      if vim.fn.exists(":Git") == 2 then
        -- Use vim-fugitive for an interactive commit buffer if available
        vim.cmd(string.format("vertical Git show %s", commit_sha))
      else
        -- Fallback: open a vertical split with raw git show output
        vim.cmd("vsplit")
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(win, buf)

        local show_output = vim.fn.systemlist(string.format("git show %s", commit_sha))
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, show_output)
        vim.bo[buf].filetype = "git"
        vim.bo[buf].buftype = "nofile"
      end
    end

    -- Re-bind the command and keymap
    vim.api.nvim_create_user_command("ReviewCommitShow", review_full_commit_blame, {})
    vim.keymap.set("n", "<leader>gC", review_full_commit_blame,
      { desc = "Show full commit & diff for current review line" })
  end
}
