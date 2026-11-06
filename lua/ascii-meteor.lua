-- Animated ASCII Meteorite Shower startup screen for Neovim
local M = {}

local TAU = math.pi * 2

local function clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function rand(lo, hi)
  return lo + math.random() * (hi - lo)
end

local bit = bit or require("bit")
local band, rshift = bit.band, bit.rshift

local ns = vim.api.nvim_create_namespace("ascii_meteor")

local function int_to_rgb(c, fallback)
  if not c or c < 0 then
    return fallback[1], fallback[2], fallback[3]
  end
  return band(rshift(c, 16), 0xff), band(rshift(c, 8), 0xff), band(c, 0xff)
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", clamp(math.floor(r), 0, 255), clamp(math.floor(g), 0, 255), clamp(math.floor(b), 0, 255))
end

local function mix_rgb(c1, c2, t)
  return {
    c1[1] + (c2[1] - c1[1]) * t,
    c1[2] + (c2[2] - c1[2]) * t,
    c1[3] + (c2[3] - c1[3]) * t,
  }
end

local function get_hl_rgb(name, attr, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and hl and hl[attr] then
    return { int_to_rgb(hl[attr], fallback) }
  end
  return fallback
end

local function setup_highlights()
  -- Pull colors directly from the active Neovim colorscheme (e.g. Gruvbox)
  local bg_rgb = get_hl_rgb("Normal", "bg", { 29, 32, 33 })
  local fg_rgb = get_hl_rgb("Normal", "fg", { 235, 219, 178 })
  local comment_rgb = get_hl_rgb("Comment", "fg", { 146, 131, 116 })
  local special_rgb = get_hl_rgb("Special", "fg", { 254, 128, 25 })
  local func_rgb = get_hl_rgb("Function", "fg", { 184, 187, 38 })
  local const_rgb = get_hl_rgb("Constant", "fg", { 211, 134, 155 })
  local type_rgb = get_hl_rgb("Type", "fg", { 250, 189, 47 })
  local str_rgb = get_hl_rgb("String", "fg", { 184, 187, 38 })
  local diag_info = get_hl_rgb("DiagnosticInfo", "fg", { 131, 165, 152 })
  local diag_err = get_hl_rgb("DiagnosticError", "fg", { 251, 73, 52 })
  local card_bg_rgb = mix_rgb(bg_rgb, fg_rgb, 0.06)

  local bg_hex = rgb_to_hex(bg_rgb[1], bg_rgb[2], bg_rgb[3])
  local fg_hex = rgb_to_hex(fg_rgb[1], fg_rgb[2], fg_rgb[3])
  local card_bg_hex = rgb_to_hex(card_bg_rgb[1], card_bg_rgb[2], card_bg_rgb[3])

  vim.api.nvim_set_hl(0, "MeteorBg", { bg = bg_hex, fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, comment_rgb, 0.25))) })

  -- Meteorite Shower / Bolide Fireball Storm highlights
  vim.api.nvim_set_hl(0, "MeteorStarDim", { bg = bg_hex, fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, comment_rgb, 0.35))) })
  vim.api.nvim_set_hl(0, "MeteorStarMid", { bg = bg_hex, fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, fg_rgb, 0.55))) })
  vim.api.nvim_set_hl(0, "MeteorStarBright", { bg = bg_hex, fg = fg_hex, bold = true })

  local meteor_palettes = {
    inferno = {
      core = fg_rgb,
      hot = type_rgb,
      fire = special_rgb,
      ember = diag_err,
      ion = diag_info,
    },
    cobalt = {
      core = fg_rgb,
      hot = diag_info,
      fire = const_rgb,
      ember = type_rgb,
      ion = str_rgb,
    },
    emerald = {
      core = fg_rgb,
      hot = func_rgb,
      fire = str_rgb,
      ember = diag_info,
      ion = type_rgb,
    },
  }
  for mname, mpal in pairs(meteor_palettes) do
    vim.api.nvim_set_hl(0, "MeteorCoreHot_" .. mname, {
      bg = rgb_to_hex(unpack(mpal.core)),
      fg = bg_hex,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorCrustBright_" .. mname, {
      bg = rgb_to_hex(unpack(mix_rgb(bg_rgb, mpal.hot, 0.82))),
      fg = bg_hex,
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorCrustMid_" .. mname, {
      bg = rgb_to_hex(unpack(mix_rgb(bg_rgb, mpal.fire, 0.52))),
      fg = rgb_to_hex(unpack(mpal.hot)),
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorRockDark_" .. mname, {
      bg = rgb_to_hex(unpack(mix_rgb(bg_rgb, comment_rgb, 0.30))),
      fg = rgb_to_hex(unpack(mix_rgb(comment_rgb, mpal.fire, 0.45))),
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorShock_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mpal.core)),
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorTrailHot_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mpal.hot)),
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorTrailFire_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mpal.fire)),
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorTrailEmber_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, mpal.ember, 0.72))),
    })
    vim.api.nvim_set_hl(0, "MeteorSmoke_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, comment_rgb, 0.42))),
    })
    vim.api.nvim_set_hl(0, "MeteorIon_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mpal.ion)),
      bold = true,
    })
    vim.api.nvim_set_hl(0, "MeteorIonDim_" .. mname, {
      bg = bg_hex,
      fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, mpal.ion, 0.52))),
    })
  end

  vim.api.nvim_set_hl(0, "MeteorHeader", { bg = bg_hex, fg = rgb_to_hex(unpack(type_rgb)), bold = true })
  vim.api.nvim_set_hl(0, "MeteorDate", { bg = bg_hex, fg = rgb_to_hex(unpack(diag_info)), bold = true })
  vim.api.nvim_set_hl(0, "MeteorKey", { bg = card_bg_hex, fg = rgb_to_hex(unpack(special_rgb)), bold = true })
  vim.api.nvim_set_hl(0, "MeteorSubtitle", { bg = card_bg_hex, fg = rgb_to_hex(unpack(func_rgb)) })
  vim.api.nvim_set_hl(0, "MeteorDesc", { bg = card_bg_hex, fg = fg_hex })
  vim.api.nvim_set_hl(0, "MeteorBoxBorder", { bg = card_bg_hex, fg = rgb_to_hex(unpack(mix_rgb(bg_rgb, comment_rgb, 0.7))) })
  vim.api.nvim_set_hl(0, "MeteorFooter", { bg = bg_hex, fg = rgb_to_hex(unpack(const_rgb)), italic = true })
