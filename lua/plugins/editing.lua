return {
  -- 1. Auto-close & expand (), [], {}, "", ''
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        map_cr = true, -- Press <Enter> inside {|} or (|) to expand & indent automatically
        map_bs = true, -- Backspace inside (|) deletes both brackets cleanly
        fast_wrap = {
          map = "<A-e>", -- In Insert mode, press Alt+e to quickly wrap the following expression in brackets
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          before_key = "h",
          after_key = "l",
          cursor_pos_before = true,
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          manual_position = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      })
    end,
  },

  -- 2. Single-line & Multi-line Comments (gcc, gbc, gc, gb)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        toggler = {
          line = "gcc",  -- Toggle single-line comment on current line
          block = "gbc", -- Toggle multi-line block comment (/* ... */) on current line
        },
        opleader = {
          line = "gc",   -- Operator / Visual mode: line comment (e.g. gcip or Visual gc)
          block = "gb",  -- Operator / Visual mode: multi-line block comment (e.g. gbip or Visual gb)
        },
        extra = {
          above = "gcO", -- Add comment on the line above and enter Insert mode
          below = "gco", -- Add comment on the line below and enter Insert mode
          eol = "gcA",   -- Add comment at the end of current line and enter Insert mode
        },
      })
    end,
  },

  -- 3. Add, change, or delete surrounding (), [], {}, "", '' around text
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- 4. Vertical indentation guide lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = false, -- Keep pure indentation guides without requiring Treesitter
        },
        exclude = {
          filetypes = {
            "alpha",
            "dashboard",
            "neo-tree",
            "oil",
            "lazy",
            "help",
            "man",
            "checkhealth",
            "TelescopePrompt",
            "TelescopeResults",
            "",
          },
          buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
          },
        },
      })
    end,
  },
}
