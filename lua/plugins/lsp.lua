-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config       = function()
      local lsp_zero = require("lsp-zero")
      -- bring in the essential cmp setup
      lsp_zero.extend_cmp()
      -- (optional) further `require("cmp").setup{ … }` here
    end,
  },
  config = function()
    local lsp = require("lsp-zero")
    local util = require("lspconfig.util")

    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "rust_analyzer",
        "basedpyright",
        "jsonls",
        "tinymist",
        "ts_ls",
        "tailwindcss",
        "lua_ls",
        "prismals",
        "clangd",
      },
      -- automatic_installation = true,
      -- automatic_enable = true,
      -- In v2.x, `handlers` / `setup_handlers` are removed
      -- mason-lspconfig will automatically enable installed servers via `vim.lsp.enable()`
    })



    lsp.on_attach(function(client, bufnr)
      require("lsp-format").on_attach(client, bufnr)
    end)

    lsp.setup()


    vim.lsp.config("clangd", {})

    local opts = { noremap = true, silent = true }
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, nil)
        end

        vim.api.nvim_buf_set_keymap(0, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)

        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if filetype ~= "rust" then
          vim.api.nvim_buf_set_keymap(0, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        end
      end,
    })
  end,
}
