return {
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = {
        { path = '~/Documents/RedHatVault', syntax = 'markdown', ext = '.md', diary_rel_path =  'Journal/', auto_diary_index = 1 }
      }
      vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown', ['.markdown'] = 'markdown', ['.mdown'] = 'markdown' }
      vim.g.vimwiki_use_mouse = 1
      vim.g.vimwiki_markdown_link_ext = 1
    end,
  },
}
