inoremap [[ []<left>
inoremap (( ()<left>
inoremap {{ {}<left><cr><cr><up><tab>

" variable definition in command line
nnoremap I [i
nnoremap <leader>I :TlistShowPrototype<cr>

" align block of text {{{
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<
" }}}

" open link in browser
nnoremap <leader>w :silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\|%")<CR><CR>

" buffer: delete till the end of the line
nnoremap X vg_x

" buffer: motion {{{
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

" buffer: reload
nnoremap <leader>e :e<cr>
nnoremap ct :checktime<cr>

" buffer: open alternate file (ex. .c/.cpp <-> .h)
nnoremap <leader>a :FSHere<cr>
nnoremap <leader>av :FSSplitRight<cr>

" buffer select ALL
"nnoremap C :%y+<cr>
nnoremap C ggvG$

" buffer: show full path
nnoremap <leader>g :echo expand('%')<cr>
" buffer: copy full path
nnoremap <leader>G :let @" = expand("%")<cr>


" buffer: close {{{
nnoremap x          <Esc>:bd
nnoremap xx         <Esc>:bd<CR>
nnoremap x1         m1:bd
nnoremap x2         m2<cr>:bn<cr>:bd
nnoremap x3         m3<cr>:2bn<cr>:bd
nnoremap x4         m4<cr>:3bn<cr>:bd
nnoremap x5         m5<cr>:4bn<cr>:bd
nnoremap x6         m6<cr>:5bn<cr>:bd
nnoremap x7         m7<cr>:6bn<cr>:bd
nnoremap x8         m8<cr>:7bn<cr>:bd
nnoremap x9         m9<cr>:8bn<cr>:bd
"}}}

" buffer: save {{{
inoremap <C-s>      <Esc>:w<CR>
noremap <C-s>       <Esc>:w<CR>
"}}}

" register 0 hold latest Yank, let's map yp to `"0p`
nnoremap yp "0p
" clipboard yank till the end of the line
vnoremap Y "+y
" clipboard paste
nnoremap P "+p

" colorscheme
nnoremap <leader>mk    :Monokai<cr>
nnoremap <leader>pc    :Papercolor<cr>
nnoremap <leader>ol    :colorscheme onehalflight<cr>
nnoremap <leader>od    :colorscheme dracula<cr>

" directory explore
nnoremap <leader>ex <esc>:Explore<cr>
" directory change here
nnoremap <leader>here :lcd %:p:h<CR>

" edit font (effects on GUI only)
nnoremap <leader>ef :set guifont=Ubuntu\ Mono:h12

" edit: remove trailing space
nnoremap <leader>ss :StripWhitespace<cr>

" enter command mode
nnoremap ; :
vnoremap ; :
inoremap <C-c> <c-x><c-o>

" no ex-mode
nnoremap Q <nop>

" execute current line as command in bash (ex. zathura path/to/pdf -P 10)
nnoremap <leader>z :.w !bash<cr>
nnoremap <leader>Z :.w !sudo bash<cr>

" execute external command
nnoremap ! :!
" exit vim
nnoremap qa <esc>:qa

" execute current file. This is used mostly for C source code, the mapping
" expects that a binary file with the same root name of the current buffer
" file exists and execute it. To avoid running code by mistake, the enter
" input <cr> is not present.
nnoremap <leader>x :split term:// %:p:r
nnoremap <leader>X :split term:// sudo %:p:r

" fold: always toggle all fold at current position
nnoremap za zA
" toggle folding
nnoremap <leader>z zA

" git diff shortcuts: enhance diff put and diff obtain moving automatically to
" the next change
nnoremap dp dp]c
nnoremap do do]c

" highlight selected word
vnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" highlight current word and do not move to next match
nnoremap * *``

" jumplist: store relative line number jumps if they exceed a thresholt (thanks Wincent)
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" macro repeat last in normal buffer.
nnoremap <expr> <cr> empty(&buftype) ? '@@' : '<cr>'

" make
nnoremap <F3> :make<cr>

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


" move: always move line by line, regardless wrap
noremap <silent> k gk
noremap <silent> j gj


" move fast
nnoremap <C-l> 10l
nnoremap <C-h> 10h
nnoremap <C-k> 10k
nnoremap <C-j> 10j
nnoremap E $
vnoremap E $
nnoremap B ^
vnoremap B ^


" move to previous buffer
nnoremap <leader>p <C-^>


" move between tabs
nnoremap tn gt
nnoremap tb gT
nnoremap <M-l> gt
nnoremap <M-h> gT


" normal mode enter (map both jj and kk so that I can type j and `Esc` with kk)
inoremap jj <Esc>
inoremap kk <Esc>

" Notes (see plugin/tasks)

" open file with xdg-open (e.g. images in markdown files)
nnoremap <leader>gx :!xdg-open %:p:h/<cfile>

" replace current word with confirmation and magic \v
nnoremap <leader>c* <esc>:%s///gc<left><left><left><left><C-r><C-w><right>
vnoremap <leader>c* y<esc>:%s///gc<left><left><left><left><C-r>"<right>

" replace in all buffer
noremap rep <Esc>:%s//gc<Left><Left><Left>

" resize vertical window splits {{{
nnoremap <silent> + :exe "resize +2"<CR>
nnoremap <silent> - :exe "resize -2"<CR>
"}}}

" sudo save
cmap w!! w !sudo tee > /dev/null %

" search word in all visible filesystem
nnoremap fa <Esc>:grep! ""<left>

" search word under cursor in all visible filesystem
nnoremap fc <Esc>:grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

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
nnoremap fn /
vnoremap fn y/<C-r>"<cr>
nnoremap fp <esc>?
vnoremap fp y?<C-r>"<cr>
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
"}}}

" search file
"if ! executable('fzf')
    "nnoremap <leader>ff :find **/*
"endif

" select till the end of the line
vnoremap T $h

"close current split without closing the buffer
nnoremap cl :close<cr>
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
nnoremap <leader>tv <C-w>t<C-w>H
nnoremap <leader>th <C-w>t<C-w>K

" moves between splits {{{
nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l
"}}}

" reload vimrc
nnoremap <silent> <leader>vr :source $MYVIMRC<CR>:exe ":echo 'vimrc reloaded'"<CR>:e<CR>
" reload vim and install plugins
nnoremap <silent> <leader>V  :source $MYVIMRC<CR>:PlugInstall<CR>:exe ":echo 'vimrc reloaded'"<CR>
" reload syntax
nnoremap <silent> <leader>r  :syntax sync fromstart

" tag open in split
nnoremap D <C-w>}

" tag jump to occurence if there's only one (use always tselect instead of tag)
nnoremap <C-]> g<C-]>

" yank till the end of the line
nnoremap Y yg_


" Don't know what this is...
xnoremap <silent> p p:let @+=@0<CR>
