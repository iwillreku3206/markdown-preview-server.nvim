--- @return string
local function ping()
  return string.char(0x00) .. string.char(0x01) .. '\n'
end

--- @return string
local function pong()
  return string.char(0x00) .. string.char(0x02) .. '\n'
end

--- @param text string
--- @return string
local function replace_text(text)
  return string.char(0x01) .. string.char(0x00) .. string.gsub(text, "\n", "\\n") .. '\n'
end

--- @param text string
--- @return string
local function set_document_title(text)
  return string.char(0x01) .. string.char(0x01) .. string.gsub(text, "\n", "\\n") .. '\n'
end

--- @param text string
--- @return string
local function set_file_path(text)
  return string.char(0x01) .. string.char(0x02) .. string.gsub(text, "\n", "\\n") .. '\n'
end

--- @return string
local function close()
  return string.char(0xff) .. string.char(0xff) .. '\n'
end

return {
  ping = ping,
  pong = pong,
  replace_text = replace_text,
  set_document_title = set_document_title,
  set_file_path = set_file_path,
  close = close
}
