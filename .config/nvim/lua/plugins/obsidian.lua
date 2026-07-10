return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",

    -- see below for full list of optional dependencies 👇
  },
  config = function(_, opts)
    -- First setup obsidian with the provided opts
    require("obsidian").setup(opts)

    -- Obsidian keymaps
    vim.keymap.set('n', '<leader>on', ':ObsidianNew<cr>', { silent = true, noremap = true })

    -- Now setup the markdown_refs completion source
    local cmp = require("cmp")
    local markdown_refs_source = {}

    function markdown_refs_source:get_trigger_characters()
      return { "!" }
    end

    function markdown_refs_source:get_keyword_pattern()
      return [=[\![^\]]*]=]
    end

    function markdown_refs_source:is_available()
      return vim.bo.filetype == "markdown"
    end

    function markdown_refs_source:complete(request, callback)
      local items = {}

      local has_obsidian, obsidian = pcall(require, "obsidian")
      if not has_obsidian then return callback({ items = items }) end

      -- Safely get the client, handling cases where it's not initialized yet
      local ok, client = pcall(obsidian.get_client)
      if not ok or not client or not client.dir then return callback({ items = items }) end

      local vault_root = tostring(client.dir)
      local refs_file = vault_root .. "/Bookmarks.md"

      if vim.fn.filereadable(refs_file) == 1 then
        for line in io.lines(refs_file) do
          local ref_name = string.match(line, "^%[(.-)%]:")

          if ref_name then
            table.insert(items, {
              label = "[" .. ref_name .. "]",
              filterText = "!" .. ref_name,
              insertText = "[" .. ref_name .. "]",
              kind = cmp.lsp.CompletionItemKind.Reference,
              detail = "Vault Reference Link",
              score = 100000,
            })
          end
        end
      end

      callback({ items = items })
    end

    cmp.register_source("markdown_refs", markdown_refs_source)

    -- Setup bookmark management commands
    require("config.markdown_bookmarks").setup()
  end,
  opts = {
    workspaces = vim.tbl_filter(
      function(ws) return vim.fn.isdirectory(vim.fn.expand(ws.path)) == 1 end,
      {
        { name = "work",     path = "~/Documents/RedHatNotes" },
        { name = "personal", path = "~/Me/Notes" },
      }
    ),
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    -- let render-markdown ONLY manage UI for the following objects
    ui = {
      enable = true,                   -- Lascia attiva la UI per i link e il resto
      bullets = { enable = false },    -- Disabilita i punti elenco di obsidian.nvim
      checkboxes = { enable = false }, -- Disabilita le checkbox di obsidian.nvim
      hl_groups = {
        ObsidianRefText = { fg = "#89ddff" },
      },
    },
    -- Use the wiki link text as the file name for new notes
    note_id_func = function(title)
      if title ~= nil then
        -- Replace characters that are invalid in filenames, but keep spaces
        return title:gsub("[/\\:*?\"<>|]", "")
      else
        return tostring(os.time())
      end
    end,
    follow_url_func = function(url)
      vim.ui.open(url)
    end,
    -- Place new notes based on frontmatter 'folder' field
    note_path_func = function(spec)
      local client = require("obsidian").get_client()
      local vault = client.dir

      -- Check if frontmatter specifies a target folder
      if spec.dir then
        return vault / spec.dir / tostring(spec.id)
      end

      -- Default behavior
      if tostring(vault):find("RedHatNotes") then
        return vault / "Resources" / tostring(spec.id)
      else
        return vault / "3-Resources" / tostring(spec.id)
      end
    end,
    note_frontmatter_func = function(note)
      local out = {}

      -- keep personalized metadata
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      -- Only update 'modified' if the buffer has actual changes
      if vim.bo.modified and note.metadata ~= nil and note.metadata.modified ~= nil then
        out.modified = os.date("%Y-%m-%d")
      elseif note.metadata ~= nil and note.metadata.modified ~= nil then
        out.modified = note.metadata.modified
      else
        out.modified = os.date("%Y-%m-%d")
      end

      if note.metadata ~= nil and note.metadata.created ~= nil then
        out.created = note.metadata.created
      else
        -- Use the file's actual creation date from the filesystem
        local created = os.date("%Y-%m-%d")
        if note.path then
          local stat = vim.uv.fs_stat(tostring(note.path))
          if stat then
            local ts = (stat.birthtime and stat.birthtime.sec > 0) and stat.birthtime.sec or stat.mtime.sec
            created = os.date("%Y-%m-%d", ts)
          end
        end
        out.created = created
      end

      -- add per-vault journal metadata
      if tostring(note.path):find("Journal") then
        local client = require("obsidian").get_client()
        local vault = client.dir
        local default_metadata = {}

        if tostring(vault):find("RedHatNotes") then
        else
          default_metadata.backpain = 0
        end
        for k, v in pairs(default_metadata) do
          if out[k] == nil then
            out[k] = v
          end
        end
      end

      return out
    end,
  },
}
