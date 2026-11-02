-- ========================================================================== --
--                    NEOVIM KEYBINDS & MOTIONS MANUAL                        --
-- ========================================================================== --

local M = {}

local ns = vim.api.nvim_create_namespace("nvim_manual_popup")

local function setup_highlights()
  local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    return (ok and hl) or {}
  end

  local normal = get_hl("Normal")
  local comment = get_hl("Comment")
  local special = get_hl("Special")
  local func = get_hl("Function")
  local kw = get_hl("Statement")
  local typ = get_hl("Type")
  local const = get_hl("Constant")
  local diag_info = get_hl("DiagnosticInfo")

  local bg = normal.bg or 0x1d2021
  local fg = normal.fg or 0xebdbb2

  vim.api.nvim_set_hl(0, "ManualNormal", { bg = bg, fg = fg })
  vim.api.nvim_set_hl(0, "ManualBorder", { bg = bg, fg = special.fg or 0xfe8019, bold = true })
  vim.api.nvim_set_hl(0, "ManualTitle", { bg = bg, fg = typ.fg or 0xfabd2f, bold = true })
  vim.api.nvim_set_hl(0, "ManualSubtitle", { bg = bg, fg = diag_info.fg or 0x83a598, italic = true })
  vim.api.nvim_set_hl(0, "ManualSection", { bg = bg, fg = kw.fg or 0xfb4934, bold = true })
  vim.api.nvim_set_hl(0, "ManualKey", { bg = bg, fg = func.fg or 0xb8bb26, bold = true })
  vim.api.nvim_set_hl(0, "ManualDesc", { bg = bg, fg = fg })
  vim.api.nvim_set_hl(0, "ManualNote", { bg = bg, fg = const.fg or 0xd3869b, italic = true })
  vim.api.nvim_set_hl(0, "ManualMuted", { bg = bg, fg = comment.fg or 0x928374 })
  vim.api.nvim_set_hl(0, "ManualNumber", { bg = bg, fg = special.fg or 0xfe8019, bold = true })
  vim.api.nvim_set_hl(0, "ManualFooter", { bg = bg, fg = comment.fg or 0x928374, italic = true })
end

-- ========================================================================== --
--                             MANUAL PAGES DATA                              --
-- ========================================================================== --

