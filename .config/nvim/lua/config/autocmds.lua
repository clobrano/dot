vim.cmd[[
" Respace splits on resize
""autocmd VimResized * execute normal! \<c-w>="
" folding method for css, scss
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

" Align function arguments
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Auto-header scripts
augroup Shebang
autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env bash\<nl># -*- coding: UTF-8 -*-\<nl>\"|$
autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python3\<nl># -*- coding: utf-8 -*-\<nl># vi: set ft=python :\<nl>\"|$
autocmd BufNewFile *.rb 0put =\"#!/usr/bin/env ruby\<nl># -*- coding: None -*-\<nl>\"|$
autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
autocmd BufNewFile *.\(cc\|hh\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
augroup END

" open Man and Help page in vertical split
autocmd FileType help wincmd L
autocmd FileType man wincmd L

" open Quickfix window below all splits
au FileType qf wincmd J

" Enter terminal-mode automatically
autocmd TermOpen * startinsert
]]

-- Autocmd to source a nvim.local.lua file if and only if it exists in the current directory

local local_config_group = vim.api.nvim_create_augroup("LocalNvimConfig", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = local_config_group,
  callback = function()
    local current_dir = vim.fn.getcwd()
    local local_config_file = current_dir .. "/nvim.local.lua"
    local stat = vim.uv.fs_stat(local_config_file)

    if stat and stat.type == "file"  then
      local ok, err = pcall(dofile, local_config_file)
      if not ok then
        vim.notify(string.format("Error loading local nvim config: %s", err), vim.log.levels.Error)
      end
    end
  end
})

-- golang settings
vim.api.nvim_create_augroup("go_settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  group = "go_settings",
  callback = function()
    vim.opt_local.makeprg = "go build"
    vim.opt_local.errorformat = "%f:%l:%c: %m"
  end,
})


local big_file_group = vim.api.nvim_create_augroup("BigFileSettings", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = big_file_group,
  pattern = "*",
  callback = function(ev)
    -- Set threshold to 1MB
    local filesize = vim.fn.getfsize(ev.file)
    if filesize > 1024 * 1024 then
      -- 1. Disable undo history (huge memory saver)
      vim.opt_local.undolevels = -1

      -- 2. Disable swap files and autoread
      vim.opt_local.swapfile = false
      vim.opt_local.bufhidden = "unload"

      -- 3. Disable incremental search and folds
      vim.opt_local.syntax = "off"
      vim.opt_local.foldmethod = "manual"
      vim.o.hlsearch = false

      -- 4. Treesitter check (wrapped in pcall to avoid errors if not installed)
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        vim.cmd("TSBufDisable highlight")
        vim.cmd("TSBufDisable indent")
      end

      -- Disable Flash
      local ok, flash_config = pcall(require, "flash")
      if ok then
        flash_config.toggle()
      end

      -- Helpful notification
      vim.notify("Large file detected: Performance mode enabled.", vim.log.levels.WARN)
    end
  end,
})


-- colorscheme for diff view
--vim.api.nvim_create_autocmd("OptionSet", {
  --pattern = "diff",
  --callback = function()
    --if vim.v.option_new == "1" then
      --print("changing colorscheme for diff view")
      --vim.cmd("colorscheme oldbook")
    --else
      ---- Optional: Set it back to your normal theme when diff ends
      --vim.cmd("colorscheme catppuccin")
    --end
  --end,
--})
