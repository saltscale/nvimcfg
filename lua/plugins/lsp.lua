-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  -- 1) lsp-zero core, manual mode:
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy   = true,
    -- config = false, -- disable auto-setup
    -- init   = function()
    --   -- we’ll wire up cmp & lspconfig ourselves
    --   vim.g.lsp_zero_extend_cmp       = 0
    --   vim.g.lsp_zero_extend_lspconfig = 0
    -- end,
  },

  -- 2) Autocompletion (nvim-cmp):
  {
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

  -- 3) LSP + Mason + clangd override:
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "lukas-reineke/lsp-format.nvim", config = true },
    },
    config       = function()
      local lsp_zero = require("lsp-zero")

      -- A) common on_attach: formatting + default keymaps
      lsp_zero.on_attach(function(client, bufnr)
        require("lsp-format").on_attach(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })


        -- vim.api.nvim_buf_set_keymap(0,
        --   "n",
        --   "ga",
        --   "<cmd>Lsp codeAction<CR>",
        --   opts
        -- )
        -- hover actions keymap
        -- vim.api.nvim_buf_set_keymap(0,
        --   "n",
        --   "<leader>k",
        --   "<cmd>Lsp hover actions<CR>",
        --   opts
        -- )
      end)

      -- B) enable the standard lsp-zero wiring
      lsp_zero.extend_lspconfig()

      -- C) helper to probe clang++ for libc++ include dirs
      local function get_clang_include_flags()
        local null            = vim.fn.has("win32") == 1 and "NUL" or "/dev/null"
        local cmd             = (
          "clang++ -std=c++20 -stdlib=libc++ -E -x c++ - -v"
          .. " < " .. null .. " 2>&1"
        )
        local lines           = vim.fn.systemlist(cmd)
        local flags, in_block = {}, false
        for _, ln in ipairs(lines) do
          if ln:match("#include <%.%.%.> search starts here") then
            in_block = true
          elseif ln:match("End of search list") then
            break
          elseif in_block then
            local p = vim.trim(ln)
            if #p > 0 then
              table.insert(flags, "-I" .. p)
            end
          end
        end
        -- ensure we pick up libc++ itself
        vim.list_extend(flags, { "-std=c++20", "-stdlib=libc++" })
        return flags
      end

      -- D) Mason + Mason-LSPConfig
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "rust_analyzer",
          "pyright",
          "jsonls",
          "lua_ls",
          "tailwindcss",
          "prismals",
          "asm_lsp",
        },
        handlers = {
          -- default handler for all other servers:
          lsp_zero.default_setup,
          -- special override for clangd:
          clangd = function()
            require("lspconfig").clangd.setup({
              cmd = { "clangd", "--background-index", "--clang-tidy" },
              init_options = {
                fallbackFlags = get_clang_include_flags(),
              },
            })
          end,
        },
      })
    end,

  },
}
