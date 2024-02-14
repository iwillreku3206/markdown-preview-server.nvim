local uv = vim.loop

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
  if opts.open_browser then
    opts.browser = opts.browser or {}
    opts.browser.host = opts.browser.host or "127.0.0.1"
    opts.browser.port = opts.browser.port or 19780
  end
end

return {
  setup = setup
}
