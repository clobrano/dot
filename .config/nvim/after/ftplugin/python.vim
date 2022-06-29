setlocal foldmethod=indent
setlocal foldlevel=99
setlocal foldnestmax=2
setlocal makeprg=pytest

augroup black_on_save
  autocmd!
  autocmd BufWritePre *.py Black
augroup end
