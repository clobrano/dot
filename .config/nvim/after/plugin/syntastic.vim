if isdirectory($HOME . "/.config/nvim/plugged/syntastic")
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_c_checkers=['clang_check', 'cppcheck']
    let g:syntastic_cpp_checkers=['clang_check', 'cppcheck']
    let g:syntastic_python_checkers=['flake8']
endif
