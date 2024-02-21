local Connection = require("markdown-preview.connection")
local Frames = require("markdown-preview.send_frame")

local uv = vim.loop

--- @class Connection
--- @field connect function

--- @param self Connection
function Connection:connect()
  local stdin = uv.new_pipe()
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  if stdin == nil or stdout == nil or stderr == nil then
    error("Failed to create pipes")
  end

  self.stdin = stdin
  self.stdout = stdout
  self.stderr = stderr

  local args = { "--stdio" }

  if self.config ~= nil then
    table.insert(args, "--config")
    table.insert(args, self.config)
  end

  local process = uv.spawn(self.binary, {
    args = args,
    stdio = { self.stdin, self.stdout, self.stderr },
    detached = false
  }, vim.schedule_wrap(function(code, _)
    if code ~= 0 then
      error("markdown-preview-server exited with code " .. code)
    end
  end))

  if process == nil then
    error("Failed to start markdown-preview-server")
  end

  self.process = process

  stderr:read_start(function(e, d)
    print(d)
  end)

  self.terminate_autocmd = vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    desc = "markdown-preview-server termination",
    callback = function()
      local closed = false
      stdin:close(function()
        stdout:close(function()
          stderr:close(function()
            process:kill()
            closed = true
          end)
        end)
      end)
      while not closed do
        vim.wait(1)
      end
    end
  })

  self.file_change_autocmd = vim.api.nvim_create_autocmd(
    { "BufFilePost", "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI", "TextChangedP" },
    {
      pattern = self.ft,
      desc = "markdown-preview-server file change",
      callback = function()
        local current_buf = vim.api.nvim_get_current_buf()
        stdin:write(Frames.replace_text(table.concat(vim.api.nvim_buf_get_lines(current_buf, 0, -1, false), "\n")))
      end
    })

  self.path_change_autocmd = vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "BufFilePost", "BufNewFile" },
    {
      pattern = self.ft,
      desc = "markdown-preview-server path change",
      callback = function()
        stdin:write(Frames.set_file_path(vim.api.nvim_buf_get_name(0)))
      end
    })

  if process == nil then
    error("Failed to start markdown-preview-server")
  end
end
