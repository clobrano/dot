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
    { "<leader>rn", ":Review note<cr>",        mode = { "n", "v" },            desc = "Review: note here" },
    { "<leader>re", "<cmd>Review edit<cr>",    desc = "Review: edit comment" },
    { "<leader>rd", "<cmd>Review delete<cr>",  desc = "Review: delete comment" },
    { "<leader>rx", "<cmd>Review export<cr>",  desc = "Review: export" },
  },
  config = function()
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
