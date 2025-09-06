return {
  { "tpope/vim-fugitive" },
  { "GutenYe/json5.vim" },
  { "lifepillar/vim-solarized8" },
  { "tomasiser/vim-code-dark" },
  { "ayu-theme/ayu-vim" },
  { "JuliaEditorSupport/julia-vim" },
  { "ggandor/leap", enabled = false },
  {
    "folke/flash.nvim",
    enabled = false,
    keys = {
      { "s", false },
    },
  },
  {
    "folke/snacks.nvim",
    -- @type snacks.Config
    opts = {
      terminal = {
        -- your terminal configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
      },
    },
  },
}
