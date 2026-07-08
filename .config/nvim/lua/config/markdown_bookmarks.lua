-- File: lua/config/markdown_bookmarks.lua
-- Support for Bookmarks in Neovim.
-- AddBookmark: adds a bookmark to Bookmarks.md as Markdown reference links
-- FindBookmarks: fuzzy find the bookmarks, and either open the link or copy the URL
-- Use function Open_markdown_reference_url to open the link under the cursor, or use FindBookmarks

local M = {}

function M.setup()
  -- Note: markdown_refs cmp source is now registered in obsidian.lua

    -- Helper function to get bookmarks file path
    local function get_bookmarks_file()
      local has_obsidian, obsidian = pcall(require, "obsidian")
      if not has_obsidian then return nil end

      -- Safely get the client, handling cases where it's not initialized yet
      local ok, client = pcall(obsidian.get_client)
      if not ok or not client or not client.dir then return nil end

      return tostring(client.dir) .. "/Bookmarks.md"
    end

    -- Command to add a new bookmark
    vim.api.nvim_create_user_command("AddBookmark", function(opts)
      local bookmarks_file = get_bookmarks_file()
      if not bookmarks_file then
        vim.notify("Could not locate Obsidian vault", vim.log.levels.ERROR)
        return
      end

      -- Get reference name (first argument or prompt)
      local ref_name = opts.fargs[1]
      if not ref_name then
        ref_name = vim.fn.input("Reference name: ")
        if ref_name == "" then return end
      end

      -- Get URL (second argument or prompt)
      local url = opts.fargs[2]
      if not url then
        url = vim.fn.input("URL: ")
        if url == "" then return end
      end

      -- Format the bookmark entry
      local bookmark_entry = string.format("[%s]: %s", ref_name, url)

      -- Append to file
      local file = io.open(bookmarks_file, "a")
      if file then
        file:write(bookmark_entry .. "\n")
        file:close()
        vim.notify(string.format("Added bookmark: [%s]", ref_name), vim.log.levels.INFO)
      else
        vim.notify("Could not write to Bookmarks.md", vim.log.levels.ERROR)
      end
    end, {
      nargs = "*",
      desc = "Add a new bookmark to Bookmarks.md",
    })

    -- Command to open Bookmarks.md
    vim.api.nvim_create_user_command("OpenBookmarks", function()
      local bookmarks_file = get_bookmarks_file()
      if not bookmarks_file then
        vim.notify("Could not locate Obsidian vault", vim.log.levels.ERROR)
        return
      end

      if vim.fn.filereadable(bookmarks_file) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(bookmarks_file))
      else
        vim.notify("Bookmarks.md not found", vim.log.levels.ERROR)
      end
    end, {
      desc = "Open Bookmarks.md file",
    })

    -- Helper function to parse bookmarks
    local function parse_bookmarks()
      local bookmarks_file = get_bookmarks_file()
      if not bookmarks_file or vim.fn.filereadable(bookmarks_file) ~= 1 then
        return {}
      end

      local bookmarks = {}
      for line in io.lines(bookmarks_file) do
        local ref_name, url = string.match(line, "^%[(.-)%]:%s*(.+)$")
        if ref_name and url then
          table.insert(bookmarks, {
            name = ref_name,
            url = vim.trim(url),
            display = string.format("%-30s  %s", ref_name, url),
          })
        end
      end
      return bookmarks
    end

    -- Command to fuzzy find bookmarks
    vim.api.nvim_set_keymap('n', '<leader>bf', ':FindBookmarks<cr>', { desc='[B]ookmarks [F]ind', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ba', ':AddBookmark<cr>', { desc='[B]ookmarks [A]dd', noremap = true, silent = true })
    vim.api.nvim_create_user_command("FindBookmarks", function()
      vim.notify("FindBookmarks called", vim.log.levels.DEBUG)

      local has_fzf, fzf = pcall(require, "fzf-lua")
      if not has_fzf then
        vim.notify("fzf-lua is not installed", vim.log.levels.ERROR)
        return
      end

      local bookmarks = parse_bookmarks()
      vim.notify(string.format("Found %d bookmarks", #bookmarks), vim.log.levels.DEBUG)

      if #bookmarks == 0 then
        vim.notify("No bookmarks found in Bookmarks.md", vim.log.levels.WARN)
        return
      end

      -- Helper to copy to system clipboard
      local function copy_to_clipboard(text)
        -- Use OSC 52 for remote sessions, or system clipboard tools
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

      -- Helper to find bookmark by display line
      local function find_bookmark(line)
        -- Extract everything before the double space separator (%-30s in display format)
        local ref_name = vim.trim(line:match("^(.-)%s%s+"))
        if not ref_name then
          ref_name = vim.trim(line)
        end
        vim.notify(string.format("Looking for ref_name: '%s' from line: '%s'", ref_name, line), vim.log.levels.DEBUG)
        for _, bookmark in ipairs(bookmarks) do
          vim.notify(string.format("Comparing with bookmark.name: '%s'", bookmark.name), vim.log.levels.DEBUG)
          if bookmark.name == ref_name then
            return bookmark
          end
        end
        vim.notify("No match found", vim.log.levels.DEBUG)
        return nil
      end

      -- Prepare entries for fzf
      local entries = {}
      for _, bookmark in ipairs(bookmarks) do
        table.insert(entries, bookmark.display)
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
          local bookmark = find_bookmark(items[1])
          if bookmark then
            return string.format("Name: %s\nURL:  %s\n\nMarkdown link: [%s](%s)",
              bookmark.name, bookmark.url, bookmark.name, bookmark.url)
          end
          return ""
        end,
        actions = {
          ["default"] = function(selected, opts)
            vim.notify(string.format("Default action called with: %s", vim.inspect(selected)), vim.log.levels.DEBUG)
            if not selected or #selected == 0 then
              vim.notify("No selection", vim.log.levels.WARN)
              return
            end
            local bookmark = find_bookmark(selected[1])
            if bookmark then
              vim.notify(string.format("Found bookmark: %s -> %s", bookmark.name, bookmark.url), vim.log.levels.DEBUG)
              -- Open URL in background
              vim.fn.jobstart({"xdg-open", bookmark.url}, {
                detach = true,
                on_exit = function(_, exit_code)
                  vim.schedule(function()
                    vim.notify(string.format("xdg-open exit code: %d for %s", exit_code, bookmark.url), vim.log.levels.INFO)
                  end)
                end
              })
            else
              vim.notify("Bookmark not found", vim.log.levels.WARN)
            end
          end,
          ["ctrl-y"] = function(selected, opts)
            vim.notify(string.format("Ctrl-y action called with: %s", vim.inspect(selected)), vim.log.levels.DEBUG)
            if not selected or #selected == 0 then return end
            local bookmark = find_bookmark(selected[1])
            if bookmark then
              copy_to_clipboard(bookmark.url)
              vim.notify(string.format("Yanked URL: %s", bookmark.url), vim.log.levels.INFO)
            end
          end,
          ["alt-y"] = function(selected, opts)
            vim.notify(string.format("Alt-y action called with: %s", vim.inspect(selected)), vim.log.levels.DEBUG)
            if not selected or #selected == 0 then return end
            local bookmark = find_bookmark(selected[1])
            if bookmark then
              local md_link = string.format("[%s](%s)", bookmark.name, bookmark.url)
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
end

return M
