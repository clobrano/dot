" align block of text {{{
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<
" }}}

" buffer open alternate file (ex. .c/.cpp <-> .h)
nnoremap <space>a :FSHere<cr>
nnoremap <space>la :FSSplitRight<cr>


" buffer: save, close {{{
inoremap <C-s>      <Esc>:w<CR>
noremap <C-s>       <Esc>:w<CR>
nnoremap x          <Esc>:bd
nnoremap xx         <Esc>:bd<CR>
nnoremap <leader>fx <Esc>:bd!<CR>
nnoremap x1         m1:bd<cr>
nnoremap x2         m2<cr>:bn<cr>:bd<cr>
nnoremap x3         m3<cr>:2bn<cr>:bd<cr>
nnoremap x4         m4<cr>:3bn<cr>:bd<cr>
nnoremap x5         m5<cr>:4bn<cr>:bd<cr>
nnoremap x6         m6<cr>:5bn<cr>:bd<cr>
nnoremap x7         m7<cr>:6bn<cr>:bd<cr>
nnoremap x8         m8<cr>:7bn<cr>:bd<cr>
nnoremap x9         m9<cr>:8bn<cr>:bd<cr>
"}}}


" variale definition in command line
nnoremap I [i
" clipboard yank
vnoremap Y "+y<CR>
" clipboard paste
nnoremap P "+p

" directory explore
nnoremap <leader>exp <esc>:Lexplore<cr>
" directory change here
nnoremap <leader>here :lcd %:p:h<CR>

" enter command mode
nnoremap ; :
vnoremap ; :
inoremap <C-c> <c-x><c-o>

" no ex-mode
nnoremap Q <nop>

" move between buffers {{{
noremap <A-Left>  <Esc>:bprevious<CR>
noremap <A-Right> <Esc>:bnext<CR>
noremap H         <Esc>:bprevious<CR>
noremap L         <Esc>:bnext<CR>
nnoremap <c-b>    <esc>:b<space>
nnoremap m1       :bfirst<cr>
nnoremap m2       :bfirst<cr>:bn<cr>
nnoremap m3       :bfirst<cr>:2bn<cr>
nnoremap m4       :bfirst<cr>:3bn<cr>
nnoremap m5       :bfirst<cr>:4bn<cr>
nnoremap m6       :bfirst<cr>:5bn<cr>
nnoremap m7       :bfirst<cr>:6bn<cr>
nnoremap m8       :bfirst<cr>:7bn<cr>
nnoremap m9       :bfirst<cr>:8bn<cr>
" }}}

" highlight current word
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" move: fix weird chars in terminal using arrow keys in insert mode {{{
inoremap [1;5A <esc>ki
inoremap [1;5C <esc>li
inoremap [1;5B <esc>ji
inoremap [1;5D <esc>hi
"}}}

" move to next/prev error
nnoremap [e :lprev<cr>
nnoremap ]e :lnext<cr>

" move to next/prev build error
nnoremap [b :cprev<cr>
nnoremap ]b :cnext<cr>

" move: always move line by line, regardless wrap {{{
noremap <silent> k gk
noremap <silent> j gj
"}}}

" move fast {{{
nnoremap <C-l> w
nnoremap <C-h> b
nnoremap <C-k> 10k
nnoremap <C-j> 10j
nnoremap E $
vnoremap E $
nnoremap B ^
vnoremap B ^
"}}}

" move to previous buffer
nnoremap <leader>p <C-^>



" move between tabs {{{
nnoremap tn gt
nnoremap tb gT
"}}}

" normal mode enter
inoremap jj <Esc>

" replace current word with confirmation and magic \v
nnoremap c* <esc>:%s/\v//gc<left><left><left><left><C-r><C-w><right>

" replace in all buffer
noremap rep <Esc>:%s/\v/gc<Left><Left><Left>

" resize vertical window splits {{{
nnoremap <silent> + :exe "resize +2"<CR>
nnoremap <silent> - :exe "resize -2"<CR>
"}}}

" sudo save
cmap w!! w !sudo tee > /dev/null %

" search word in all visible filesystem
nnoremap fa <Esc>:Ack! --ignore-dir=TAGS --ignore-dir=tags --ignore-dir=cscope.* ""<left>

" search word under cursor in all visible filesystem
nnoremap fc <Esc>:Ack! --ignore-dir=TAGS --ignore-dir=tags --ignore-dir=cscope.* ""<left><C-r><C-w>

" search for selected text, forwards or backwards. {{{
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
  \``
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
nnoremap <leader><space> :nohlsearch<CR>
"}}}

" search or go to Next/Prev match {{{
nnoremap fn <esc>/\v
vnoremap fn y/<C-r>"<cr>
nnoremap fp <esc>?
vnoremap fp y?<C-r>"<cr>
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
"}}}

" search file
nnoremap <leader>ff :find **/*

" select all
nnoremap <leader>va ggvGE

" close right split
nnoremap xl <C-w>l:bd<CR>
" close left split
nnoremap xh <C-w>h:bd<CR>
" close split below
nnoremap xj <C-w>j:bd<CR>
" close split above
nnoremap xk <C-w>k:bd<CR>
" keep only current split
nnoremap <leader>o <C-w>o
" maximize current split
nnoremap <C-w>m <C-w>\|<C-w>_

" convert horizontal splits to vertical and vice versa
nnoremap <leader>htv <C-w>t<C-w>H
nnoremap <leader>vth <C-w>t<C-w>K

" moves between splits {{{
nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l
"}}}

" open split on current tag
nnoremap D <C-w>}


" reload vimrc
nnoremap <silent> <leader>vr :source ~/.vimrc<CR>:exe ":echo 'vimrc reloaded'"<CR>:e<CR>
" reload vim and install plugins
nnoremap <silent> <leader>V  :source ~/.vimrc<CR>:PlugInstall<CR>:exe ":echo 'vimrc reloaded'"<CR>

" load vimrclocal {{{
if filereadable(expand('vimrc.local'))
    exe 'source vimrc.local'
endif
command! Svimrc :!cat vimrc.local
command! Evimrc :e vimrc.local
command! Lvimrc :exe 'source vimrc.local'
iabbr evimrc Evimrc
iabbr svimrc Svimrc
iabbr lvimrc Lvimrc
"}}}

" exit vim
nnoremap qa <esc>:qa
" force exit vim
nnoremap qx <esc>:qa!
" Don't know what this is...
xnoremap <silent> p p:let @+=@0<CR>