M.pages = {
  {
    id = "motions",
    icon = "󰌌 ",
    title = "Vim Motions & Editing",
    summary = "Navigation, word jumps, operators, text objects, visual mode & macros",
    sections = {
      {
        heading = "Basic & Line Navigation",
        items = {
          { key = "h / j / k / l", desc = "Move cursor left / down / up / right (prefix with count, e.g. 10j)" },
          { key = "w / b / e", desc = "Jump forward to start of word / backward to start / to end of word" },
          { key = "W / B / E", desc = "Jump by whitespace-delimited WORD (ignores punctuation)" },
          { key = "0 / ^ / $", desc = "Jump to column 0 / first non-blank character / end of line" },
          { key = "f{c} / t{c}", desc = "Jump ON / RIGHT BEFORE character {c} on current line (; / , to repeat)" },
          { key = "F{c} / T{c}", desc = "Jump backward ON / RIGHT AFTER character {c} on current line" },
          { key = "%", desc = "Jump between matching brackets (), {}, []" },
        },
      },
      {
        heading = "File & Screen Navigation",
        items = {
          { key = "gg / G", desc = "Jump to first line / last line of file (or {N}G to jump to line N)" },
          { key = "{ / }", desc = "Jump backward / forward by paragraph or empty-line block" },
          { key = "<C-u> / <C-d>", desc = "Scroll half-page up / down" },
          { key = "<C-b> / <C-f>", desc = "Scroll full-page up / down" },
          { key = "zz / zt / zb", desc = "Center current line on screen / move to top / move to bottom" },
          { key = "H / M / L", desc = "Move cursor to High (top) / Middle / Low (bottom) of visible screen" },
          { key = "<C-o> / <C-i>", desc = "Jump backward / forward in the jump history list" },
        },
      },
      {
        heading = "Operators (Combine with Motions or Text Objects)",
        items = {
          { key = "d{motion}", desc = "Delete motion (e.g. dw delete word, d$ delete to end, dd delete line)" },
          { key = "c{motion}", desc = "Change motion: delete and enter Insert mode (e.g. cw, c$, cc)" },
          { key = "y{motion}", desc = "Yank (copy) motion (e.g. yw copy word, yy copy line, y$ to end)" },
          { key = ">{motion} / <{motion}", desc = "Indent / unindent motion (>> / << for current line)" },
          { key = "={motion}", desc = "Auto-indent motion (== for current line, gg=G for whole file)" },
          { key = "~ / g~{motion}", desc = "Toggle uppercase/lowercase of character or motion (gu lower, gU upper)" },
          { key = "u / <C-r>", desc = "Undo last change / Redo undone change" },
          { key = ".", desc = "Repeat the last editing command" },
        },
      },
      {
        heading = "Text Objects (Use after d, c, y, or v — e.g. ciw, da\", yi()",
        items = {
          { key = "iw / aw", desc = "Inner word (just the word) / A word (includes surrounding space)" },
          { key = "i\" / a\"", desc = "Inside double quotes / Around double quotes (includes the quotes)" },
          { key = "i' / a' / i` / a`", desc = "Inside or around single quotes / backticks" },
          { key = "i( / a(  or  ib / ab", desc = "Inside or around parentheses ( ... )" },
          { key = "i{ / a{  or  iB / aB", desc = "Inside or around curly braces { ... }" },
          { key = "i[ / a[", desc = "Inside or around square brackets [ ... ]" },
          { key = "it / at", desc = "Inside or around HTML/XML tag <tag>...</tag>" },
          { key = "ip / ap", desc = "Inside or around paragraph" },
        },
      },
      {
        heading = "Entering Insert Mode & Fast Edits",
        items = {
          { key = "i / a", desc = "Insert before cursor / Append after cursor" },
          { key = "I / A", desc = "Insert at first non-blank char of line / Append at end of line" },
          { key = "o / O", desc = "Open new line below / above and enter Insert mode" },
          { key = "JJ  or  <Esc>", desc = "Exit Insert mode back to Normal mode" },
          { key = "x / X", desc = "Delete character under cursor / before cursor" },
          { key = "r{c} / R", desc = "Replace single character with {c} / Enter continuous Replace mode" },
          { key = "s / S", desc = "Delete char and insert / Delete entire line and insert" },
          { key = "D / C", desc = "Delete to end of line (d$) / Change to end of line (c$)" },
          { key = "p / P", desc = "Paste after cursor (or below line) / Paste before cursor (or above line)" },
          { key = "J", desc = "Join line below onto the end of current line" },
        },
      },
      {
        heading = "Visual Mode, Search, Marks & Macros",
        items = {
          { key = "v / V / <C-v>", desc = "Character visual / Linewise visual / Block (column) visual mode" },
          { key = "gv / o", desc = "Reselect last visual selection / Swap cursor to other end of selection" },
          { key = "/{pattern} / ?{pattern}", desc = "Search forward / backward (n next match, N previous match)" },
          { key = "* / #", desc = "Search forward / backward for exact word under cursor" },
          { key = ":%s/old/new/gc", desc = "Replace 'old' with 'new' across entire file with confirmation" },
          { key = "m{a-z} / '{a-z}", desc = "Set mark {a-z} at cursor / Jump to mark {a-z} (M{A-Z} for global marks)" },
          { key = "q{a-z} ... q", desc = "Record macro into register {a-z}, press q to stop recording" },
          { key = "@{a-z} / @@", desc = "Replay macro {a-z} / Repeat last replayed macro (e.g. 10@a)" },
          { key = "\"+y / \"+p", desc = "Yank to / paste from system clipboard" },
        },
      },
    },
  },

  {
    id = "editing",
    icon = "󰅪 ",
    title = "Brackets, Autopairs & Comments",
    summary = "Auto-closing (), [], {}, surrounding text & single/multi-line comments",
    sections = {
      {
        heading = "Auto-Pairs — Creating (), [], {}, \"\", '' (nvim-autopairs)",
        items = {
          { key = "(  [  {  \"  '", desc = "In Insert mode: automatically inserts matching closing bracket/quote" },
          { key = "<CR>  inside {|}", desc = "In Insert mode: expands {|} into a multi-line indented block" },
          { key = "<BS>  inside (|)", desc = "In Insert mode: deletes both the opening and closing bracket together" },
          { key = ")  ]  }  \"  '", desc = "In Insert mode: skips over existing closing bracket instead of duplicating" },
          { key = "<A-e>  (Alt + e)", desc = "In Insert mode: Fast-Wrap — press a letter to wrap following text in brackets" },
        },
      },
      {
        heading = "Single-Line & Multi-Line Comments (Comment.nvim)",
        items = {
          { key = "gcc", desc = "Toggle single-line comment (//, #, --) on current line" },
          { key = "gbc", desc = "Toggle multi-line block comment (/* ... */, --[[ ... ]]) on current line" },
          { key = "gc  (Visual mode)", desc = "Select lines with v/V, then press gc to toggle line comments" },
          { key = "gb  (Visual mode)", desc = "Select lines with v/V, then press gb to wrap in a multi-line block comment" },
          { key = "gc{motion}", desc = "Line-comment any motion (e.g. gcip comment paragraph, gc4j comment 4 lines)" },
          { key = "gb{motion}", desc = "Block-comment any motion (e.g. gbip multi-line comment whole paragraph)" },
          { key = "gco / gcO / gcA", desc = "Insert comment on line below (gco), line above (gcO), or end of line (gcA)" },
        },
      },
      {
        heading = "Surround — Wrap, Change, or Delete Existing Brackets (nvim-surround)",
        items = {
          { key = "S{char}  (Visual)", desc = "Select text with v, then press S) or S} or S] or S\" to wrap selection" },
          { key = "ysiw) / ysiw}", desc = "Wrap current word in (word) or {word} (use ( or { for spaces inside)" },
          { key = "yss) / yss}", desc = "Wrap the entire current line in (...) or {...}" },
          { key = "cs({  or  cs\"'", desc = "Change surrounding (text) to {text}, or \"text\" to 'text'" },
          { key = "ds( / ds{ / ds\"", desc = "Delete surrounding (), {}, [], or \"\" and leave inner text untouched" },
        },
      },
    },
  },

  {
    id = "core",
    icon = " ",
    title = "Core Config & Window Splits",
    summary = "Custom general keymaps, search clearing, split creation & navigation",
    sections = {
      {
        heading = "General Editor Keymaps (lua/vim-options.lua)",
        items = {
          { key = "<Space>", desc = "Leader key (<leader>)" },
          { key = "JJ", desc = "Exit Insert mode quickly (mapped to <Esc>)" },
          { key = "<Space>h", desc = "Clear active search highlighting (:nohlsearch)" },
          { key = "<Space>m", desc = "Open this Keybinds & Motions Manual picker (:Manual)" },
          { key = "<Space>as", desc = "Open animated ASCII Startup Screen" },
        },
      },
      {
        heading = "Split Window Management (lua/plugins/bufferLine.lua)",
        items = {
          { key = "<Space>sv", desc = "Split current window vertically (:vsplit)" },
          { key = "<Space>sh", desc = "Split current window horizontally (:split)" },
          { key = "<Space>se", desc = "Make all split windows equal width & height (<C-w>=)" },
          { key = "<Space>sx", desc = "Close current split window (:close)" },
        },
      },
      {
        heading = "Split Window Navigation (lua/vim-options.lua)",
        items = {
          { key = "<C-h>", desc = "Move focus to the left split pane" },
          { key = "<C-j>", desc = "Move focus to the lower split pane" },
          { key = "<C-k>", desc = "Move focus to the upper split pane" },
          { key = "<C-l>", desc = "Move focus to the right split pane" },
          { key = "<C-w>r / <C-w>x", desc = "Rotate split windows / Exchange current split with next" },
          { key = "<C-w>| / <C-w>_", desc = "Maximize current split width / height (<Space>se to restore)" },
        },
      },
    },
  },

  {
    id = "bufferline",
    icon = "󰓩 ",
    title = "Bufferline (Tabs & Buffers)",
    summary = "Switching tabs, jumping by number, reordering, pinning & closing buffers",
    sections = {
      {
        heading = "Switching & Jumping Between Tabs",
        items = {
          { key = "<S-l>  (Shift + l)", desc = "Cycle to next buffer tab (automatically focuses editor if in Neo-tree)" },
          { key = "<S-h>  (Shift + h)", desc = "Cycle to previous buffer tab" },
          { key = "<Space>1 .. <Space>9", desc = "Jump directly to buffer tab 1 through 9 by ordinal number" },
          { key = "<Space>bp", desc = "Interactive buffer picker — type the highlighted letter on any tab" },
        },
      },
      {
        heading = "Reordering & Pinning Tabs",
        items = {
          { key = "<A-l>  (Alt + l)", desc = "Move current buffer tab to the right" },
          { key = "<A-h>  (Alt + h)", desc = "Move current buffer tab to the left" },
          { key = "<Space>P", desc = "Pin / Unpin current buffer tab on the left of the tab bar" },
        },
      },
      {
        heading = "Closing Buffers (Tabs)",
        items = {
          { key = "<Space>x", desc = "Close current buffer cleanly (preserves window layout & removes tab)" },
          { key = "<Space>bc", desc = "Interactive close — pick which tab to close by typing its letter" },
          { key = "<Space>bo", desc = "Close all other unpinned buffer tabs except current" },
          { key = "<Space>bl", desc = "Close all buffer tabs to the left of current tab" },
          { key = "<Space>br", desc = "Close all buffer tabs to the right of current tab" },
        },
      },
    },
  },

  {
    id = "explorers",
    icon = "󰙅 ",
    title = "File Explorers (Neo-tree & Oil)",
    summary = "Sidebar file tree, floating git/buffer trees & Oil buffer-style directory editing",
    sections = {
      {
        heading = "Neo-tree Global Keybinds (lua/plugins/neo-tree.lua)",
        items = {
          { key = "<C-n>", desc = "Toggle Neo-tree file explorer sidebar on the left" },
          { key = "<Space>bf", desc = "Open open-buffers list in a floating Neo-tree window" },
          { key = "<Space>gf", desc = "Open Git status tree in a floating Neo-tree window" },
        },
      },
      {
        heading = "Inside Neo-tree Window Keybinds",
        items = {
          { key = "<CR>  or  l", desc = "Open file in editor or expand/collapse folder" },
          { key = "<BS>  or  h", desc = "Navigate up to parent directory / close folder node" },
          { key = "s / S", desc = "Open selected file in a vertical split (s) / horizontal split (S)" },
          { key = "P", desc = "Toggle live preview floating window for highlighted file" },
          { key = "a / A", desc = "Add a new file or folder (end name with / for folder, or press A)" },
          { key = "d", desc = "Delete selected file or directory (with confirmation)" },
          { key = "r / b", desc = "Rename file/directory (r) / Rename basename only without extension (b)" },
          { key = "y / x / p", desc = "Copy file to clipboard (y) / Cut to clipboard (x) / Paste (p)" },
          { key = "c / m", desc = "Copy file to path (c) / Move file to path (m)" },
          { key = "H / .", desc = "Toggle hidden dotfiles / Set root directory to current node" },
          { key = "R / ?", desc = "Refresh file tree (R) / Show full Neo-tree keymap help popup (?)" },
        },
      },
      {
        heading = "Oil.nvim Directory Editor (lua/plugins/oil.lua)",
        items = {
          { key = "-", desc = "Toggle Oil floating window for current file's parent directory" },
          { key = "<CR>", desc = "Open file or enter directory under cursor" },
          { key = "-  (inside Oil)", desc = "Go up to parent directory" },
          { key = "g.", desc = "Toggle showing hidden files in Oil" },
          { key = "<C-p>", desc = "Open preview of entry under cursor" },
          { key = "<C-v> / <C-s>", desc = "Open entry under cursor in vertical / horizontal split" },
          { key = ":w", desc = "Save buffer edits to create, rename, or delete files on disk!" },
          { key = "g?", desc = "Show all Oil buffer keybindings" },
        },
      },
    },
  },

  {
    id = "telescope",
    icon = "󰈞 ",
    title = "Telescope (Fuzzy Finder)",
    summary = "Find files, live project grep, recent files & prompt actions",
    sections = {
      {
        heading = "Global Telescope Pickers (lua/plugins/telescope.lua)",
        items = {
          { key = "<Space>ff", desc = "Find files across current working directory" },
          { key = "<Space>fg", desc = "Live grep text/regex across the entire project" },
          { key = "<Space><Space>", desc = "Browse and open recently edited files (oldfiles)" },
        },
      },
      {
        heading = "Inside Telescope Popup Window",
        items = {
          { key = "<Down> / <Up>", desc = "Move selection down / up (also <C-n> / <C-p>)" },
          { key = "<CR>", desc = "Open selected file in current window" },
          { key = "<C-v>", desc = "Open selected file in a vertical split" },
          { key = "<C-x>", desc = "Open selected file in a horizontal split" },
          { key = "<C-t>", desc = "Open selected file in a new tabpage" },
          { key = "<C-u> / <C-d>", desc = "Scroll preview pane up / down" },
          { key = "<Tab> / <S-Tab>", desc = "Toggle multi-selection on current item and move cursor" },
          { key = "<C-q>", desc = "Send all items (or multi-selected items) to Quickfix list" },
          { key = "<Esc> / <C-c>", desc = "Close Telescope popup" },
        },
      },
    },
  },

  {
    id = "git",
    icon = "󰊢 ",
    title = "Git (Gitsigns, Diffview & Fugitive)",
    summary = "Hunk navigation, staging/resetting, inline blame, side-by-side diffs & commit history",
    sections = {
      {
        heading = "Gitsigns — Hunk Navigation & Preview (lua/plugins/gitsigns.lua)",
        items = {
          { key = "]h", desc = "Jump to next Git hunk in current buffer" },
          { key = "[h", desc = "Jump to previous Git hunk in current buffer" },
          { key = "<Space>gp", desc = "Preview current Git hunk in a floating popup" },
          { key = "<Space>gi", desc = "Preview deleted/changed hunk lines inline in buffer" },
        },
      },
      {
        heading = "Gitsigns — Staging, Resetting & Blame",
        items = {
          { key = "<Space>gs", desc = "Stage current hunk (in Visual mode: stage only selected lines)" },
          { key = "<Space>gr", desc = "Reset/discard current hunk (in Visual mode: reset selected lines)" },
          { key = "<Space>gu", desc = "Undo last stage hunk operation" },
          { key = "<Space>gS", desc = "Stage the entire current buffer" },
          { key = "<Space>gR", desc = "Reset/discard all changes in current buffer" },
          { key = "<Space>gt", desc = "Toggle inline end-of-line Git blame for current line" },
          { key = "<Space>gb", desc = "Show full Git commit blame message popup for current line" },
          { key = "<Space>gd", desc = "Open Git diff split for current file" },
        },
      },
      {
        heading = "Diffview & Vim-Fugitive",
        items = {
          { key = "<Space>gv", desc = "Toggle Diffview (review all modified/conflicted files across repo)" },
          { key = "<Space>gh", desc = "Open Git commit history for the current file (%)" },
          { key = "<Space>gH", desc = "Open Git commit history for the entire repository" },
          { key = "<Space>gx  or  q", desc = "Close Diffview (q works inside Diffview panels)" },
          { key = "s  (in Diffview)", desc = "Stage / unstage file in Diffview file panel" },
          { key = "<Space>gg  or  :Git", desc = "Open interactive Fugitive Git status window (s stage, cc commit)" },
        },
      },
    },
  },

  {
    id = "startup",
    icon = "☄️ ",
    title = "Startup Screen & Commands",
    summary = "Animated dashboard shortcuts, scene switching & custom commands",
    sections = {
      {
        heading = "Startup Dashboard Shortcuts (lua/ascii-sharks.lua)",
        items = {
          { key = "f", desc = "Find Files (Telescope)" },
          { key = "g", desc = "Live Grep across project (Telescope)" },
          { key = "r", desc = "Recent Files (Telescope)" },
          { key = "e", desc = "Create a New File (:enew)" },
          { key = "m", desc = "Open this Keybinds & Motions Manual" },
          { key = "a", desc = "Switch background animation (Meteorite Shower -> Dragon -> Sharks)" },
          { key = "l", desc = "Open Lazy.nvim plugin manager" },
          { key = "q", desc = "Quit Neovim (:qa)" },
        },
      },
      {
        heading = "Custom User Commands & Triggers",
        items = {
          { key = "<Space>m  or  :Manual", desc = "Open the Manual category picker (or :Manual <topic>)" },
          { key = "<Space>as", desc = "Launch the animated ASCII startup screen at any time" },
          { key = ":Meteors", desc = "Launch Startup Screen in Meteorite Shower mode" },
          { key = ":Dragon", desc = "Launch Startup Screen in Dragon & Embers mode" },
          { key = ":Sharks", desc = "Launch Startup Screen in Sharks & Ocean mode" },
        },
      },
    },
  },
}

