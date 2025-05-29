local function spell()
  if vim.wo.spell == true then -- Note that 'spell' is a window option, so: wo
    return '[' .. vim.bo.spelllang .. ']'
  end
  return ''
end

local function is_git_repo()
  local result = vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error ~= 0 then
    return false
  else
    return true
  end
end

local function get_git_user()
  local result = vim.fn.systemlist("git config user.email")
  if #result == 0 then
    return ""
  else
    return result[1]
  end
end

local function get_icon_for_user()
  if not is_git_repo() then
    return ""
  end

  local user = get_git_user()
  if string.find(user, "gmail.com") then
    return " "
  elseif string.find(user, "redhat.com") then
    return " "
  else
    return " "
  end
end

-- in this lualine configuration file, I want a function
-- that returns the currently configured LLM. This
-- information is available in require('gen').GetLLMModel
-- custom function, but we don't know if when executing this
-- lualine configuration file, the `gen.nvim` configuration 
-- from GetLLMModel comes, was already loaded

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '\\', right = '/'},
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = {'branch'},
            --lualine_b = { get_icon_for_user },
            lualine_b = { {'filename', path = 1} },
            lualine_c = {},
            lualine_x = {'diff', 'diagnostics', spell},
            lualine_y = {'progress', 'searchcount'},
            lualine_z = {'location'}
        },
    },
}
