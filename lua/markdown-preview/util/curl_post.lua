local json = require('markdown-preview.lib.json')

return function (uri, body)
  return vim.fn.jobstart({
    "curl",
    "-X", "POST",
    "-s",
    "--json",
    json.encode(body),
    uri
  })
end
