pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: theme

	property string font: "consolas"
	property int fontSize: 14

	property string bg: "#1a1b26"
	property string fg: "#a9b1d6"
	property string muted: "#444b6a"

	property string color0: "#AAAAAA"
	property string color1: "#AAAAAA"
	property string color2: "#AAAAAA"
	property string color3: "#AAAAAA"
	property string color4: "#AAAAAA"
	property string color5: "#AAAAAA"
	property string color6: "#AAAAAA"
	property string color7: "#AAAAAA"
	property string color8: "#AAAAAA"
	property string color9: "#AAAAAA"
	property string color10: "#AAAAAA"
	property string color11: "#AAAAAA"
	property string color12: "#AAAAAA"
	property string color13: "#AAAAAA"
	property string color14: "#AAAAAA"
	property string color15: "#AAAAAA"

	function apply(raw) {
		let json
		try {
			json = JSON.parse(raw || "{}")
		} catch (e) {
			return
		}

		theme.font = json.font || "consolas"
		theme.fontSize = json.fontSize || 14

		theme.bg = json.bg || "#1a1b26"
		theme.fg = json.fg || "#a9b1d6"
		theme.muted = json.muted || "#444b6a"

		for (let i = 0; i <= 15; i++)
			theme["color" + i] = json["color" + i] || "#AAAAAA"
	}

	Component.onCompleted: file.reload()

	// watchChanges signals but does not re-read; reload() ourselves, debounced.
	Timer {
		id: reloadDebounce
		interval: 150
		onTriggered: file.reload()
	}

	property FileView file: FileView {
		id: file
		path: `${Quickshell.env('HOME')}/.local/state/theme/colors.json`
		blockLoading: true
		watchChanges: true

		onFileChanged: reloadDebounce.restart()
		onLoaded: theme.apply(file.data())
		onLoadFailed: reloadDebounce.restart()
	}
}
