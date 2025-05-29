return {
  -- Custom Parameters (with defaults)
  "David-Kunz/gen.nvim",

  config = function()
    require('gen').setup({
      model = "qwen3:latest", -- The default model to use.
      quit_map = "q",         -- set keymap to close the response window
      retry_map = "<c-r>",    -- set keymap to re-send the current prompt
      accept_map = "<c-cr>",  -- set keymap to replace the previous selection with the last result
      host = "192.168.1.247", -- The host running the Ollama service.
      port = "11434",         -- The port on which the Ollama service is listening.
      --port = "8000",                  -- The port on which the Ollama service is listening.
      display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = true,     -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
      show_model = true,      -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false,  -- Never closes the window automatically.
      file = false,           -- Write the payload to a temporary file to keep the command short.
      hidden = false,         -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
      --init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
        --return "curl --silent --no-buffer -H 'accept: application/json' -H 'Content-Type: application/json' -X POST http://" .. options.host .. ":" .. options.port .. "/v1/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      result_filetype = "markdown", -- Configure filetype of the result buffer
      debug = false                 -- Prints errors and the command which is run.
    })

    vim.api.nvim_create_user_command("GetLLMModel", function()
      return require('gen').model
    end, {})

    -- change model at runtime
    vim.api.nvim_create_user_command("ChangeModel", function()
      local gen = require('gen')
      local cmd = "curl --silent http://" .. gen.host .. ":" .. gen.port .. "/api/tags | jq -r '.models[].name'"
      local result = vim.fn.systemlist(cmd)
      if #result == 0 then
        print("No LLMs found")
        return
      end
      vim.ui.select(result, {prompt = "Available LLMs (current selection: " .. gen.model .."): "}, function(choice)
        print('Changing model from ' .. gen.model .. ' to ' .. choice)
        gen.model = choice
      end)
    end, { desc = 'Show a selection of LLMs from Ollama server' })

    local smart_prompt = function(model, text)
      -- if `model` contains the word qwen in any part of the text
      -- prepend `text` with `/no_think`
      if model:match("^qwen3") then
        return '/no_think ' .. text
      end
      return text
    end

    require('gen').prompts['Write_Test_Code'] = {
      prompt = smart_prompt(require 'gen'.model,
        "As a seasoned programmer with over 20 years of commercial experience, your task is to write the Unit Test for this $filetype code. You must first write the code, then give a short explaination of your choices. Always use the best practices for $filetype. It is good to be concise: \n```$filetype\n$text\n```"),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }
    require('gen').prompts['Explain_Code'] = {
      prompt = smart_prompt(require 'gen'.model,
        "As a seasoned programmer with over 20 years of commercial experience, your task is to clearly explain the following $filetype code. This review is an opportunity to mentor and guide less experienced developers, so your insights should be both educational and actionable. It is good however to be concise: \n```$filetype\n$text\n```"),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }
    require('gen').prompts['Review_Code'] = {
      prompt = smart_prompt(require 'gen'.model,
        "As a seasoned programmer with over 20 years of commercial experience, your task is to perform a comprehensive code review on the provided $filetype code. Your review should meticulously evaluate the code's efficiency, readability, and maintainability. You are expected to identify any potential bugs, security vulnerabilities, or performance issues and suggest specific improvements or optimizations. Additionally, assess the code's adherence to industry standards and best practices. Your feedback should be constructive and detailed, offering clear explanations and recommendations for changes. Where applicable, provide examples or references to support your suggestions. Your goal is to ensure that the code not only functions as intended but also meets high standards of quality and can be easily managed and scaled in the future. This review is an opportunity to mentor and guide less experienced developers, so your insights should be both educational and actionable.: \n```$filetype\n$text\n```"),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }
    require('gen').prompts['Docstring'] = {
      prompt = smart_prompt(require 'gen'.model,
      "You are an experienced $filetype developer. Read the following code and provide a quick and correct documentation following the style of $filetype code. Output ONLY the docstring: \n```$filetype\n$text\n```"),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }
    require('gen').prompts['Fix_Code'] = {
      prompt = smart_prompt(require 'gen'.model,
      "You are an experienced $filetype developer. Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```"),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }
    require('gen').prompts['Generate_Code'] = {
      prompt = smart_prompt(require 'gen'.model,
      "You are an experienced $filetype developer. Write the $filetype code given the following information. The code must be easy to understand, handle all errors and edge cases, use libraries only IF necessary. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```"),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }

    require('gen').prompts['Review_Changes'] = {
      prompt = function()
        local diff = vim.fn.system('git diff --cached')
        return "As a seasoned programmer with over 20 years of commercial experience, your task is to perform a comprehensive code review on the provided $filetype code. Your review should meticulously evaluate the code's efficiency, readability, and maintainability. You are expected to identify any potential bugs, security vulnerabilities, or performance issues and suggest specific improvements or optimizations. Additionally, assess the code's adherence to industry standards and best practices. Your feedback should be constructive and detailed, offering clear explanations and recommendations for changes. Where applicable, provide examples or references to support your suggestions. Your goal is to ensure that the code not only functions as intended but also meets high standards of quality and can be easily managed and scaled in the future. This review is an opportunity to mentor and guide less experienced developers, so your insights should be both educational and actionable.: \n```$filetype\n".. diff .. "\n```"
      end,
      replace = false,
      extract = "```$filetype\n(.-)```"

    }

    -- mapping
    vim.keymap.set({ "n", "v" }, "<leader>it", ":Gen Write_Test_Code<cr>", { desc = "Gen Write Test Code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ia", ":Gen Ask<cr>", { desc = "Gen Ask", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ic", ":Gen Chat<cr>", { desc = "Gen Chat", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>id", ":Gen Docstring<cr>", { desc = "Gen Docstring", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ie", ":Gen Explain_Code<cr>", { desc = "Gen Explain Code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ig", ":Gen Generate_Code<cr>", { desc = "Gen Generate code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ii", ":Gen Improve_Code<cr>", { desc = "Gen Improve code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ir", ":Gen Review_Code<cr>", { desc = "Gen Review Code", noremap = true, silent = true })
  end
}
