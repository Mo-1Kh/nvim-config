local function find_files_command()
  local fd_bin = vim.fn.executable("fd") == 1 and "fd"
    or (vim.fn.executable("fdfind") == 1 and "fdfind" or nil)

  if fd_bin then
    return {
      fd_bin,
      "--type",
      "f",
      "--color",
      "never",
      "--strip-cwd-prefix",
      "--exclude",
      ".git",
      "--exclude",
      ".pixi",
    }
  elseif vim.fn.executable("rg") == 1 then
    return {
      "rg",
      "--files",
      "--color",
      "never",
      "--glob",
      "!.git/",
      "--glob",
      "!.pixi/",
    }
  end

  return {
    "find",
    ".",
    "(",
    "-name",
    ".git",
    "-o",
    "-name",
    ".pixi",
    ")",
    "-prune",
    "-o",
    "-type",
    "f",
    "-print",
  }
end

return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!.git/",
            "--glob",
            "!.pixi/",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = find_files_command,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (Telescope)" })
      vim.keymap.set("n", "<leader>fa", function()
        builtin.find_files({
          prompt_title = "Find All Files (incl. ignored)",
          no_ignore = true,
          no_ignore_parent = true,
        })
      end, { desc = "Find all files including ignored (Telescope)" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep across project (Telescope)" })
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files (Telescope)" })

      local fzf_ok, fzf_err = pcall(telescope.load_extension, "fzf")
      if not fzf_ok then
        vim.notify("Telescope fzf-native failed to load: " .. tostring(fzf_err), vim.log.levels.WARN)
      end
      telescope.load_extension("ui-select")
    end,
  },
}
