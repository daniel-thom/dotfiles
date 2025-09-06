-- GotoLine function - jump to file:line from clipboard
local function goto_line()
  local clipboard = vim.fn.getreg("*")

  -- python exceptions, including pytest AssertionError
  -- tests/test_file.py:10: AssertionError
  local filename, line = string.match(clipboard, "([%./%w_-]+):(%d+):")
  if filename ~= nil then
    local cmd = string.format("edit +%s %s", line, filename)
    vim.api.nvim_command(cmd)
    return
  end

  -- python traceback
  --   File "/full/path/file.py", line 869, in function_name
  filename, line = string.match(clipboard, 'File "([%./%w_-]+)", line (%d+)')
  if filename ~= nil then
    local cmd = string.format("edit +%s %s", line, filename)
    vim.api.nvim_command(cmd)
    return
  end

  -- ipython traceback
  -- File file/path/file.py:139, in function_call(*args, **kwargs)
  filename, line = string.match(clipboard, "File ([~%./%w_-]+):(%d+)")
  if filename ~= nil then
    local cmd = string.format("edit +%s %s", line, filename)
    vim.api.nvim_command(cmd)
    return
  end

  -- julia stacktrace
  -- @ PowerSimulations ~/path/parameters.jl:170
  filename, line = string.match(clipboard, "@ [~%./%w%s_-]+ ([~%./%w_-]+):(%d+)")
  if filename ~= nil then
    local cmd = string.format("edit +%s %s", line, filename)
    vim.api.nvim_command(cmd)
    return
  end

  -- julia stacktrace with inline function
  -- @ ~/repos/sienna/InfrastructureSystems.jl/test/test_system_data.jl:313 [inlined]
  filename, line = string.match(clipboard, "@ ([~%./%w_-]+):(%d+)")
  if filename ~= nil then
    local cmd = string.format("edit +%s %s", line, filename)
    vim.api.nvim_command(cmd)
    return
  end

  -- If no pattern matched, show a message
  vim.notify("No file:line pattern found in clipboard", vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>jl", goto_line, { desc = "Goto line from clipboard" })
return {}
