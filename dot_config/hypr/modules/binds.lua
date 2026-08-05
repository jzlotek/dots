local MAINMOD = "SUPER"
local TERMINAL = "ghostty"
local FILEMANAGER = "dolphin"
local MENU = "wofi --show drun"
local LOCK = "hyprlock"

-- Basic binds
hl.bind(MAINMOD .. " + Return", hl.dsp.exec_cmd(TERMINAL))
hl.bind(MAINMOD .. " + Q", hl.dsp.window.close())
hl.bind(MAINMOD .. " + Backspace", hl.dsp.submap("logout"))
hl.bind(MAINMOD .. " + E", hl.dsp.exec_cmd(FILEMANAGER))
hl.bind(MAINMOD .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MAINMOD .. " + D", hl.dsp.exec_cmd(MENU))
hl.bind(MAINMOD .. " + P", hl.dsp.window.pseudo())
hl.bind(MAINMOD .. " + L", hl.dsp.exec_cmd(LOCK))

-- Move focus with mainMod + arrow keys
hl.bind(MAINMOD .. " + H", hl.dsp.focus({direction = "left"}))
hl.bind(MAINMOD .. " + J", hl.dsp.focus({direction = "down"}))
hl.bind(MAINMOD .. " + K", hl.dsp.focus({direction = "up"}))
hl.bind(MAINMOD .. " + L", hl.dsp.focus({direction = "right"}))

-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
	local key = i % 10
	hl.bind(MAINMOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(MAINMOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
--hl.bind(MAINMOD .. " + S, togglespecialworkspace, magic
--bind = $mainMod SHIFT, S, movetoworkspace, special:magic

-- Scroll through existing workspaces with mainMod + scroll
--hl.bind(MAINMOD .. " + mouse_down, workspace, e+1
--hl.bind(MAINMOD .. " + mouse_up, workspace, e-1

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(MAINMOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MAINMOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))


hl.on("keybinds.submap", function(name)
	if name == "logout" then
		hl.notification.create({
			text = "c - reload\ne - exit\nr - reboot\ns - suspend\nS - poweroff\nl - lock",
			duration = 4500,
			color = "rgb(34E2E2)",
			font_size = 18,
		})
	end
end)

hl.define_submap("logout", function()
	hl.bind("C", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
	end)
	hl.bind("E", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exit())
	end)
	hl.bind("S", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("~/.local/bin/suspend"))
	end)
	hl.bind("R", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("systemctl reboot"))
	end)
	hl.bind("SHIFT + S", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("systemctl poweroff -i"))
	end)
	hl.bind("L", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd(LOCK))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("escape", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
	hl.bind("Return", function()
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.submap("reset"))
	end)
end)
