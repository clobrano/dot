require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "python", "go", "vim", "rust" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { }, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { },  -- list of language that will be disabled
    },
}