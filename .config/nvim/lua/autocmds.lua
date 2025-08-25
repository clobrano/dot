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
