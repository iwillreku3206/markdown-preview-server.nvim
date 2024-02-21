local Connection = require("markdown-preview.connection")
require("markdown-preview.start")

--- @class SetupOpts
--- @field binary string?
--- @field config string?
--- @field ft string[]?
--- @field open_browser boolean?
--- @field browser ViewerInfo?

--- @class ViewerInfo
--- @field binary string?
--- @field host string?
--- @field port number?

--- @param opts SetupOpts
local function setup(opts)
  opts.binary = opts.binary or "markdown-preview-server"
  opts.ft = opts.ft or { "markdown", "md" }
  local ft = {}

  for _, _ft in ipairs(opts.ft) do
    table.insert(ft, string.format("*.%s", _ft))
  end

  opts.ft = ft

  if opts.open_browser then
    opts.browser = opts.browser or {}
    opts.browser.host = opts.browser.host or "127.0.0.1"
    opts.browser.port = opts.browser.port or 19780
  end

  vim.api.nvim_create_user_command("MdPreview", function()
    CONN = Connection:new(opts)
    CONN:connect()
  end, {
    desc = "Start Markdown Preview Server"
  })
end

return {
  setup = setup
}