end

local METEOR_PRESETS = {
  {
    name = "Perseid Fireball Storm",
    palette = "inferno",
    -- Originating from above-left, streaking diagonally down-right (\)
    dir_x = 0.78,
    dir_y = 0.62,
    max_meteors = 16,
    spawn_rate = 0.22,
    bolide_chance = 0.26,
  },
}

local step_sim

local function spawn_meteor(sim, met, prewarm)
  local W, H = sim.W, sim.H
  local preset = met.preset
  local base_angle = math.atan2(preset.dir_y, preset.dir_x) + rand(-0.08, 0.08)
  local dx = math.cos(base_angle)
  local dy = math.sin(base_angle)

  -- Choose meteoroid class:
  -- 1 = fast shooting-star streak, 2 = medium burning fireball, 3 = massive tumbling bolide
  local roll = math.random()
  local mkind
  local radius, speed, max_hist
  if roll < preset.bolide_chance then
    mkind = "bolide"
    radius = rand(18, 26)
    speed = rand(210, 290)
    max_hist = 28
  elseif roll < 0.68 then
    mkind = "fireball"
    radius = rand(10, 15)
    speed = rand(300, 420)
    max_hist = 22
  else
    mkind = "streak"
    radius = 5
    speed = rand(460, 640)
    max_hist = 16
  end

  local x, y
  if prewarm then
    x = rand(-W * 0.15, W * 0.95)
    y = rand(-H * 0.15, H * 0.85)
  else
    -- Spawn along the top sky or upper-left (or upper-right if dir_x < 0) so the entire screen is covered
    if dx >= 0 then
      if math.random() < 0.62 then
        x = rand(-W * 0.25, W * 0.75)
        y = rand(-45, -10)
      else
        x = rand(-45, -10)
        y = rand(-20, H * 0.65)
      end
    else
      if math.random() < 0.62 then
        x = rand(W * 0.25, W * 1.25)
        y = rand(-45, -10)
      else
        x = rand(W + 10, W + 45)
        y = rand(-20, H * 0.65)
      end
    end
  end

  table.insert(met.meteors, {
    id = math.random(1, 100000),
    kind = mkind,
    x = x,
    y = y,
    vx = dx * speed,
    vy = dy * speed,
    speed = speed,
    radius = radius,
    rot = rand(0, TAU),
    rot_speed = rand(-3.8, 3.8),
    seed = rand(0, 100),
    fragmented = false,
    burst_y = H * rand(0.32, 0.72),
    can_fragment = (mkind == "bolide" and math.random() < 0.55),
    history = { { x = x, y = y } },
    max_hist = max_hist,
  })
end

