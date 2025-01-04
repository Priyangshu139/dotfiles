return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Recommended, not strictly required
    "MunifTanjim/nui.nvim", -- Required for Neo-tree
    -- Uncomment the line below for optional image support in the preview window
    -- "3rd/image.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  config = function()
    -- Set diagnostic signs with icons (you can adjust as needed)
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    -- Set up Neo-tree
    require("neo-tree").setup({
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- Exclude specific types from replacing
      sort_case_insensitive = false,
      sort_function = nil, -- You can add a custom sort function here if needed

      -- Add filesystem options
      filesystem = {
        filtered_items = {
          hide_dotfiles = false, -- Show hidden files
          hide_gitignored = false, -- Hide files ignored by git
        },
        follow_current_file = true, -- Auto-focus on the current file
      },

      -- Default component configurations
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1, -- Extra padding on the left-hand side
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil, -- Auto-enable expanders if file nesting is enabled
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          provider = function(icon, node, state)
            if node.type == "file" or node.type == "terminal" then
              local success, web_devicons = pcall(require, "nvim-web-devicons")
              local name = node.type == "terminal" and "terminal" or node.name
              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = hl or icon.highlight
              end
            end
          end,
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
        file_size = {
          enabled = true,
          width = 12,
          required_width = 64,
        },
        type = {
          enabled = true,
          width = 10,
          required_width = 122,
        },
        last_modified = {
          enabled = true,
          width = 20,
          required_width = 88,
        },
        created = {
          enabled = true,
          width = 20,
          required_width = 110,
        },
        symlink_target = {
          enabled = false,
        },
      },

      -- Window settings for floating mode
      window = {
        position = "float", -- Open in floating window
        popup = {
          size = { height = "80%", width = "50%" }, -- Adjust floating window size
          position = "50%", -- Center the floating window
          border = "rounded", -- Border style (rounded, single, double, etc.)
        },
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = { "toggle_node", nowait = false },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["l"] = "focus_preview",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["a"] = { "add", config = { show_path = "none" } },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["i"] = "show_file_details",
        },
      },
    })

    -- Optional: Map Neo-tree to a keybinding (e.g., <leader>e to reveal Neo-tree)
    vim.keymap.set("n", "<leader>e", ":Neotree toggle position=float<CR>", { noremap = true, silent = true })
  end,
}
