return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = {
          settings = {
            julia = {
              -- Reduce semantic token refresh rate
              semanticTokens = {
                enabled = false, -- Try disabling completely first
              },
              -- Reduce completion and hover frequency
              completionmode = "qualify",
              hover = {
                enable = false, -- Disable hover during scrolling
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Disable semantic tokens for Julia specifically
            client.server_capabilities.semanticTokensProvider = nil

            -- Reduce update frequency
            if client.name == "julials" then
              client.config.flags = client.config.flags or {}
              client.config.flags.debounce_text_changes = 500 -- Increase debounce
            end
          end,
        },
      },
    },
  },
}
