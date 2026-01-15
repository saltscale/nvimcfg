return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "rust",
      "typst",
      "c",
      "cpp",
      "matlab",
      "prisma",
    },
    auto_install = true,    -- automatically install missing parsers
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
}

