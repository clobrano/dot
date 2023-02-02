" toggle background
nnoremap <F4> :call ToggleBackground()<cr>
" toggle transparent background
nnoremap <F8> :hi Normal guibg=none ctermbg=none<cr>
" variable definition in command line
nnoremap <leader>fi [i
nnoremap <leader>fI :TlistShowPrototype<cr>

" align block of text.
vnoremap < <gv
vnoremap > >gv
nnoremap > >>
nnoremap < <<

" buffer: delete till the end of the line
nnoremap X vg_x

" buffer: motion
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
" buffer: reload
nnoremap <leader>e :e<cr>
nnoremap ct :checktime<cr>

" buffer select ALL
"nnoremap C :%y+<cr>
nnoremap C ggvG$

" buffer: show full path
nnoremap <leader>g :echo expand('%')<cr>
" buffer: copy full path
nnoremap <leader>G :!echo % \| xclip -sel clipboard<cr>


" buffer: close
nnoremap xx :bd<CR>
nnoremap x1 :m1:bd
nnoremap x2 :m2<cr>:bn<cr>:bd
nnoremap x3 :m3<cr>:2bn<cr>:bd
nnoremap x4 :m4<cr>:3bn<cr>:bd
nnoremap x5 :m5<cr>:4bn<cr>:bd
nnoremap x6 :m6<cr>:5bn<cr>:bd
nnoremap x7 :m7<cr>:6bn<cr>:bd
nnoremap x8 :m8<cr>:7bn<cr>:bd
nnoremap x9 :m9<cr>:8bn<cr>:bd
" buffer: close all buffers except the current one
nnoremap <leader>bdo :%bd<CR><C-O>:bd#<CR>
" end buffer: close

" buffer: save
inoremap <C-s>  <Esc>:write<CR>
noremap <C-s>   <Esc>:write<CR>
noremap ss   <Esc>:write<CR>
"

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

" vimdiff
nnoremap <leader>do :call ToggleDiff()<cr>


" edit font (effects on GUI only)
nnoremap <leader>ef :set guifont=

" edit: remove trailing space
nnoremap <leader>ss :TrimTrailingSpaces<cr>

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

nnoremap <leader>x :15Term<cr>
nnoremap <leader>vx :VTerm<cr>

" fold: always toggle all fold at current position
nnoremap za zA
" toggle folding
nnoremap <leader>z zA

" git diff shortcuts: enhance diff put and diff obtain moving automatically to
" the next change
nnoremap dp dp]c
nnoremap do do]c
nnoremap <leader>wds :windo diffthis
nnoremap <leader>wdo :windo diffoff

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
nnoremap <C-l> w
nnoremap <C-h> b
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
noremap rep <Esc>:%s/

" resize vertical window splits {{{
nnoremap <silent> + :exe "resize +2"<CR>
nnoremap <silent> - :exe "resize -2"<CR>
"}}}

" sudo save
cmap w!! w !sudo tee > /dev/null %

" search with * with smartcase (if set): Store cword in search register, with
" search-magic and boundaries, then search forward and go to next
nnoremap * :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=1<cr>n``
nnoremap # :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=0<cr>n``
nnoremap g* :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=1<cr>n``
nnoremap g# :let @/='\v<'.expand('<cword>').'>'<cr>:let v:searchforward=0<cr>n``

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

"close splits
nnoremap cl :close<cr>
nnoremap xl <C-w>l:close<CR>
nnoremap xh <C-w>h:close<CR>
nnoremap xj <C-w>j:close<CR>
nnoremap xk <C-w>k:close<CR>
" keep only current split
nnoremap <leader>o <C-w>o
" maximize current split
nnoremap <C-w>m <C-w>\|<C-w>_

" toggle highlight word under cursor
nnoremap <leader>hw :call ToggleHlCurWord()<cr>

" convert horizontal splits to vertical and vice versa
nnoremap <leader>tv <C-w>t<C-w>H
nnoremap <leader>th <C-w>t<C-w>K

" moves between splits
nnoremap mh <C-w>h
nnoremap mj <C-w>j
nnoremap mk <C-w>k
nnoremap ml <C-w>l

" move selected lines up and down
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

" quickfix (and local) window mapping to open at the full bottom (even with splits)
nnoremap <leader>co :Copen<cr>
nnoremap <leader>lo :botright lwindow<cr>

" reload vimrc
nnoremap <silent> <leader>vr :source $MYVIMRC<CR>:exe ":echo 'vimrc reloaded'"<CR>:e<CR>
" reload vim and install plugins
nnoremap <silent> <leader>V  :source $MYVIMRC<CR>:PlugInstall<CR>:exe ":echo 'vimrc reloaded'"<CR>

" scrollbind
nnoremap <leader>sb :call ToggleScrollBind()<cr>

" tag open in split
nnoremap D <C-w>}

" tag jump to occurence if there's only one (use always tselect instead of tag)
nnoremap <C-]> g<C-]>

" yank till the end of the line
nnoremap Y yg_


" Don't know what this is...
xnoremap <silent> p p:let @+=@0<CR>
