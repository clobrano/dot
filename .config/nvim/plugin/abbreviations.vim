cabbr !     split term://
cabbr cs    colorscheme
cabbr einit :edit $MYVIMRC

cabbr pc    Papercolor
cabbr mn    Monokai
cabbr od    colorscheme onehalfdark
cabbr ol    colorscheme onehalflight

" Change directory to current buffer location
cabbr cdhere :lcd %:h

" Shorcuts for stdints
iabbr u8t   uint8_t
iabbr u16t  uint16_t
iabbr u32t  uint32_t
iabbr u64t  uint64_t
iabbr i8t   int8_t
iabbr i16t  int16_t
iabbr i32t  int32_t
iabbr i64t  int64_t

iabbr taska <esc>i⚫<space><C-R>=strftime("%y%02m%02d")<CR><space>(A)
iabbr taskb <esc>i⚫<space><C-R>=strftime("%y%02m%02d")<CR><space>(B)
iabbr taskc <esc>i⚫<space><C-R>=strftime("%y%02m%02d")<CR><space>(C)
iabbr taskd <esc>i⚫<space><C-R>=strftime("%y%02m%02d")<CR><space>(D)
