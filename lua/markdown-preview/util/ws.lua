local json = require "markdown-preview.lib.json"

-- curl  \
--no-buffer \
--header "Connection: Upgrade" \
--header "Upgrade: websocket" \
--header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
--header "Sec-WebSocket-Version: 13" \
--     http://127.0.0.1:8081/editor

--local base64_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
--local function generate_ws_key()
--  local key = 0
--  for i = 1, 8 do
--    key = bit.lshift(key, 8)
--    key = bit.bor(key, math.random(0, 255))
--  end
--  local key_str = ""
--  print(key)
--  for i = 1, 11 do
--    local charn = bit.band(key, 0b00111111)
--    local char = base64_chars.sub(base64_chars, charn + 1, charn + 1)
--    key = bit.rshift(key, 6)
--    key_str = key_str .. char
--  end
--  return key_str
--end

return function(uri)
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
        if msg.type == "GotoPath" then
          print("opening " .. msg.content)
          vim.cmd("e " .. msg.content)
        end
      end,
    }
  )
end
