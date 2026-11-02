-- ========================================================================== --
--                          CORE OPTIONS & KEYMAPS                            --
-- ========================================================================== --

-- Leader keys (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ------------------------ UI & Appearance --------------------------------- --
vim.opt.termguicolors = true  -- Enable 24-bit RGB color in the TUI
vim.opt.signcolumn = "yes"    -- Always show sign column to prevent text shifting
vim.opt.number = true         -- Show absolute line number on current line
vim.opt.relativenumber = true -- Show relative line numbers for easy jumping
vim.opt.cursorline = true     -- Highlight current cursor line
vim.opt.linebreak = true      -- Wrap long lines cleanly at word boundaries
vim.opt.scrolloff = 10        -- Keep at least 10 lines visible above/below cursor

-- ------------------------ Indentation & Formatting ------------------------ --
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.tabstop = 2           -- Number of spaces a <Tab> counts for
vim.opt.softtabstop = 2       -- Number of spaces <Tab>/<BS> uses while editing
vim.opt.shiftwidth = 2        -- Number of spaces for each step of auto-indent
vim.opt.autoindent = true     -- Keep indentation from previous line
vim.opt.smartindent = true    -- Automatically indent inside {}, (), [] blocks

-- Disable automatic comment continuation (e.g. adding '*' on <Enter> inside /* ... */)
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable automatic comment leader insertion on new lines",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- ------------------------ Search & Substitution --------------------------- --
vim.opt.ignorecase = true     -- Case-insensitive searching by default
vim.opt.smartcase = true      -- Case-sensitive if search contains uppercase
vim.opt.inccommand = "split"  -- Live preview of :substitute changes in a split

-- ------------------------ Files, Clipboard & Splits ----------------------- --
vim.opt.swapfile = false          -- Disable swap files
vim.opt.undofile = true           -- Persistent undo history across sessions
vim.opt.clipboard = "unnamedplus" -- Sync yank/paste with system clipboard
vim.opt.splitright = true         -- Open vertical splits to the right
vim.opt.splitbelow = true         -- Open horizontal splits below

-- ------------------------ Editor Autocommands ----------------------------- --
-- Highlight text briefly when yanking (copying)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Briefly highlight yanked text",
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 150 })
  end,
})

-- Restore cursor to last known position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor position when opening a file",
  callback = function(ev)
    local exclude = { "gitcommit", "gitrebase", "neo-tree", "TelescopePrompt" }
    if vim.tbl_contains(exclude, vim.bo[ev.buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ------------------------ General Keymaps --------------------------------- --
-- Exit insert mode quickly with JJ
vim.keymap.set("i", "JJ", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlighting
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Stay in Visual mode when indenting left/right with < and >
vim.keymap.set("v", "<", "<gv", { desc = "Unindent selection and keep visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection and keep visual mode" })

-- Move selected lines up/down in Visual mode with K and J (auto-indents)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selected lines up" })

-- Navigate between split panes
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Move focus to upper split" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Move focus to lower split" })
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Move focus to left split" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Move focus to right split" })
