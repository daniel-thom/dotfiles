return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = {
          -- Bypass mason-lspconfig's `julia-lsp` integration: under nvim 0.12 its
          -- `before_init` hook fires after the process is spawned, so the required
          -- env-path argument never reaches the command line and `julia-lsp` exits 1.
          -- Use the standard nvim-lspconfig bootstrap instead, which auto-detects the
          -- project and loads LanguageServer/SymbolServer/StaticLint from the dedicated
          -- ~/.julia/environments/nvim-lspconfig environment.
          cmd = {
            "julia",
            "--startup-file=no",
            "--history-file=no",
            "-e",
            [[
              ls_install_path = joinpath(
                  get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
                  "environments", "nvim-lspconfig"
              )
              pushfirst!(LOAD_PATH, ls_install_path)
              using LanguageServer, SymbolServer, StaticLint
              popfirst!(LOAD_PATH)
              depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
              project_path = let
                  dirname(something(
                      Base.load_path_expand((
                          p = get(ENV, "JULIA_PROJECT", nothing);
                          p === nothing ? nothing : isempty(p) ? nothing : p
                      )),
                      Base.current_project(),
                      get(Base.load_path(), 1, nothing),
                      Base.load_path_expand("@v#.#"),
                  ))
              end
              @info "Running language server" VERSION pwd() project_path depot_path
              server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
              server.runlinter = true
              run(server)
            ]],
          },
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
      setup = {
        -- Take full ownership of julials so LazyVim adds it to mason-lspconfig's
        -- exclude list. Otherwise mason-lspconfig auto-enables julials *after*
        -- LazyVim and clobbers our `cmd` above with its broken `julia-lsp` command.
        -- Returning true tells LazyVim to skip its default setup for this server.
        julials = function(_, sopts)
          vim.lsp.config("julials", sopts)
          vim.lsp.enable("julials")
          return true
        end,
      },
    },
  },
}
