-- nvim v0.8.0
return {
  "windwp/nvim-ts-autotag",
  lazy = true,
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      -- Override individual filetype configs (these take priority)
      per_filetype = {
        ["html"] = {
          enable_close = false, -- Disable auto-close for HTML
        },
        ["jsx"] = {
          enable_close = true, -- Enable auto-close for JSX
          enable_rename = true, -- Enable auto-rename for JSX
        },
        ["js"] = {
          enable_close = true, -- Enable auto-close for JS
          enable_rename = true, -- Enable auto-rename for JS
        },
        ["ts"] = {
          enable_close = true, -- Enable auto-close for TypeScript
          enable_rename = true, -- Enable auto-rename for TypeScript
        },
        ["tsx"] = {
          enable_close = true, -- Enable auto-close for TSX
          enable_rename = true, -- Enable auto-rename for TSX
        },
      },
      -- Required fields for nvim-ts-autotag setup
      did_setup = function()
        -- Optional custom behavior after setup (can be left empty)
      end,
      setup = function()
        -- Optional setup function (can be left empty if no further setup is needed)
      end,
      get_opts = function()
        -- Return configuration options if needed
        return { opts = {} }
      end,
    })
  end,
}