-- ========================================================================== --
--                        FLOATING WINDOW MANAGEMENT                          --
-- ========================================================================== --

local state = {
  win = nil,
  buf = nil,
  mode = nil, -- "picker" or "page"
  page_idx = 1,
}

local function close_active()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end
  state.win = nil
  state.buf = nil
  state.mode = nil
end

local function create_float(width, height, title, footer)
  close_active()
  setup_highlights()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false

  local ui = vim.api.nvim_list_uis()[1]
  local cols = ui and ui.width or vim.o.columns
  local rows = ui and ui.height or vim.o.lines

  local w = math.min(width, math.max(40, cols - 4))
  local h = math.min(height, math.max(12, rows - 4))
  local row = math.max(0, math.floor((rows - h) / 2) - 1)
  local col = math.max(0, math.floor((cols - w) / 2))

  local win_opts = {
    relative = "editor",
    width = w,
    height = h,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = { { " " .. title .. " ", "ManualTitle" } },
    title_pos = "center",
  }

  if footer and vim.fn.has("nvim-0.10") == 1 then
    win_opts.footer = { { " " .. footer .. " ", "ManualFooter" } }
    win_opts.footer_pos = "center"
  end

  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.wo[win].winhl = "Normal:ManualNormal,FloatBorder:ManualBorder"
  vim.wo[win].wrap = false

  state.win = win
  state.buf = buf

  vim.api.nvim_create_autocmd("ColorScheme", {
    buffer = buf,
    callback = setup_highlights,
  })

  return buf, win, w, h
