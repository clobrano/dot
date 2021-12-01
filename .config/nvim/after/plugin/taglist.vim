let Tlist_Auto_Highlight_Tag=1
let Tlist_Auto_Update=1
let Tlist_Display_Prototype=0
let Tlist_Enable_Fold_Column=0
let Tlist_Inc_Winwidth=1
let Tlist_Show_One_File=1
let Tlist_WinWidth=50
let Tlist_Compact_Format=1
"let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
" let Tlist_Process_File_Always=1 this shall be in init.vim, otherwise for
" some reason it is not executed unless the plugin is loaded first

nnoremap <leader>to :TlistOpen<cr>
nnoremap <leader>tc :TlistClose<cr>

autocmd FileType taglist set norelativenumber

