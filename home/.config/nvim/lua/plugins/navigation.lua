return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    init = function()
      -- Must happen before netrw loads
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" }
    },
    opts = {
      view = {
        width = 35,
        side = "left",
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            git = true,
          },
          glyphs = {
            git = {
              unstaged  = "●",
              staged    = "✓",
              unmerged  = "",
              renamed   = "➜",
              untracked = "+",
              deleted   = "-",
              ignored   = "◌",
            }
          }
        }
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          -- Only open if Neovim was started with a directory
          if vim.fn.isdirectory(data.file) == 1 then
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false, -- this one need to be load upfront
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },

      -- bigfile = { enabled = true },
      -- dashboard = { enabled = true },
      -- explorer = { enabled = true },
      -- indent = { enabled = true },
      -- quickfile = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
    keys = {
      { '<leader>f', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>s', function() Snacks.picker.grep() end, desc = 'Search Text' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    },
  }
}
