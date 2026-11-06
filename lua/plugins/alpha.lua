return {
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    dir = vim.fn.stdpath("config"),
    name = "ascii-meteor-startup",
    lazy = false,
    priority = 900,
    config = function()
      local meteor = require("ascii-meteor")

      vim.api.nvim_create_user_command("Meteors", function()
        meteor.start()
      end, { desc = "Open animated Meteorite Shower startup screen" })

      vim.keymap.set("n", "<leader>as", function()
        meteor.start()
      end, { desc = "Open ASCII startup screen" })

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only show on clean startup when no files or stdin were passed
          if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.bo.filetype == "" then
            vim.schedule(function()
              meteor.start()
            end)
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function(ev)
          local w = vim.api.nvim_get_current_win()
          if vim.bo[ev.buf].filetype ~= "alpha" and vim.wo[w].winhl:find("MeteorBg") then
            vim.wo[w].winhl = ""
            if vim.bo[ev.buf].buftype == "" then
              vim.wo[w].number = true
              vim.wo[w].relativenumber = true
              vim.wo[w].cursorline = true
              vim.wo[w].signcolumn = "yes"
              vim.wo[w].wrap = true
            end
          end
        end,
      })
    end,
  },
}
