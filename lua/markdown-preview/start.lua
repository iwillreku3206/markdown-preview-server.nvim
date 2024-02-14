local Connection = require("markdown-preview.connection")

--- @class Connection
function Connection:connect()
  self.stdin = vim.loop.new_pipe()
  self.stdout = vim.loop.new_pipe()
  self.sterr = vim.loop.new_pipe()
  self.process = vim.loop.spawn(self.binary, {
    args = { "--stdio" },
    stdio = { self.stdin, self.stdout, self.stderr }
  }, vim.schedule_wrap(function(code, _)
    if code ~= 0 then
      print("Failed to start markdown-preview-server")
    end
  end))
end
