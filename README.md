# Markdown Preview Server

A Neovim plugin that provides a live preview of markdown files, using a [local server](https://github.com/iwillreku3206/markdown-preview-server) written in Rust.

## Installation

### Prerequisites

* [markdown-preview-server](https://github.com/iwillreku3206/markdown-preview-server)
* cURL

### Using [lazy.nvim](https://github.com/folke.lazy.nvim)

```lua
--- other plugins
{
  "iwillreku3206/markdown-preview.nvim",
  config = function()
    require("markdown-preview").setup{}
  end,
}
```

### Configuration

You may provide an optional configuration table to the setup function.

This is the default configuration:

```lua
{
  start_server = true, -- should the plugin automatically start the server when the command is run?
  server_info = {
    bin = 'markdown-preview-server', -- binary of the server
    port = 8080, -- port to run the server on
    ws_port = 8081 -- port to run the websocket server on
  },
  ft = { "md" } -- filename  extensions of files that the server should run on
  css = "userstyle.css" -- path to css file to use for the preview
}
```

## Usage
* `:MdPreview` - start sending data to the markdown preview server.
* `:MdPreviewStop` - stop sending data to the markdown preview server.

If `start_server` is set to true, `:MdPreview` will start the server process, and `:MdPreviewStop` will stop the server process.