local function step_meteor(sim, dt)
  local met = sim.meteor
  if not met then return end
  local W, H = sim.W, sim.H
  local preset = met.preset

  -- 1. Spawn new meteorites continuously
  met.spawn_timer = met.spawn_timer - dt
  if met.spawn_timer <= 0 and #met.meteors < preset.max_meteors then
    met.spawn_timer = preset.spawn_rate * rand(0.6, 1.35)
    spawn_meteor(sim, met, false)
  end

  -- 2. Advance active meteorites, record plasma trails, shed ablation sparks, and trigger airbursts
  for i = #met.meteors, 1, -1 do
    local m = met.meteors[i]
    m.x = m.x + m.vx * dt
    m.y = m.y + m.vy * dt
    m.rot = m.rot + m.rot_speed * dt

    table.insert(m.history, 1, { x = m.x, y = m.y })
    while #m.history > m.max_hist do
      table.remove(m.history)
    end

    -- Shed glowing ablation sparks & smoky wake particles from fireballs and bolides
    if m.kind ~= "streak" and #met.sparks < 160 and math.random() < (m.kind == "bolide" and 0.85 or 0.50) then
      local perp_x = -m.vy / m.speed
      local perp_y = m.vx / m.speed
      local side = (math.random() < 0.5 and 1 or -1) * rand(15, 55)
      table.insert(met.sparks, {
        x = m.x - (m.vx / m.speed) * (m.radius * 0.6) + perp_x * rand(-m.radius * 0.5, m.radius * 0.5),
        y = m.y - (m.vy / m.speed) * (m.radius * 0.6) + perp_y * rand(-m.radius * 0.5, m.radius * 0.5),
        vx = m.vx * 0.25 + perp_x * side,
        vy = m.vy * 0.25 + perp_y * side,
        life = 1.0,
        decay = rand(1.1, 2.2),
        glyph = (math.random() < 0.45) and "*" or "•",
      })
    end

    -- Atmospheric Airburst Fragmentation for massive bolides!
    if m.can_fragment and not m.fragmented and m.y >= m.burst_y and m.x > W * 0.12 and m.x < W * 0.88 then
      m.fragmented = true
      m.radius = m.radius * 0.68
      -- Expanding airburst flash ring
      table.insert(met.bursts, {
        x = m.x,
        y = m.y,
        r = 8,
        max_r = rand(48, 76),
        alpha = 1.0,
      })
      -- Burst of glowing sparks
      for _ = 1, 14 do
        local ang = rand(0, TAU)
        local spd = rand(30, 110)
        table.insert(met.sparks, {
          x = m.x,
          y = m.y,
          vx = m.vx * 0.35 + math.cos(ang) * spd,
          vy = m.vy * 0.35 + math.sin(ang) * spd,
          life = 1.0,
          decay = rand(1.2, 2.4),
          glyph = "*",
        })
      end
      -- Split off 2 smaller burning fireball fragments
      local base_ang = math.atan2(m.vy, m.vx)
      for f = -1, 1, 2 do
        local fang = base_ang + f * rand(0.14, 0.26)
        local fspd = m.speed * rand(0.95, 1.18)
        table.insert(met.meteors, {
          id = math.random(1, 100000),
          kind = "fireball",
          x = m.x,
          y = m.y,
          vx = math.cos(fang) * fspd,
          vy = math.sin(fang) * fspd,
          speed = fspd,
          radius = rand(9, 13),
          rot = rand(0, TAU),
          rot_speed = rand(-4, 4),
          seed = rand(0, 100),
          fragmented = true,
          burst_y = H * 2,
          can_fragment = false,
          history = { { x = m.x, y = m.y } },
          max_hist = 18,
        })
      end
    end

    -- Despawn once completely past the bottom/side of the screen
    if m.y > H + 180 or m.x > W + 220 or m.x < -220 then
      table.remove(met.meteors, i)
    end
  end

  -- 3. Step drifting ablation sparks & smoke embers
  for i = #met.sparks, 1, -1 do
    local sp = met.sparks[i]
    sp.vx = sp.vx * 0.94
    sp.vy = sp.vy * 0.94 + 12 * dt
    sp.x = sp.x + sp.vx * dt
    sp.y = sp.y + sp.vy * dt
    sp.life = sp.life - sp.decay * dt
    if sp.life <= 0 then
      table.remove(met.sparks, i)
    end
  end

  -- 4. Step airburst shockwave rings
  for i = #met.bursts, 1, -1 do
    local b = met.bursts[i]
    b.r = b.r + 145 * dt
    b.alpha = 1.0 - (b.r / b.max_r)
    if b.r >= b.max_r or b.alpha <= 0.05 then
      table.remove(met.bursts, i)
    end
  end
end