end

-- ========================================================================== --
--                          CATEGORY PICKER POPUP                             --
-- ========================================================================== --

function M.open_picker()
  local lines = {}
  local highlights = {}
  local line_to_page = {}

  local function add_line(text, hl_spans)
    table.insert(lines, text)
    if hl_spans then
      highlights[#lines] = hl_spans
    end
  end

  add_line("")
  local header = "  Select a manual topic to view keybindings & motions:"
  add_line(header, { { "ManualSubtitle", 0, #header } })
  add_line("")

  local first_item_line = #lines + 1
  for idx, page in ipairs(M.pages) do
    local num_str = string.format("  [%d]  ", idx)
    local icon_str = page.icon
    local title_str = string.format("%-34s", page.title)
    local sep_str = "│  "
    local sum_str = page.summary
    local full = num_str .. icon_str .. title_str .. sep_str .. sum_str

    local c1 = #num_str
    local c2 = c1 + #icon_str
    local c3 = c2 + #title_str
    local c4 = c3 + #sep_str

    add_line(full, {
      { "ManualNumber", 0, c1 },
      { "ManualKey", c1, c2 },
      { "ManualTitle", c2, c3 },
      { "ManualMuted", c3, c4 },
      { "ManualDesc", c4, #full },
    })
    line_to_page[#lines] = idx
  end
  local last_item_line = #lines

  add_line("")
  local tip = "  Tip: Press 1-" .. #M.pages .. " or <Enter> to open a manual page  •  q / <Esc> to close"
  add_line(tip, { { "ManualMuted", 0, #tip } })
  add_line("")

  local max_w = 96
  for _, l in ipairs(lines) do
    max_w = math.max(max_w, vim.fn.strdisplaywidth(l) + 4)
  end

  local buf, win = create_float(
    max_w,
    #lines,
    "󰌌  Neovim Keybinds & Motions Manual",
    "j/k: Navigate  •  1-" .. #M.pages .. " / Enter: Open  •  q/Esc: Close"
  )
  state.mode = "picker"
  vim.wo[win].cursorline = true

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  for row, spans in pairs(highlights) do
    for _, sp in ipairs(spans) do
      pcall(vim.api.nvim_buf_add_highlight, buf, ns, sp[1], row - 1, sp[2], sp[3])
    end
  end

  -- Position cursor on previously selected page (or first item)
  local target_line = first_item_line + math.max(0, math.min(#M.pages - 1, (state.page_idx or 1) - 1))
  pcall(vim.api.nvim_win_set_cursor, win, { target_line, 2 })

  -- Keep cursor clamped strictly inside the selectable category rows
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      if not vim.api.nvim_win_is_valid(win) then
        return
      end
      local cur = vim.api.nvim_win_get_cursor(win)[1]
      if cur < first_item_line then
        pcall(vim.api.nvim_win_set_cursor, win, { first_item_line, 2 })
      elseif cur > last_item_line then
        pcall(vim.api.nvim_win_set_cursor, win, { last_item_line, 2 })
      end
    end,
  })

  local function select_current()
    local cur = vim.api.nvim_win_get_cursor(win)[1]
    local idx = line_to_page[cur]
    if idx then
      M.open_page(idx)
    end
  end

  local map_opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "<CR>", select_current, map_opts)
  vim.keymap.set("n", "l", select_current, map_opts)
  vim.keymap.set("n", "<Space>", select_current, map_opts)
  vim.keymap.set("n", "q", close_active, map_opts)
  vim.keymap.set("n", "<Esc>", close_active, map_opts)

  for i = 1, #M.pages do
    vim.keymap.set("n", tostring(i), function()
      M.open_page(i)
    end, map_opts)
  end
end

-- ========================================================================== --
--                            MANUAL READER POPUP                             --
-- ========================================================================== --

function M.open_page(idx_or_id)
  local page_idx = 1
  if type(idx_or_id) == "number" then
    page_idx = ((idx_or_id - 1) % #M.pages) + 1
  elseif type(idx_or_id) == "string" then
    local query = idx_or_id:lower()
    for i, p in ipairs(M.pages) do
      if p.id == query or p.title:lower():find(query, 1, true) then
        page_idx = i
        break
      end
    end
  end

  state.page_idx = page_idx
  local page = M.pages[page_idx]

  local lines = {}
  local highlights = {}

  local function add_line(text, hl_spans)
    table.insert(lines, text)
    if hl_spans then
      highlights[#lines] = hl_spans
    end
  end

  add_line("")
  local banner = string.format("  %s %s  (%d/%d)", page.icon, page.title, page_idx, #M.pages)
  add_line(banner, { { "ManualTitle", 0, #banner } })
  local sub = "  " .. page.summary
  add_line(sub, { { "ManualSubtitle", 0, #sub } })
  add_line("")

  local key_col_width = 24
  for _, sec in ipairs(page.sections) do
    local sec_hdr = "  ━━ " .. sec.heading .. " " .. string.rep("━", math.max(4, 78 - #sec.heading))
    add_line(sec_hdr, { { "ManualSection", 0, #sec_hdr } })

    for _, item in ipairs(sec.items) do
      local pad_len = math.max(2, key_col_width - vim.fn.strdisplaywidth(item.key))
      local key_part = "    " .. item.key .. string.rep(" ", pad_len)
      local sep_part = "│ "
      local desc_part = item.desc
      local row_str = key_part .. sep_part .. desc_part

      local c1 = #key_part
      local c2 = c1 + #sep_part
      add_line(row_str, {
        { "ManualKey", 0, c1 },
        { "ManualMuted", c1, c2 },
        { "ManualDesc", c2, #row_str },
      })
    end
    add_line("")
  end

  local nav_hint = "  [<BS> / b] Back to Categories   •   [[ / ]] Prev/Next Page   •   [/] Search   •   [q / <Esc>] Close"
  add_line(nav_hint, { { "ManualNote", 0, #nav_hint } })
  add_line("")

  local ui = vim.api.nvim_list_uis()[1]
  local max_rows = ui and math.floor(ui.height * 0.84) or 34
  local win_h = math.min(#lines, math.max(18, max_rows))
  local win_w = 104

  local buf, win = create_float(
    win_w,
    win_h,
    string.format("%s %s (%d/%d)", page.icon, page.title, page_idx, #M.pages),
    "<BS>/b: Categories  •  [ / ]: Prev/Next Topic  •  j/k/<C-d>/<C-u>: Scroll  •  q/Esc: Close"
  )
  state.mode = "page"
  vim.wo[win].cursorline = true

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  for row, spans in pairs(highlights) do
    for _, sp in ipairs(spans) do
      pcall(vim.api.nvim_buf_add_highlight, buf, ns, sp[1], row - 1, sp[2], sp[3])
    end
  end

  pcall(vim.api.nvim_win_set_cursor, win, { 2, 2 })

  local map_opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "<BS>", M.open_picker, map_opts)
  vim.keymap.set("n", "b", M.open_picker, map_opts)
  vim.keymap.set("n", "h", M.open_picker, map_opts)
  vim.keymap.set("n", "[", function()
    M.open_page(page_idx - 1)
  end, map_opts)
  vim.keymap.set("n", "]", function()
    M.open_page(page_idx + 1)
  end, map_opts)
  vim.keymap.set("n", "<Left>", function()
    M.open_page(page_idx - 1)
  end, map_opts)
  vim.keymap.set("n", "<Right>", function()
    M.open_page(page_idx + 1)
  end, map_opts)
  vim.keymap.set("n", "q", close_active, map_opts)
  vim.keymap.set("n", "<Esc>", close_active, map_opts)
end

function M.open(arg)
  if arg and arg ~= "" then
    M.open_page(arg)
  else
    M.open_picker()
  end
end

M.close = close_active
M._state = state

return M
