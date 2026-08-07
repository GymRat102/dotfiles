return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "hcl",
        "terraform",
      },
      highlight = { enable = true },
    },
  },
}
