local json = require "markdown-preview.lib.json"

return function(uri, events)
  print "starting ws"
  return vim.fn.jobstart({
      "websocat",
      uri
    },
    {
      on_stdout = function(_, data, stream)
        local ok, msg = pcall(json.decode, data[1])
        if not ok then return end
        if msg.type == nil or msg.content == nil then return end
        if msg.type == "EditorId" then
          events.on_editor_id(msg)
        end
        if msg.type == "GotoPath" then
          vim.cmd("e " .. msg.content)
        end
      end,
    }
  )
end
