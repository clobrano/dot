local common_configuration = {
  name = "unknown",
  quit_map = "q",                   -- set keymap to close the response window
  retry_map = "<c-r>",              -- set keymap to re-send the current prompt
  accept_map = "<c-cr>",            -- set keymap to replace the previous selection with the last result
  display_mode = "split",           -- The display mode. Can be "float" or "split" or "horizontal-split".
  show_prompt = true,               -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
  show_model = true,                -- Displays which model you are using at the beginning of your chat session.
  no_auto_close = false,            -- Never closes the window automatically.
  file = false,                     -- Write the payload to a temporary file to keep the command short.
  hidden = false,                   -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
  result_filetype = "markdown",     -- Configure filetype of the result buffer
  debug = false                     -- Prints errors and the command which is run.
}

local gen_ai_servers = {
  {
    name = "Local LLM",
    model = "qwen3:latest",
    host = "192.168.1.247",
    port = "11434",
    command = function(options)
      local body = { model = options.model, stream = true }
      return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
    end,
  },
  {
    name = "OpenAI",
    model = "gpt-3.5",
    host = "api.openai.com",
    port = "443",
    command = function(options)
      local api_key = os.getenv("OPENAI_API_KEY")
      if not api_key then
        vim.notify("OPENAI_API_KEY environment variable not set!", vim.log.levels.ERROR)
        return ""         -- Return empty command to prevent execution
      end

      -- Construct the request body for OpenAI Chat Completions API
      local prompt_text = vim.fn.json_encode(options.prompt)
      local request_body = string.format([[
                {
                    "model": "%s",
                    "messages": [
                        { "role": "user", "content": %s }
                    ],
                    "temperature": %f,
                    "max_tokens": %d,
                    "stream": true
                }
            ]], options.model, prompt_text, options.temperature or 0.7, options.max_tokens or 2048)

      -- The full curl command for OpenAI
      return string.format([[
                curl --silent --no-buffer -X POST \
                "https://%s/v1/chat/completions" \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer %s" \
                -d '%s'
            ]],
        options.host, api_key, request_body)
    end,
  },
}

local current_server_index = 1
local function apply_server_configuration(options)
  local server = gen_ai_servers[current_server_index]
  if not server then
    vim.notify("Error: could not find server at index" .. current_server_index, vim.log.levels.ERROR)
    return
  end

  options.host = server.host
  options.port = server.port
  options.model = server.model

  if server.command then
    options.command = server.command
  end
  require('gen').setup(options)
  return server
end

local function toggle_ai_server(options)
  current_server_index = current_server_index % #gen_ai_servers + 1
  local server = apply_server_configuration(options)
  if server ~= nil then
    vim.notify("Gen switched to " .. server.name, vim.log.levels.INFO)
  end
end

return {
  -- Custom Parameters (with defaults)
  "David-Kunz/gen.nvim",

  config = function()
    apply_server_configuration(common_configuration)

    vim.api.nvim_create_user_command("GetLLMModel", function()
      return require('gen').model
    end, {})

    -- change server at runtime
    vim.api.nvim_create_user_command("GenToggleserver", function()
      toggle_ai_server(common_configuration)
    end, { desc = 'Toggle Gen.nvim AI Server' }
    )
    -- change model at runtime
    vim.api.nvim_create_user_command("GenChangeModel", function()
      local gen = require('gen')
      local cmd = "curl --silent http://" .. gen.host .. ":" .. gen.port .. "/api/tags | jq -r '.models[].name'"
      local result = vim.fn.systemlist(cmd)
      if #result == 0 then
        print("No LLMs found")
        return
      end
      vim.ui.select(result, { prompt = "Available LLMs (current selection: " .. gen.model .. "): " }, function(choice)
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
        return
            "As a seasoned programmer with over 20 years of commercial experience, your task is to perform a comprehensive code review on the provided $filetype code. Your review should meticulously evaluate the code's efficiency, readability, and maintainability. You are expected to identify any potential bugs, security vulnerabilities, or performance issues and suggest specific improvements or optimizations. Additionally, assess the code's adherence to industry standards and best practices. Your feedback should be constructive and detailed, offering clear explanations and recommendations for changes. Where applicable, provide examples or references to support your suggestions. Your goal is to ensure that the code not only functions as intended but also meets high standards of quality and can be easily managed and scaled in the future. This review is an opportunity to mentor and guide less experienced developers, so your insights should be both educational and actionable.: \n```$filetype\n" ..
            diff .. "\n```"
      end,
      replace = false,
      extract = "```$filetype\n(.-)```"

    }

    require('gen').prompts['Weekly_Review'] = {
      prompt = smart_prompt(require'gen'.model,
"This DOCUMENT contains a week of notes of the work I have done. There is one chapter for each day of the week, with bullet points for each task. Tasks are indented when they belong to a common context. \n" ..
"Example \n" ..
"* [[TwoNodeOCP]] \n" ..
"    * update PR123 according to feedback \n" ..
"The task 'update PR123 according to feedback' belong to the project TwoNoteOCP \n" ..
"I want from you to collect this work of a week under the following bullet points \n" ..
"* Progress (tasks completed during this week) \n" ..
"* Next (tasks planned for the next week. It might include tasks discussed in this week, but not completed, with an estimation of ETA) \n" ..
"* Blockers (unexpected situations that blocked the completion of tasks)" ..
"Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```"     ),
      replace = false,
      extract = "```$filetype\n(.-)```"
    }

    -- mapping
    vim.keymap.set({ "n", "v" }, "<leader>it", ":Gen Write_Test_Code<cr>",
      { desc = "Gen Write Test Code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ia", ":Gen Ask<cr>", { desc = "Gen Ask", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ic", ":Gen Chat<cr>", { desc = "Gen Chat", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>id", ":Gen Docstring<cr>",
      { desc = "Gen Docstring", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ie", ":Gen Explain_Code<cr>",
      { desc = "Gen Explain Code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ig", ":Gen Generate_Code<cr>",
      { desc = "Gen Generate code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ii", ":Gen Improve_Code<cr>",
      { desc = "Gen Improve code", noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>ir", ":Gen Review_Code<cr>",
      { desc = "Gen Review Code", noremap = true, silent = true })
  end
}
