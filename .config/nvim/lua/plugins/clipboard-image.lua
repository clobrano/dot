return {
    "postfen/clipboard-image.nvim",
    keys = {
        { "<leader>i", "<cmd>PasteImg<CR>" },
    },
    config = function()
        require 'clipboard-image'.setup {
            -- Default configuration for all filetype
            default = {
                img_dir = { "%:p:h", "attachments" }, -- Use table for nested dir (New feature form PR #20)
                img_name = function()
                    vim.fn.inputsave()
                    local name = vim.fn.input('Image name: ')
                    vim.fn.inputrestore()
                    return name
                end,
                affix = "<\n  %s\n>" -- Multi lines affix
            },
            -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
            -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
            -- Missing options from `markdown` field will be replaced by options from `default` field
            markdown = {
                img_dir = { "%:p:h", "attachments" }, -- Use table for nested dir (New feature form PR #20)
                img_name = function()
                    vim.fn.inputsave()
                    local name = vim.fn.input('Image name: ')
                    vim.fn.inputrestore()
                    return name
                end,
                img_handler = function(img)
                    vim.cmd("normal! f[")    -- go to [
                    vim.cmd("normal! a" .. img.name) -- append text with image name
                end,
                affix = "![](%s)",
            }
        }
    end
}
