
-- lua/ai.lua

local M = {}

-- Configuration
M.config = {
    gemini_cli_command = "gemini --prompt", -- The base command for Gemini CLI
    use_terminal_by_default = false, -- Set to true to use terminal by default, false for scratch buffer
}

-- Function to run Gemini and display output in a Neovim terminal
function M.run_in_terminal(prompt)
    local command = string.format("%s \"%s\"", M.config.gemini_cli_command, prompt)
    print("Running command in terminal: " .. command)
    vim.cmd("terminal " .. command)
end

-- Function to run Gemini asynchronously and display output in a scratch buffer
function M.run_in_scratch_buffer(prompt)
    local command = string.format("%s \"%s\"", M.config.gemini_cli_command, prompt)
    print("Running command asynchronously for scratch buffer: " .. command)

    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(bufnr, "Gemini Output")
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

    vim.cmd("sbuffer " .. bufnr)

    local job_id = vim.fn.jobstart(command, {
        on_stdout = function(_, data, _)
            vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
            vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
        end,
        on_stderr = function(_, data, _)
            vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "--- ERROR ---" })
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
            vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
        end,
        on_exit = function(_, code, _)
            if code == 0 then
                vim.notify("Gemini command finished successfully!", vim.log.levels.INFO, { title = "Gemini" })
            else
                vim.notify("Gemini command failed with exit code: " .. code, vim.log.levels.ERROR, { title = "Gemini" })
            end
            vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
        end,
        detach = true,
    })

    if job_id == 0 then
        vim.notify("Failed to start Gemini command.", vim.log.levels.ERROR, { title = "Gemini" })
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Failed to start Gemini command." })
    else
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Running Gemini command: " .. command, "", "Output will appear here..." })
    end
end

-- Neovim command definition
vim.api.nvim_create_user_command('Gemini', function(opts)
    local args_str = opts.args
    local prompt = nil
    local use_terminal = M.config.use_terminal_by_default

    -- Check for --terminal flag
    if args_str:match("--terminal") then
        use_terminal = true
        args_str = args_str:gsub("--terminal", ""):gsub("^%s*", ""):gsub("%s*$", "") -- Remove flag and trim spaces
    end

    -- The remaining args_str is the prompt. Remove surrounding quotes if present.
    if args_str:match("^\"(.*)\"$") or args_str:match("^'(.*)'$") then
        prompt = args_str:sub(2, -2)
    else
        prompt = args_str
    end

    if not prompt or prompt == "" then
        vim.notify("Usage: :Gemini \"Your prompt here\" [--terminal]", vim.log.levels.ERROR, { title = "Gemini" })
        return
    end

    if use_terminal then
        M.run_in_terminal(prompt)
    else
        M.run_in_scratch_buffer(prompt)
    end
end, {
    nargs = '+', -- Accept one or more arguments
    complete = "file", -- Placeholder, as we're parsing a string
    desc = "Interact with Gemini AI",
    bang = true, -- Allows ! to force terminal output (though we're using a flag)
    force = true,
})

return M
