-- Normal alternating workspaces.
for i = 1, 8 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = (i % 2 == 1) and "DP-3" or "HDMI-A-1",
  })
end

-- Built-in fallback locations. Persistent ensures these workspaces exist
-- when the external monitor is connected.
hl.workspace_rule({
  workspace = "9",
  monitor = "DP-3",
  persistent = true,
})

hl.workspace_rule({
  workspace = "10",
  monitor = "HDMI-A-1",
  persistent = true,
})

local builtin_monitors = {
  ["DP-3"] = true,
  ["HDMI-A-1"] = true,
}

local external_monitor = nil

local function attach_reserved_workspaces(monitor)
  if monitor == nil or builtin_monitors[monitor.name] then
    return
  end

  external_monitor = monitor.name

  hl.dispatch(hl.dsp.workspace.move({
    workspace = "9",
    monitor = monitor.name,
  }))

  hl.dispatch(hl.dsp.workspace.move({
    workspace = "10",
    monitor = monitor.name,
  }))
end

local function find_external_monitor()
  for _, monitor in ipairs(hl.get_monitors()) do
    if not builtin_monitors[monitor.name] then
      attach_reserved_workspaces(monitor)
      return
    end
  end
end

hl.on("monitor.added", attach_reserved_workspaces)

hl.on("monitor.removed", function(monitor)
  if monitor.name ~= external_monitor then
    return
  end

  external_monitor = nil

  hl.dispatch(hl.dsp.workspace.move({
    workspace = "9",
    monitor = "DP-3",
  }))

  hl.dispatch(hl.dsp.workspace.move({
    workspace = "10",
    monitor = "HDMI-A-1",
  }))
end)

-- Handles an external monitor already connected at startup.
hl.on("hyprland.start", find_external_monitor)

-- Handles reloading the config while one is connected.
hl.on("config.reloaded", find_external_monitor)
