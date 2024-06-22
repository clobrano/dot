return {
  -- needs plantUML and imv installed
  'Groveer/plantuml.nvim',
  config = function()
    -- calling `setup` is optional for customization
    require('plantuml').setup({})
  end
}
