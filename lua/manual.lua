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
    summary = "How to move around, edit words/lines, copy & paste, select text, and record macros",
    sections = {
      {
        heading = "Basic Movement (Moving Around a Line)",
        items = {
          { key = "h / j / k / l", desc = "Move cursor Left (h), Down (j), Up (k), or Right (l) — type a number first like 10j to jump 10 lines" },
          { key = "w / b / e", desc = "Hop by word: 'w' jumps to start of next word, 'b' goes back a word, 'e' lands on the end of a word" },
          { key = "W / B / E", desc = "Same as w/b/e, but jumps across whole space-separated chunks (skips over dots, brackets & quotes)" },
          { key = "0 / ^ / $", desc = "'0' jumps to the very start of the line, '^' to the first letter/character, '$' to the end of the line" },
          { key = "f{char} / t{char}", desc = "Find on this line: 'f(' jumps right ON the next '(', 't(' stops right BEFORE it (press ; to repeat)" },
          { key = "F{char} / T{char}", desc = "Same as f/t, but searches backward to the left on the current line" },
          { key = "%", desc = "Stand on any bracket ( ), { }, or [ ] and press % to teleport to its matching partner" },
        },
      },
      {
        heading = "Jumping Around the File & Screen",
        items = {
          { key = "gg / G", desc = "'gg' jumps to the very top of the file, 'G' jumps to the bottom (type 42G to jump straight to line 42)" },
          { key = "{ / }", desc = "Jump up ({) or down (}) between empty lines — great for hopping from one code block to the next" },
          { key = "<C-u> / <C-d>", desc = "Scroll half a screen Up (Ctrl+u) or Down (Ctrl+d) smoothly" },
          { key = "<C-b> / <C-f>", desc = "Scroll a full screen Up/Back (Ctrl+b) or Down/Forward (Ctrl+f)" },
          { key = "zz / zt / zb", desc = "Keep cursor where it is, but scroll the screen so your line is in the Center (zz), Top (zt), or Bottom (zb)" },
          { key = "H / M / L", desc = "Move your cursor to the Highest line (H), Middle line (M), or Lowest line (L) currently visible on screen" },
          { key = "<C-o> / <C-i>", desc = "Like browser Back/Forward buttons: Ctrl+o jumps back to where your cursor was before, Ctrl+i goes forward" },
        },
      },
      {
        heading = "Action Keys (Press an Action, Then a Movement or Target)",
        items = {
          { key = "d + movement", desc = "Delete/Cut: 'dw' deletes a word, 'd$' deletes to end of line, 'dd' deletes the whole line" },
          { key = "c + movement", desc = "Change (delete & start typing): 'cw' replaces a word, 'c$' replaces to end of line, 'cc' rewrites the whole line" },
          { key = "y + movement", desc = "Yank (Copy): 'yw' copies a word, 'yy' copies the whole line, 'y$' copies to end of line (flashes briefly)" },
          { key = "> / < + movement", desc = "Indent right (>) or unindent left (<): press '>>' or '<<' twice to indent/unindent the current line" },
          { key = "= + movement", desc = "Fix code indentation automatically: '==' fixes the current line, 'gg=G' re-indents the entire file" },
          { key = "~ / gu / gU", desc = "'~' flips upper/lowercase under cursor, 'guiw' makes the current word lowercase, 'gUiw' makes it UPPERCASE" },
          { key = "u / <C-r>", desc = "'u' undoes your last change, 'Ctrl+r' redoes it — saved on disk so undo works even after reopening a file!" },
          { key = ".", desc = "The magic dot: repeats your last edit action with one keypress" },
        },
      },
      {
        heading = "Smart Targets (Use After d, c, y, or v — e.g. ciw, ci\", da()",
        items = {
          { key = "iw / aw", desc = "Current word: 'ciw' changes the word your cursor is on (even if cursor is in the middle of the word!)" },
          { key = "i\" / a\"", desc = "Double quotes: 'ci\"' deletes everything inside \"...\" and lets you type new text; 'da\"' deletes quotes too" },
          { key = "i' / a' / i` / a`", desc = "Single quotes or backticks: 'ci'' changes text inside '...', 'da'' deletes the quotes and text together" },
          { key = "i( / a(  or  ib / ab", desc = "Parentheses: 'ci(' changes everything inside (...), 'da(' deletes the parentheses and everything inside" },
          { key = "i{ / a{  or  iB / aB", desc = "Curly braces: 'ci{' empties out a { ... } block so you can rewrite it, 'yi{' copies everything inside" },
          { key = "i[ / a[", desc = "Square brackets: 'ci[' changes everything inside [...], 'da[' deletes the brackets and their contents" },
          { key = "it / at", desc = "HTML/JSX tags: 'cit' changes the text inside <tag>here</tag>, 'dat' deletes the entire tag element" },
          { key = "ip / ap", desc = "Paragraph / block: 'dip' deletes the whole contiguous block of lines, 'yip' copies the whole block" },
        },
      },
      {
        heading = "Typing (Insert Mode), Copy/Paste & Quick Character Edits",
        items = {
          { key = "i / a", desc = "Start typing: 'i' types right before the cursor, 'a' types right after the cursor" },
          { key = "I / A", desc = "'I' jumps to the start of the line and starts typing; 'A' jumps to the very end of the line and starts typing" },
          { key = "o / O", desc = "'o' creates a new blank line below and starts typing; 'O' creates a new blank line above and starts typing" },
          { key = "JJ  or  <Esc>", desc = "Type 'JJ' quickly (or press Esc) while typing to go back to Normal mode" },
          { key = "y / d / p", desc = "Copy (y), Cut (d), and Paste (p) share your OS clipboard — copy in browser with Ctrl+C and press 'p' here!" },
          { key = "p / P", desc = "'p' pastes after your cursor (or on the line below); 'P' pastes before your cursor (or on the line above)" },
          { key = "x / X", desc = "'x' deletes the character under the cursor, 'X' deletes behind it — without overwriting what you copied!" },
          { key = "r{char} / R", desc = "'r' + any key swaps the single character under cursor (e.g. 'ra' turns it into 'a'); 'R' overwrites continuously" },
          { key = "s / S", desc = "'s' deletes the character under cursor and starts typing; 'S' clears the whole line and starts typing" },
          { key = "D / C", desc = "'D' deletes from cursor to the end of the line; 'C' deletes to the end of the line and starts typing" },
          { key = "J", desc = "Pulls the line below up onto the end of the current line (joins two lines into one)" },
        },
      },
      {
        heading = "Selecting Text (Visual Mode), Searching & Recording Macros",
        items = {
          { key = "v / V / <C-v>", desc = "Highlight text: 'v' selects character-by-character, 'V' selects whole lines, 'Ctrl+v' selects vertical columns" },
          { key = "J / K  (Visual mode)", desc = "While lines are highlighted, press Shift+J or Shift+K to slide those lines down or up!" },
          { key = "< / >  (Visual mode)", desc = "While lines are highlighted, press < or > to indent them left/right without losing your selection" },
          { key = "p  (Visual mode)", desc = "Paste over highlighted text to replace it — without losing the copied text in your clipboard!" },
          { key = "gv / o", desc = "'gv' re-highlights your previous selection; 'o' (while highlighting) moves cursor to the other end of selection" },
          { key = "/{text} / ?{text}", desc = "Type '/word' + Enter to search forward ('?word' searches up). Press 'n' for next match, 'N' for previous" },
          { key = "* / #", desc = "Put cursor on any word and press '*' to instantly search for all occurrences of that exact word in the file" },
          { key = ":%s/old/new/gc", desc = "Find and replace 'old' with 'new' across the whole file, asking y/n before each replacement" },
          { key = "m{a-z} / '{a-z}", desc = "Bookmark a line: press 'ma' to save current spot as 'a', then press ''a' anytime to teleport back to it" },
          { key = "q{a-z} ... q", desc = "Record steps: press 'qa', perform any edits, then press 'q' to stop recording your keystrokes into slot 'a'" },
          { key = "@{a-z} / @@", desc = "Press '@a' to replay your recorded macro (or '10@a' to run it 10 times in a row! '@@' repeats the last macro)" },
        },
      },
    },
  },

  {
    id = "editing",
    icon = "󰅪 ",
    title = "Brackets, Autopairs & Comments",
    summary = "Auto-closing brackets/quotes, toggling comments, wrapping text & indent lines",
    sections = {
      {
        heading = "Auto-Pairs — Automatic Closing Brackets & Quotes (nvim-autopairs)",
        items = {
          { key = "(  [  {  \"  '", desc = "When typing, opening a bracket or quote automatically adds the closing one and puts your cursor inside" },
          { key = "<CR>  inside {|}", desc = "Pressing Enter between {} or () splits them onto a new indented line ready for your code" },
          { key = "<BS>  inside (|)", desc = "Pressing Backspace inside empty () or \"\" deletes both the opening and closing characters together" },
          { key = ")  ]  }  \"  '", desc = "Typing a closing bracket/quote when one is already right in front of your cursor neatly steps over it" },
          { key = "<A-e>  (Alt + e)", desc = "While typing, press Alt+e before an expression, then press a highlighted letter to wrap it in brackets" },
        },
      },
      {
        heading = "Commenting Out Code (Comment.nvim)",
        items = {
          { key = "gcc", desc = "Comment or uncomment the current line using single-line comments (like //, #, or --)" },
          { key = "gbc", desc = "Wrap or unwrap the current line in a block comment (like /* ... */)" },
          { key = "gc  (Visual mode)", desc = "Highlight multiple lines with V, then press 'gc' to comment or uncomment all of them at once" },
          { key = "gb  (Visual mode)", desc = "Highlight multiple lines with V, then press 'gb' to wrap the whole block inside /* ... */" },
          { key = "gc + movement", desc = "Comment a target: e.g. 'gcip' comments the whole paragraph, 'gc4j' comments this line and 4 lines down" },
          { key = "gb + movement", desc = "Block-comment a target: e.g. 'gbip' wraps the entire paragraph inside a /* ... */ block comment" },
          { key = "gco / gcO / gcA", desc = "Create a new commented line below (gco), above (gcO), or add a comment at the end of this line (gcA)" },
        },
      },
      {
        heading = "Surround — Add, Swap, or Remove Brackets & Quotes Around Text (nvim-surround)",
        items = {
          { key = "S{char}  (Visual)", desc = "Highlight text with 'v', then press Shift+S followed by ) or \" or } to wrap your selection in it" },
          { key = "ysiw) / ysiw\"", desc = "Put cursor on a word and type 'ysiw)' to turn word into (word), or 'ysiw\"' to turn it into \"word\"" },
          { key = "yss) / yss}", desc = "Wrap the entire current line inside (...) with 'yss)' or inside {...} with 'yss}'" },
          { key = "cs({  or  cs\"'", desc = "Swap existing brackets/quotes: 'cs({' changes (text) into {text}; 'cs\"'' changes \"text\" into 'text'" },
          { key = "ds( / ds{ / ds\"", desc = "Remove surrounding brackets/quotes: 'ds\"' turns \"hello\" into hello, leaving the word itself untouched" },
        },
      },
      {
        heading = "Vertical Indentation Guide Lines (indent-blankline.nvim)",
        items = {
          { key = "│  (Automatic)", desc = "Draws thin vertical guide lines so you can easily see which '{' matches which '}' in nested blocks" },
          { key = ":IBLToggle", desc = "Type :IBLToggle and press Enter if you ever want to hide or show the vertical guide lines" },
        },
      },
    },
  },

  {
    id = "core",
    icon = " ",
    title = "Core Config & Window Splits",
    summary = "Your custom shortcuts, automatic quality-of-life features & side-by-side split windows",
    sections = {
      {
        heading = "Everyday Shortcuts (lua/vim-options.lua)",
        items = {
          { key = "<Space>", desc = "Your main shortcut key ('Leader' key) — press Space followed by the letters below to trigger commands" },
          { key = "JJ", desc = "Type JJ quickly while in Insert mode to exit back to Normal mode without reaching for Esc" },
          { key = "<Space>h", desc = "Turn off yellow search highlights after searching for a word with / or *" },
          { key = "J / K  (Visual mode)", desc = "Highlight lines with V, then press Shift+J or Shift+K to move those lines down or up" },
          { key = "< / >  (Visual mode)", desc = "Highlight lines with V, then press < or > to shift their indentation left or right repeatedly" },
          { key = "<Space>m", desc = "Open this interactive Keybinds & Motions Manual anytime" },
          { key = "<Space>as", desc = "Open your animated ASCII Startup Screen anytime" },
        },
      },
      {
        heading = "Automatic Quality-of-Life Features (Always Active)",
        items = {
          { key = "Persistent Undo", desc = "Your undo history is saved on disk — you can close a file, reopen it tomorrow, and still press 'u' to undo" },
          { key = "System Clipboard", desc = "Copying (y) and pasting (p) automatically use your OS clipboard so Neovim and your browser share copy/paste" },
          { key = "Safe Delete (x / p)", desc = "Deleting characters with 'x' or pasting over selected text won't overwrite what you copied in your clipboard" },
          { key = "Highlight on Copy", desc = "Whenever you copy text with 'y', it briefly flashes on screen so you can see exactly what was copied" },
          { key = "Remember Line", desc = "When you reopen a file, your cursor automatically jumps back to the exact line you were editing last time" },
          { key = "Clean Multi-Comment", desc = "Pressing Enter after /* gives you a clean new line instead of automatically forcing '*' on every line" },
        },
      },
      {
        heading = "Creating & Closing Split Windows (lua/plugins/bufferLine.lua)",
        items = {
          { key = "<Space>sv", desc = "Split the screen vertically so you can view/edit two files side-by-side" },
          { key = "<Space>sh", desc = "Split the screen horizontally (one file on top, one file on the bottom)" },
          { key = "<Space>se", desc = "Resize all open split panes so they become equal width and height again" },
          { key = "<Space>sx", desc = "Close the current split pane without quitting Neovim" },
        },
      },
      {
        heading = "Jumping Between Split Windows (lua/vim-options.lua)",
        items = {
          { key = "<C-h>", desc = "Press Ctrl+h to move your cursor into the split window on the Left" },
          { key = "<C-j>", desc = "Press Ctrl+j to move your cursor into the split window Below" },
          { key = "<C-k>", desc = "Press Ctrl+k to move your cursor into the split window Above" },
          { key = "<C-l>", desc = "Press Ctrl+l to move your cursor into the split window on the Right" },
          { key = "<C-w>r / <C-w>x", desc = "Press Ctrl+w then 'r' to swap the positions of your open split windows" },
          { key = "<C-w>| / <C-w>_", desc = "Maximize the current split's width (Ctrl+w then |) or height (Ctrl+w then _) — press Space+se to reset" },
        },
      },
    },
  },

  {
    id = "bufferline",
    icon = "󰓩 ",
    title = "Bufferline (Top File Tabs)",
    summary = "How to switch between open file tabs at the top of the screen, reorder them & close them",
    sections = {
      {
        heading = "Switching Between Open File Tabs",
        items = {
          { key = "<S-l>  (Shift + l)", desc = "Switch to the next file tab on the right" },
          { key = "<S-h>  (Shift + h)", desc = "Switch to the previous file tab on the left" },
          { key = "<Space>1 .. <Space>9", desc = "Press Space + a tab's number (1 to 9) to jump straight to that file tab" },
          { key = "<Space>bp", desc = "Shows a letter on each tab at the top — press that letter to jump directly to that file" },
        },
      },
      {
        heading = "Moving & Pinning Tabs",
        items = {
          { key = "<A-l>  (Alt + l)", desc = "Slide the current file tab one spot to the right on the top bar" },
          { key = "<A-h>  (Alt + h)", desc = "Slide the current file tab one spot to the left on the top bar" },
          { key = "<Space>P", desc = "Pin (or unpin) the current file tab so it stays locked on the left side of the tab bar" },
        },
      },
      {
        heading = "Closing File Tabs",
        items = {
          { key = "<Space>x", desc = "Close the current file tab cleanly without messing up your split windows or sidebar" },
          { key = "<Space>bc", desc = "Shows a letter on each tab — type a tab's letter to close that specific tab" },
          { key = "<Space>bo", desc = "Close every other open file tab except the one you are currently looking at (and pinned tabs)" },
          { key = "<Space>bl", desc = "Close all file tabs to the left of your current tab" },
          { key = "<Space>br", desc = "Close all file tabs to the right of your current tab" },
        },
      },
    },
  },

  {
    id = "explorers",
    icon = "󰙅 ",
    title = "File Explorers (Neo-tree & Oil)",
    summary = "Browse files in the left sidebar tree (Neo-tree) or edit folders like a normal text buffer (Oil)",
    sections = {
      {
        heading = "Opening Neo-tree From Anywhere (lua/plugins/neo-tree.lua)",
        items = {
          { key = "<C-n>", desc = "Press Ctrl+n to open or hide the file explorer sidebar on the left side of the screen" },
          { key = "<Space>bf", desc = "Pop up a floating window listing only the files you currently have open" },
          { key = "<Space>gf", desc = "Pop up a floating window showing only files that have uncommitted Git changes" },
        },
      },
      {
        heading = "Keys to Use While Your Cursor Is Inside the Neo-tree Sidebar",
        items = {
          { key = "<CR>  or  l", desc = "Press Enter (or l) on a file to open it, or on a folder to open/close that folder" },
          { key = "<BS>  or  h", desc = "Press Backspace to go up one folder level, or 'h' to collapse an open folder" },
          { key = "s / S", desc = "Open the highlighted file in a side-by-side vertical split (s) or top-and-bottom horizontal split (S)" },
          { key = "P", desc = "Toggle a live preview window so you can peek inside files as you move up and down the tree" },
          { key = "a / A", desc = "Press 'a' to create a new file (end the name with '/' to create a folder, or press Shift+A for a folder)" },
          { key = "d", desc = "Delete the highlighted file or folder (asks for confirmation first)" },
          { key = "r / b", desc = "Press 'r' to rename a file/folder, or 'b' to rename just the file name without touching its extension" },
          { key = "y / x / p", desc = "Copy a file (y), Cut a file to move it (x), and Paste it into the selected folder (p)" },
          { key = "c / m", desc = "Copy (c) or Move (m) the file by typing the destination path directly" },
          { key = "H / .", desc = "Press Shift+H to show/hide dotfiles (like .gitignore); press '.' to make the selected folder the root" },
          { key = "R / ?", desc = "Press Shift+R to refresh the file list; press '?' to view all Neo-tree shortcuts" },
        },
      },
      {
        heading = "Oil.nvim — Edit Folders Like a Regular Text File (lua/plugins/oil.lua)",
        items = {
          { key = "-", desc = "Press '-' in any file to pop open its folder in Oil — where every file/folder is just a line of text!" },
          { key = "<CR>", desc = "Press Enter on any file or folder in the list to open it" },
          { key = "-  (inside Oil)", desc = "Press '-' while inside Oil to go up to the parent folder" },
          { key = ":w  (inside Oil)", desc = "The magic of Oil: add, rename, or delete lines using normal Vim edits, then type :w to apply to disk!" },
          { key = "g.", desc = "Show or hide hidden dotfiles (files starting with a dot)" },
          { key = "<C-p>", desc = "Open a preview pane for the file under your cursor" },
          { key = "<C-v> / <C-s>", desc = "Open the file under your cursor in a vertical split (Ctrl+v) or horizontal split (Ctrl+s)" },
          { key = "g?", desc = "Press g? inside Oil to see all available Oil shortcuts" },
        },
      },
    },
  },

  {
    id = "telescope",
    icon = "󰈞 ",
    title = "Telescope (Search Files & Text)",
    summary = "Quickly find any file by name, search for words across your whole project, or reopen recent files",
    sections = {
      {
        heading = "Opening Telescope Search From Anywhere (lua/plugins/telescope.lua)",
        items = {
          { key = "<Space>ff", desc = "Find File: type part of any filename to find and open it from anywhere in your project" },
          { key = "<Space>fg", desc = "Find Text (Live Grep): type any word or code snippet to search inside every file in your project" },
          { key = "<Space><Space>", desc = "Recent Files: press Space twice to see a list of files you recently opened and jump right back in" },
        },
      },
      {
        heading = "Keys to Use While the Telescope Search Popup Is Open",
        items = {
          { key = "<Down> / <Up>", desc = "Move down and up through the search results (Ctrl+n and Ctrl+p also work)" },
          { key = "<CR>", desc = "Press Enter to open the highlighted file" },
          { key = "<C-v>", desc = "Press Ctrl+v to open the highlighted file side-by-side in a vertical split" },
          { key = "<C-x>", desc = "Press Ctrl+x to open the highlighted file in a horizontal split" },
          { key = "<C-t>", desc = "Press Ctrl+t to open the highlighted file in a new workspace tab" },
          { key = "<C-u> / <C-d>", desc = "Scroll the file preview pane on the right Up (Ctrl+u) or Down (Ctrl+d)" },
          { key = "<Tab> / <S-Tab>", desc = "Mark/unmark multiple files in the list so you can act on several results at once" },
          { key = "<C-q>", desc = "Send the search results to the Quickfix list so you can step through all matches without reopening Telescope" },
          { key = "<Esc> / <C-c>", desc = "Close the Telescope search popup" },
        },
      },
    },
  },

  {
    id = "git",
    icon = "󰊢 ",
    title = "Git (Changes, Blame, Diffs & History)",
    summary = "See what lines you changed, stage/undo specific blocks, check who wrote a line & view full diffs",
    sections = {
      {
        heading = "Jumping Between Changed Blocks ('Hunks') & Previewing (Gitsigns)",
        items = {
          { key = "]h", desc = "Jump down to the next changed/added block of lines in the current file" },
          { key = "[h", desc = "Jump up to the previous changed/added block of lines in the current file" },
          { key = "<Space>gp", desc = "Pop up a small window showing what this block of lines looked like before your edit" },
          { key = "<Space>gi", desc = "Show the old deleted lines directly inline right above your new lines inside the file" },
        },
      },
      {
        heading = "Staging, Undoing Git Changes & Checking 'Who Wrote This?' (Gitsigns)",
        items = {
          { key = "<Space>gs", desc = "Stage ONLY the changed block under your cursor for commit (or highlight specific lines with V first)" },
          { key = "<Space>gr", desc = "Discard/undo your uncommitted edits in the current block and restore the original Git version" },
          { key = "<Space>gu", desc = "Unstage the last block you staged with Space+gs" },
          { key = "<Space>gS", desc = "Stage every change in the entire current file (`git add` this file)" },
          { key = "<Space>gR", desc = "Discard ALL uncommitted changes in the entire current file (`git checkout` this file)" },
          { key = "<Space>gt", desc = "Show/hide faint text at the end of the line telling you who last edited it and when (Git Blame)" },
          { key = "<Space>gb", desc = "Open a popup showing the full commit message and author details for the current line" },
          { key = "<Space>gd", desc = "Open a side-by-side comparison showing the saved Git version of this file vs. your current edits" },
        },
      },
      {
        heading = "Full Project Diffs, Commit History & Committing (Diffview & Fugitive)",
        items = {
          { key = "<Space>gv", desc = "Open (or close) a full side-by-side review screen of all modified files in your repository" },
          { key = "<Space>gh", desc = "Browse every past Git commit that ever touched the file you are currently editing" },
          { key = "<Space>gH", desc = "Browse the full commit history of the entire Git repository with side-by-side diffs" },
          { key = "<Space>gx  or  q", desc = "Close the Diffview review screen and return to your normal editor layout" },
          { key = "s  (in Diffview)", desc = "While in Diffview's left file list, press 's' on any file to stage or unstage it" },
          { key = "<Space>gg  or  :Git", desc = "Open the interactive Git status dashboard (press 's' to stage files, 'cc' to write a commit message)" },
        },
      },
    },
  },

  {
    id = "startup",
    icon = "☄️ ",
    title = "Startup Screen & Commands",
    summary = "One-key shortcuts on the animated home screen and commands to switch background animations",
    sections = {
      {
        heading = "Single-Key Shortcuts on the Startup Screen (lua/ascii-sharks.lua)",
        items = {
          { key = "f", desc = "Press 'f' to search and open a file in your project (Telescope Find Files)" },
          { key = "g", desc = "Press 'g' to search for text inside files across your project (Telescope Live Grep)" },
          { key = "r", desc = "Press 'r' to pick from your recently edited files" },
          { key = "e", desc = "Press 'e' to start typing in a brand-new empty file" },
          { key = "m", desc = "Press 'm' to open this interactive Keybinds & Motions Manual" },
          { key = "a", desc = "Press 'a' to cycle the live background animation (Meteorite Shower -> Dragon -> Sharks)" },
          { key = "l", desc = "Press 'l' to open the Lazy.nvim plugin manager window" },
          { key = "q", desc = "Press 'q' to quit Neovim" },
        },
      },
      {
        heading = "Commands & Shortcuts You Can Run Anytime",
        items = {
          { key = "<Space>m  or  :Manual", desc = "Open this Manual from any file (or type :Manual git to jump straight to a specific page)" },
          { key = "<Space>as", desc = "Return to the animated ASCII startup dashboard at any time" },
          { key = ":Meteors", desc = "Open the startup dashboard with the falling Meteorite Shower animation" },
          { key = ":Dragon", desc = "Open the startup dashboard with the breathing Dragon & Embers animation" },
          { key = ":Sharks", desc = "Open the startup dashboard with the swimming Sharks & Ocean animation" },
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
  for _, l in ipairs(lines) do
    win_w = math.max(win_w, vim.fn.strdisplaywidth(l) + 4)
  end

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
