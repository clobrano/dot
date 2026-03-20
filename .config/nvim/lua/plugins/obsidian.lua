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

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "work",
        path = "~/Documents/RedHatNotes",
      },
      {
        name = "personal",
        path = "~/Me/Notes",
      },
    },
    -- let render-markdown ONLY manage UI for the following objects
    ui = {
      enable = true,                   -- Lascia attiva la UI per i link e il resto
      bullets = { enable = false },    -- Disabilita i punti elenco di obsidian.nvim
      checkboxes = { enable = false }, -- Disabilita le checkbox di obsidian.nvim
    },
    -- Place new notes in the workspace's resources folder
    note_path_func = function(spec)
      local vault = spec.dir
      if tostring(vault):find("RedHatNotes") then
        return vault / "Resources" / tostring(spec.id)
      else
        return vault / "3-Resources" / tostring(spec.id)
      end
    end,
    note_frontmatter_func = function(note)
      local out = {
        modified = os.date("%Y-%m-%d")
      }

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

      -- keep personalized metadata
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          if out[k] == nil then
            out[k] = v
          end
        end
      end

      return out
    end,
  },
}
