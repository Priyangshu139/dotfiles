-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add `tsx` and `typescript` to the list of parsers to ensure they are installed
      vim.list_extend(opts.ensure_installed, {
        "tsx", -- TypeScript JSX
        "typescript", -- TypeScript
      })

      -- Enable Treesitter modules and configure keymaps for textobjects
      opts.config = {
        highlight = {
          enable = true, -- Enable Treesitter-based syntax highlighting
          additional_vim_regex_highlighting = false, -- Disable Vim regex highlighting
        },
        indent = {
          enable = true, -- Enable Treesitter-based indentation
        },
        incremental_selection = {
          enable = true, -- Enable incremental selection
          keymaps = {
            init_selection = "<CR>", -- Start selection with Enter
            node_incremental = "<Tab>", -- Expand selection with Tab
            node_decremental = "<S-Tab>", -- Shrink selection with Shift+Tab
            scope_incremental = "<C-space>", -- Expand to scope with Ctrl+Space
          },
        },
        textobjects = {
          select = {
            enable = true, -- Enable text object selection
            lookahead = true, -- Look ahead to improve selection
            keymaps = {
              ["af"] = "@function.outer", -- Select outer function (vaf)
              ["if"] = "@function.inner", -- Select inner function (vif)
              ["aa"] = "@parameter.outer", -- Select outer argument (vaa)
              ["ia"] = "@parameter.inner", -- Select inner argument (via)
            },
          },
          move = {
            enable = true, -- Enable movement to next/previous text objects
            set_jumps = true, -- Enable jump to the selected text object
            goto_next_start = {
              ["<leader>mf"] = "@function.outer", -- Jump to the next function start
              ["<leader>ma"] = "@parameter.outer", -- Jump to the next parameter start
            },
            goto_previous_start = {
              ["<leader>mF"] = "@function.outer", -- Jump to the previous function start
              ["<leader>mA"] = "@parameter.outer", -- Jump to the previous parameter start
            },
          },
          swap = {
            enable = true, -- Enable text object swapping
            swap_next = {
              ["<leader>sn"] = "@function.outer", -- Swap with the next function
              ["<leader>sa"] = "@parameter.outer", -- Swap with the next parameter
            },
            swap_previous = {
              ["<leader>sp"] = "@function.outer", -- Swap with the previous function
              ["<leader>sa"] = "@parameter.outer", -- Swap with the previous parameter
            },
          },
        },
      }
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