local function create_sim(cols, rows, preset_idx)
  local cw, ch = 10, 15
  local W = cols * cw
  local H = rows * ch

  local preset = METEOR_PRESETS[((preset_idx - 1) % #METEOR_PRESETS) + 1]

  -- Deep-space twinkling starfield
  local stars = {}
  local star_count = clamp(math.floor((cols * rows) / 28), 65, 160)
  local star_glyphs = { "·", ".", "·", "+", "✦" }
  for i = 1, star_count do
    table.insert(stars, {
      u = math.random(),
      v = math.random(),
      glyph = star_glyphs[(i % #star_glyphs) + 1],
      phase = rand(0, TAU),
      speed = rand(1.2, 3.8),
      bright = (i % 7 == 0),
    })
  end

  local sim = {
    cols = cols,
    rows = rows,
    cw = cw,
    ch = ch,
    W = W,
    H = H,
    time = 0,
    meteor = {
      preset = preset,
      stars = stars,
      meteors = {},
      sparks = {},
      bursts = {},
      spawn_timer = 0.05,
    },
  }

  -- Pre-populate and advance 35 steps so meteorites and burning trails are already streaking across the sky on Frame 1
  for _ = 1, 8 do
    spawn_meteor(sim, sim.meteor, true)
  end
  for _ = 1, 35 do
    step_sim(sim, 0.045)
  end
  return sim
end

step_sim = function(sim, dt)
  sim.time = sim.time + dt
  step_meteor(sim, dt)
end

local WEEK_HEADERS = {
  Sunday = {
    "███████╗██╗   ██╗███╗   ██╗██████╗  █████╗ ██╗   ██╗",
    "██╔════╝██║   ██║████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "███████╗██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ",
    "╚════██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ",
    "███████║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ",
    "╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
  Monday = {
    "███╗   ███╗ ██████╗ ███╗   ██╗██████╗  █████╗ ██╗   ██╗",
    "████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ",
    "██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ",
    "██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ",
    "╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
  Tuesday = {
    "████████╗██╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗",
    "╚══██╔══╝██║   ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "   ██║   ██║   ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝ ",
    "   ██║   ██║   ██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝  ",
    "   ██║   ╚██████╔╝███████╗███████║██████╔╝██║  ██║   ██║   ",
    "   ╚═╝    ╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
  Wednesday = {
    "██╗    ██╗███████╗██████╗ ███╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗",
    "██║    ██║██╔════╝██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "██║ █╗ ██║█████╗  ██║  ██║██╔██╗ ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝ ",
    "██║███╗██║██╔══╝  ██║  ██║██║╚██╗██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝  ",
    "╚███╔███╔╝███████╗██████╔╝██║ ╚████║███████╗███████║██████╔╝██║  ██║   ██║   ",
    " ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
  Thursday = {
    "████████╗██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗ ██╗   ██╗",
    "╚══██╔══╝██║  ██║██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "   ██║   ███████║██║   ██║██████╔╝███████╗██║  ██║███████║ ╚████╔╝ ",
    "   ██║   ██╔══██║██║   ██║██╔══██╗╚════██║██║  ██║██╔══██║  ╚██╔╝  ",
    "   ██║   ██║  ██║╚██████╔╝██║  ██║███████║██████╔╝██║  ██║   ██║   ",
    "   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
  Friday = {
    "███████╗██████╗ ██╗██████╗  █████╗ ██╗   ██╗",
    "██╔════╝██╔══██╗██║██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "█████╗  ██████╔╝██║██║  ██║███████║ ╚████╔╝ ",
    "██╔══╝  ██╔══██╗██║██║  ██║██╔══██║  ╚██╔╝  ",
    "██║     ██║  ██║██║██████╔╝██║  ██║   ██║   ",
    "╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
  Saturday = {
    "███████╗ █████╗ ████████╗██╗   ██╗██████╗ ██████╗  █████╗ ██╗   ██╗",
    "██╔════╝██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝",
    "███████╗███████║   ██║   ██║   ██║██████╔╝██║  ██║███████║ ╚████╔╝ ",
    "╚════██║██╔══██║   ██║   ██║   ██║██╔══██╗██║  ██║██╔══██║  ╚██╔╝  ",
    "███████║██║  ██║   ██║   ╚██████╔╝██║  ██║██████╔╝██║  ██║   ██║   ",
    "╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ",
  },
}

local DAYS_OF_WEEK = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }

local MENU_ITEMS = {
  { key = "f", icon = "󰈞 ", desc = "Find Files", cmd = "Telescope find_files" },
  { key = "g", icon = "󰱼 ", desc = "Live Grep", cmd = "Telescope live_grep" },
  { key = "r", icon = "󰋚 ", desc = "Recent Files", cmd = "Telescope oldfiles" },
  { key = "e", icon = "󰈔 ", desc = "New File", cmd = "enew" },
  { key = "m", icon = "󰌌 ", desc = "Keybinds Manual", cmd = "Manual" },
  { key = "l", icon = "󰒲 ", desc = "Lazy Plugins", cmd = "Lazy" },
  { key = "q", icon = "󰅚 ", desc = "Quit Neovim", cmd = "qa" },
}

local function render_meteor(sim, grid_char, grid_hl)
  local met = sim.meteor
  if not met then return end
  local cols, rows, cw, ch = sim.cols, sim.rows, sim.cw, sim.ch
  local pal = met.preset.palette

  local hl_core_hot = "MeteorCoreHot_" .. pal
  local hl_crust_bright = "MeteorCrustBright_" .. pal
  local hl_crust_mid = "MeteorCrustMid_" .. pal
  local hl_rock_dark = "MeteorRockDark_" .. pal
  local hl_shock = "MeteorShock_" .. pal
  local hl_trail_hot = "MeteorTrailHot_" .. pal
  local hl_trail_fire = "MeteorTrailFire_" .. pal
  local hl_trail_ember = "MeteorTrailEmber_" .. pal
  local hl_smoke = "MeteorSmoke_" .. pal
  local hl_ion = "MeteorIon_" .. pal
  local hl_ion_dim = "MeteorIonDim_" .. pal

  local function put(c, r, glyph, hl)
    if c >= 0 and c < cols and r >= 0 and r < rows then
      local idx = r * cols + c
      grid_char[idx] = glyph
      grid_hl[idx] = hl
    end
  end

  -- 1. Deep-Space Twinkling Starfield
  for _, st in ipairs(met.stars) do
    local tw = math.sin(sim.time * st.speed + st.phase)
    if tw > -0.45 then
      local c = math.floor(st.u * cols)
      local r = math.floor(st.v * rows)
      local hl = (st.bright and tw > 0.45) and "MeteorStarBright" or (tw > 0.15 and "MeteorStarMid" or "MeteorStarDim")
      put(c, r, st.glyph, hl)
    end
  end

  -- Sort meteors back-to-front by radius so large foreground bolides draw over background streaks
  local order = {}
  for i = 1, #met.meteors do
    order[i] = met.meteors[i]
  end
  table.sort(order, function(a, b) return a.radius < b.radius end)

  -- 2. Render Multi-Stage Ion, Plasma, Fire, and Atmospheric Smoke Trails
  for _, m in ipairs(order) do
    local hist = m.history
    local n_hist = #hist
    local spd = math.max(1, math.sqrt(m.vx * m.vx + m.vy * m.vy))
    local ux, uy = m.vx / spd, m.vy / spd
    -- Perpendicular vector for wide turbulent bolide wakes
    local px, py = -uy, ux
    local diag_glyph = (ux * uy >= 0) and "\\" or "/"

    if m.kind == "streak" then
      -- Upper-atmosphere shooting star: razor-sharp diagonal ionized streak + glowing head
      for h = n_hist - 1, 1, -1 do
        local p1 = hist[h]
        local p2 = hist[h + 1]
        local frac = h / math.max(1, n_hist - 1)
        local sub = 3
        for s = 0, sub - 1 do
          local t = s / sub
          local sx = p1.x + (p2.x - p1.x) * t
          local sy = p1.y + (p2.y - p1.y) * t
          local g = frac < 0.35 and diag_glyph or (frac < 0.70 and ":" or "·")
          local hl = frac < 0.45 and hl_ion or hl_ion_dim
          put(math.floor(sx / cw), math.floor(sy / ch), g, hl)
        end
      end
      local hc = math.floor(m.x / cw)
      local hr = math.floor(m.y / ch)
      put(hc, hr, "✦", hl_core_hot)
    else
      -- Fireball or Bolide: wide multi-stage plasma/fire/ember/smoke wake
      local is_bolide = (m.kind == "bolide")
      local base_w = is_bolide and (m.radius * 0.72) or (m.radius * 0.58)

      for h = n_hist - 1, 1, -1 do
        local p1 = hist[h]
        local p2 = hist[h + 1]
        local frac = (h - 1) / math.max(1, n_hist - 1)
        local sub = 3
        for s = sub - 1, 0, -1 do
          local t = s / sub
          local f = clamp(frac + (t / math.max(1, n_hist - 1)), 0, 1)
          local cx = p1.x + (p2.x - p1.x) * t
          local cy = p1.y + (p2.y - p1.y) * t
          -- Turbulent billowing width that narrows near the head, swells in mid-wake, and tapers in smoke
          local taper = (1.0 - f * 0.65)
          local half_w = base_w * taper
          local w_steps = math.max(1, math.floor(half_w / 3.2))

          for wi = -w_steps, w_steps do
            local w_frac = math.abs(wi) / math.max(1, w_steps)
            local turb = math.sin(h * 1.4 + wi * 2.1 - sim.time * 9.0) * (3.5 * f)
            local wx = cx + px * (wi * 3.2 + turb)
            local wy = cy + py * (wi * 3.2 + turb)
            local heat = (1.0 - f) * (1.0 - w_frac * 0.55)

            local glyph, hl
            if heat > 0.74 then
              glyph = heat > 0.86 and "#" or "*"
              hl = hl_trail_hot
            elseif heat > 0.48 then
              glyph = heat > 0.60 and "*" or "•"
              hl = hl_trail_fire
            elseif heat > 0.24 then
              glyph = heat > 0.35 and "•" or ":"
              hl = hl_trail_ember
            else
              glyph = (h + wi) % 2 == 0 and ":" or "·"
              hl = hl_smoke
            end
            put(math.floor(wx / cw), math.floor(wy / ch), glyph, hl)
          end
        end
      end
    end
  end

  -- 3. Drifting Ablation Sparks & Mid-Air Bolide Fragmentation Airbursts
  for _, sp in ipairs(met.sparks) do
    local c = math.floor(sp.x / cw)
    local r = math.floor(sp.y / ch)
    local glyph = sp.life > 0.65 and "*" or (sp.life > 0.35 and "•" or "·")
    local hl = sp.life > 0.70 and hl_trail_hot or (sp.life > 0.38 and hl_trail_fire or hl_trail_ember)
    put(c, r, glyph, hl)
  end

  for _, b in ipairs(met.bursts) do
    local ring_pts = 28
    local b_hl = b.alpha > 0.55 and hl_shock or (b.alpha > 0.30 and hl_trail_fire or hl_trail_ember)
    local b_glyph = b.alpha > 0.60 and "*" or (b.alpha > 0.30 and ":" or "·")
    for k = 0, ring_pts - 1 do
      local a = (k / ring_pts) * TAU
      local rx = b.x + math.cos(a) * b.r
      local ry = b.y + math.sin(a) * b.r * 0.88
      put(math.floor(rx / cw), math.floor(ry / ch), b_glyph, b_hl)
    end
  end

  -- 4. Multi-Cell Tumbling Craggy Meteorite & Bolide Heads + Atmospheric Bow-Shock
  for _, m in ipairs(order) do
    if m.kind ~= "streak" then
      local rad = m.radius
      local reach = rad * 1.55 + 8
      local c0 = math.max(0, math.floor((m.x - reach) / cw))
      local c1 = math.min(cols - 1, math.floor((m.x + reach) / cw))
      local r0 = math.max(0, math.floor((m.y - reach) / ch))
      local r1 = math.min(rows - 1, math.floor((m.y + reach) / ch))

      local spd = math.max(1, math.sqrt(m.vx * m.vx + m.vy * m.vy))
      local ux, uy = m.vx / spd, m.vy / spd

      for r = r0, r1 do
        for c = c0, c1 do
          local px = (c + 0.5) * cw
          local py = (r + 0.5) * ch
          local dx = px - m.x
          local dy = (py - m.y) * 0.96
          local d = math.sqrt(dx * dx + dy * dy)

          -- Irregular craggy asteroid silhouette rotating by m.rot
          local ang = math.atan2(dy, dx)
          local local_ang = ang - m.rot
          local crag = 1.0
            + 0.16 * math.sin(local_ang * 3 + m.seed)
            + 0.12 * math.cos(local_ang * 5 - m.seed * 1.7)
            + 0.07 * math.sin(local_ang * 7 + m.seed * 0.6)
          local eff_r = rad * crag
          local r_norm = d / math.max(1, eff_r)

          -- Windward directional alignment (dot product with velocity vector)
          local wind_dot = (dx * ux + dy * uy) / math.max(1, d)

          if r_norm <= 1.0 then
            -- Inside the tumbling craggy meteorite body:
            -- Windward leading edge & inner core are superheated; leeward backside shows dark chondrite crust
            local crater = math.sin((dx * math.cos(m.rot) - dy * math.sin(m.rot)) * 0.28 + m.seed)
              * math.cos((dx * math.sin(m.rot) + dy * math.cos(m.rot)) * 0.28 - m.seed)
            local ram_heat = (1.0 - r_norm * 0.55) + wind_dot * 0.48 + crater * 0.18

            if ram_heat > 0.88 or (wind_dot > 0.45 and r_norm > 0.62) then
              put(c, r, ram_heat > 1.05 and "@" or "#", hl_core_hot)
            elseif ram_heat > 0.54 then
              put(c, r, ram_heat > 0.70 and "#" or "8", hl_crust_bright)
            elseif ram_heat > 0.22 then
              put(c, r, crater > 0.1 and "%" or "*", hl_crust_mid)
            else
              put(c, r, crater > 0 and "=" or ":", hl_rock_dark)
            end
          elseif r_norm <= 1.38 and wind_dot > 0.38 then
            -- Glowing parabolic Atmospheric Ram-Pressure Bow-Shock ahead of the meteorite
            local shock_glyph = wind_dot > 0.72 and ((ux * uy >= 0) and "/" or "\\") or ":"
            put(c, r, shock_glyph, hl_shock)
          end
        end
      end
    end
  end
end

local function render_frame(buf, sim)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  local cols, rows = sim.cols, sim.rows
  local grid_char = {}
  local grid_hl = {}

  render_meteor(sim, grid_char, grid_hl)

  -- Build lines & highlight spans
  local lines = {}
  local row_spans = {}
  local center_r = math.floor(rows / 2)
  local box_w = 36
  local box_left = math.max(0, math.floor((cols - box_w) / 2))

  for r = 0, rows - 1 do
    local chars = {}
    local spans = {}
    local run_hl = nil
    local run_start_byte = 0
    local byte_pos = 0

    for c = 0, cols - 1 do
      local idx = r * cols + c
      local ch_str = grid_char[idx] or " "
      local hl = grid_hl[idx]

      chars[c + 1] = ch_str
      local ch_len = #ch_str
      if hl ~= run_hl then
        if run_hl then
          table.insert(spans, { run_hl, run_start_byte, byte_pos })
        end
        run_hl = hl
        run_start_byte = byte_pos
      end
      byte_pos = byte_pos + ch_len
    end
    if run_hl then
      table.insert(spans, { run_hl, run_start_byte, byte_pos })
    end

    lines[r + 1] = table.concat(chars)
    row_spans[r + 1] = spans
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for r = 1, rows do
    for _, sp in ipairs(row_spans[r]) do
      pcall(vim.api.nvim_buf_add_highlight, buf, ns, sp[1], r - 1, sp[2], sp[3])
    end
  end

  -- Overlay the dashboard week_header (ASCII day of the week + live date/time) & shortcut box
  local day_name = DAYS_OF_WEEK[os.date("*t").wday] or "Monday"
  local header_lines = WEEK_HEADERS[day_name]
  local total_ui_height = #header_lines + 2 + #MENU_ITEMS + 4
  local start_row = math.max(0, center_r - math.floor(total_ui_height / 2))

  if cols > box_w + 4 and rows >= total_ui_height - 3 then
    local cur_row = start_row

    -- 1. ASCII Day-of-the-Week Banner
    for _, hline in ipairs(header_lines) do
      local hwidth = vim.fn.strdisplaywidth(hline)
      local hcol = math.max(0, math.floor((cols - hwidth) / 2))
      if cur_row < rows then
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, cur_row, 0, {
          virt_text = { { hline, "MeteorHeader" } },
          virt_text_win_col = hcol,
          priority = 200,
        })
      end
      cur_row = cur_row + 1
    end

    -- 2. Live Date & Time line (just like dashboard-nvim week_header)
    local date_str = "  " .. os.date("%Y-%m-%d    %H:%M:%S")
    local date_col = math.max(0, math.floor((cols - vim.fn.strdisplaywidth(date_str)) / 2))
    if cur_row < rows then
      pcall(vim.api.nvim_buf_set_extmark, buf, ns, cur_row, 0, {
        virt_text = { { date_str, "MeteorDate" } },
        virt_text_win_col = date_col,
        priority = 200,
      })
    end
    cur_row = cur_row + 2

    -- 3. Shortcuts Card
    local inner_w = 30
    local hbar = string.rep("─", inner_w)
    local overlay_rows = {
      { { "  ┌" .. hbar .. "┐  ", "MeteorBoxBorder" } },
    }
    for _, item in ipairs(MENU_ITEMS) do
      local key_str = "[" .. item.key .. "]"
      local icon_str = "  " .. item.icon
      local used = 2 + vim.fn.strdisplaywidth(key_str) + vim.fn.strdisplaywidth(icon_str) + vim.fn.strdisplaywidth(item.desc) + 1
      local pad = string.rep(" ", math.max(0, inner_w - used))
      table.insert(overlay_rows, {
        { "  │  ", "MeteorBoxBorder" },
        { key_str, "MeteorKey" },
        { icon_str, "MeteorSubtitle" },
        { item.desc .. pad, "MeteorDesc" },
        { " │  ", "MeteorBoxBorder" },
      })
    end
    table.insert(overlay_rows, { { "  └" .. hbar .. "┘  ", "MeteorBoxBorder" } })

    for _, chunks in ipairs(overlay_rows) do
      if cur_row < rows then
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, cur_row, 0, {
          virt_text = chunks,
          virt_text_win_col = box_left,
          priority = 200,
        })
      end
      cur_row = cur_row + 1
    end

    -- 4. Footer
    cur_row = cur_row + 1
    local vname = (sim.meteor and sim.meteor.preset and sim.meteor.preset.name) or "Perseid Fireball Storm"
    local scene_label = "☄️ Meteorite Shower (" .. vname .. ")"
    local footer_str = "⚡ Happy coding with Neovim  •  " .. scene_label
    local footer_col = math.max(0, math.floor((cols - vim.fn.strdisplaywidth(footer_str)) / 2))
    if cur_row < rows then
      pcall(vim.api.nvim_buf_set_extmark, buf, ns, cur_row, 0, {
        virt_text = { { footer_str, "MeteorFooter" } },
        virt_text_win_col = footer_col,
        priority = 200,
      })
    end
  end

  -- Flush redraw immediately even when typing in Command mode (:)
  if vim.fn.mode():match("^[cr]") and vim.api.nvim__redraw then
    pcall(vim.api.nvim__redraw, { buf = buf, valid = true })
  end
end

function M.start()
  setup_highlights()

  local prev_buf = vim.api.nvim_get_current_buf()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype = "alpha"

  vim.api.nvim_set_current_buf(buf)

  -- Delete the initial empty [No Name] buffer so it doesn't linger as a tab
  if
    prev_buf ~= buf
    and vim.api.nvim_buf_is_valid(prev_buf)
    and vim.api.nvim_buf_get_name(prev_buf) == ""
    and not vim.bo[prev_buf].modified
    and vim.bo[prev_buf].buftype == ""
    and vim.api.nvim_buf_line_count(prev_buf) <= 1
    and (vim.api.nvim_buf_get_lines(prev_buf, 0, 1, false)[1] or "") == ""
  then
    pcall(vim.api.nvim_buf_delete, prev_buf, { force = true })
  end

  local win = vim.api.nvim_get_current_win()
  local saved_wo = {
    number = vim.wo[win].number,
    relativenumber = vim.wo[win].relativenumber,
    cursorline = vim.wo[win].cursorline,
    signcolumn = vim.wo[win].signcolumn,
    wrap = vim.wo[win].wrap,
    winhl = vim.wo[win].winhl,
  }

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].cursorline = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = false
  vim.wo[win].winhl = "Normal:MeteorBg,EndOfBuffer:MeteorBg"

  local preset_idx = 1
  local cols = math.max(40, vim.api.nvim_win_get_width(win))
  local rows = math.max(15, vim.api.nvim_win_get_height(win))
  local sim = create_sim(cols, rows, preset_idx)

  local uv = vim.uv or vim.loop
  local timer = uv.new_timer()
  local restored = false

  local function restore_win()
    if restored then
      return
    end
    restored = true
    if vim.api.nvim_win_is_valid(win) then
      vim.wo[win].number = saved_wo.number
      vim.wo[win].relativenumber = saved_wo.relativenumber
      vim.wo[win].cursorline = saved_wo.cursorline
      vim.wo[win].signcolumn = saved_wo.signcolumn
      vim.wo[win].wrap = saved_wo.wrap
      vim.wo[win].winhl = saved_wo.winhl
    end
  end

  local function stop_timer()
    if timer then
      timer:stop()
      if not timer:is_closing() then
        timer:close()
      end
      timer = nil
    end
    restore_win()
  end

  -- Map dashboard shortcut keys (keep animating while floating pickers like Telescope/Lazy are open)
  for _, item in ipairs(MENU_ITEMS) do
    vim.keymap.set("n", item.key, function()
      if item.cmd == "enew" or item.cmd == "qa" then
        stop_timer()
      end
      vim.cmd(item.cmd)
    end, { buffer = buf, nowait = true, silent = true, desc = item.desc })
  end

  -- Only stop when the startup buffer itself is wiped/hidden (not when moving focus to Neo-tree or floats)
  vim.api.nvim_create_autocmd({ "BufWipeout", "BufHidden", "BufDelete", "BufWinLeave" }, {
    buffer = buf,
    once = true,
    callback = stop_timer,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    buffer = buf,
    callback = function()
      setup_highlights()
    end,
  })

  render_frame(buf, sim)

  timer:start(0, 45, vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(buf) then
      stop_timer()
      return
    end
    local wins = vim.fn.win_findbuf(buf)
    if #wins == 0 then
      stop_timer()
      return
    end
    local cur_win = wins[1]
    local new_cols = math.max(40, vim.api.nvim_win_get_width(cur_win))
    local new_rows = math.max(15, vim.api.nvim_win_get_height(cur_win))
    if new_cols ~= sim.cols or new_rows ~= sim.rows then
      sim.cols = new_cols
      sim.rows = new_rows
      sim.W = new_cols * sim.cw
      sim.H = new_rows * sim.ch
    end
    step_sim(sim, 0.045)
    render_frame(buf, sim)
  end))
end

return M
