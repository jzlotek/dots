hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:alt_shift_toggle,caps:backspace",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			tap_button_map = "lmr",
		},
	},

	general = {
		gaps_in = 5,
		gaps_out = 20,
		border_size = 2,
		resize_on_border = true,
		col = {
			active_border = {
				colors = {
					"rgba(33ccffee)",
					"rgba(00ff99ee)"
				},
				angle = 45
			},
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		blur = {
			enabled = true,
			passes = 1,
			new_optimizations = true,
		},
		shadow = {
			enabled = true,
		},
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		force_split = 1,
		preserve_split = true,
	},

	misc = {
		force_default_wallpaper = false,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_autoreload = true,
		enable_swallow = true,
	},

	ecosystem = {
		no_update_news = true,
	},

	debug = {
		disable_logs = false,
	},
})

hl.gesture(
	{
		fingers = 3,
		direction = "horizontal",
		action = "workspace"
	}
)
