local json = require "markdown-preview.lib.json"

local PREVIEW_AUTOCMD = -1
local SERVER_PID = -1

local function setup(opts)
  local start_server = opts.start_server or true
  local server_info = opts.server_info or {
    bin = "markdown-preview-server",
    port = 8080,
    ws_port = 8081,
  }
  local ft = opts.ft or { "md" }
  local css = opts.css or "userstyle.css"

  local ft_patterns = {}

  for _, _ft in ipairs(ft) do
    table.insert(ft_patterns, string.format("*.%s", _ft))
  end

  vim.api.nvim_create_user_command("MdPreview", function()
    if start_server then
      print "Starting server..."
      SERVER_PID = vim.fn.jobstart({
        server_info.bin,
        "-p", server_info.port,
        "--websocket-port", server_info.ws_port,
        "--css", css,
      }, {
        on_exit = function(_, code, _)
          print("Server exited with code " .. code)
        end,
        on_stderr = function(_, data)
          print("Server error: " .. json.encode(data))
        end,
      })
      print("Server started with PID " .. SERVER_PID)
    end
    PREVIEW_AUTOCMD = vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
      callback = function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_lines = vim.api.nvim_buf_line_count(current_buf)

        local request_body = json.encode({
          text = table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, buf_lines, false), '\n')
        })

        vim.fn.jobstart(
          {
            "curl",
            "-X", "POST",
            "-s",
            "--json",
            request_body,
            "http://localhost:8080/document"
          })
      end,
      pattern = ft_patterns
    })
  end, {})
  vim.api.nvim_create_user_command("MdPreviewStop", function()
    vim.api.nvim_del_autocmd(PREVIEW_AUTOCMD)
    if start_server then
      vim.fn.jobstop(SERVER_PID)
    end
  end, {})
end

return {
  setup = setup
}
