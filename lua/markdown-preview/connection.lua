--- @class Connection
--- @field binary string
--- @field config string
--- @field ft string[]
--- @field open_browser boolean
--- @field browser ViewerInfo?
--- @field file_change_autocmd number?
--- @field path_change_autocmd number?
--- @field terminate_autocmd number?
--- @field process uv_process_t?
--- @field stdin uv_pipe_t?
--- @field stdout uv_pipe_t?
--- @field stderr uv_pipe_t?
local Connection = {
  --- @type string
  binary = "markdown-preview-server",
  --- @type string
  config = nil,
  --- @type string[]
  ft = { "markdown", "md" },
  --- @type boolean
  open_browser = false,
  --- @type ViewerInfo?
  browser = nil,

  --state (do not initialize - this is private)
  --- @type number
  file_change_autocmd = nil,
  --- @type number
  path_change_autocmd = nil,
  --- @type number
  terminate_autocmd = nil,
  --- @type uv_process_t
  process = nil,
  --- @type uv_pipe_t
  stdin = nil,
  --- @type uv_pipe_t
  stdout = nil,
  --- @type uv_pipe_t
  stderr = nil,
}

--- @param opts SetupOpts
---@return Connection
function Connection:new(opts)
  --- @type Connection
  local conn = {
    binary = opts.binary or self.binary,
    config = opts.config or self.config,
    ft = opts.ft or self.ft,
    open_browser = opts.open_browser or self.open_browser,
    browser = opts.browser or self.browser
  }
  setmetatable(conn, self)
  self.__index = self
  return conn
end

return Connection
