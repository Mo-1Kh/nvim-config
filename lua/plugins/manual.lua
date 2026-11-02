local manual = require("manual")

vim.api.nvim_create_user_command("Manual", function(opts)
  manual.open(opts.args)
end, {
  nargs = "?",
  complete = function(arg_lead)
    local matches = {}
    for _, p in ipairs(manual.pages) do
      if p.id:find("^" .. vim.pesc(arg_lead:lower())) then
        table.insert(matches, p.id)
      end
    end
    return matches
  end,
  desc = "Open Keybinds & Motions Manual",
})

vim.keymap.set("n", "<leader>m", function()
  manual.open_picker()
end, { desc = "Open Keybinds & Motions Manual" })

return {}
