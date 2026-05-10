return {
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = {
        { path = '~/Documents/RedHatNotes',
          syntax = 'markdown',
          ext = '.md',
          diary_rel_path =  'Journal/',
          diary_frequency = 'weekly',
          auto_diary_index = 1,
          auto_tags = 1,
          auto_generate = 1,
          auto_generate_links = 1,
        },
        { path = '~/Me/Notes',
          syntax = 'markdown',
          ext = '.md',
          diary_rel_path =  'Journal/',
          diary_frequency = 'daily',
          auto_diary_index = 1,
          auto_tags = 1,
          auto_generate = 1,
          auto_generate_links = 1,
        }
      }
      vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown', ['.markdown'] = 'markdown', ['.mdown'] = 'markdown' }
      vim.g.vimwiki_use_mouse = 1
      vim.g.vimwiki_markdown_link_ext = 1
      vim.g.vimwiki_hl_headers = 1
      vim.opt.concealcursor = 'c'
      vim.g.vimwiki_folding = 'list'

	  vim.keymap.set('n', '<C-space>', ':VimwikiToggleListItem<cr>')
    end,
	config = function()
	  -- taskwarrior abbreviation to append to each tasks that does not belong to a Todo viewport
	  vim.cmd('abb ttw -- pro: #W:')
	end
  },
}
