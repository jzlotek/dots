import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts


PanelWindow {
	id: root

	// System data
	property int cpuUsage: 0
	property int memUsage: 0
	property var lastCpuIdle: 0
	property var lastCpuTotal: 0
	property string currentSong: ""
	property bool runBatteryTimer: UPower.devices.values.find(d => d.isLaptopBattery && d.isPresent) || false
	property string batteryStatus: ""

	property string localBin: `${Quickshell.env('HOME')}/.local/bin`

	anchors.top: true
	anchors.left: true
	anchors.right: true
	implicitHeight: 30
	color: Theme.bg

	// Processes and timers here...
	Process {
		id: cpuProc
		command: ["sh", "-c", "head -1 /proc/stat"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var p = data.trim().split(/\s+/)
				var idle = parseInt(p[4]) + parseInt(p[5])
				var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
				if (lastCpuTotal > 0) {
					cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
				}
				lastCpuTotal = total
				lastCpuIdle = idle
			}
		}
		Component.onCompleted: running = true
	}
	Process {
		id: memProc
		command: ["sh", "-c", "free | grep Mem"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var parts = data.trim().split(/\s+/)
				var total = parseInt(parts[1]) || 1
				var used = parseInt(parts[2]) || 0
				memUsage = Math.round(100 * used / total)
			}
		}
		Component.onCompleted: running = true
	}
	Process {
		id: playerProc
		command: [`${localBin}/mediaplayer`]
		stdout: SplitParser {
			onRead: data => {
				if (!data) {
					currentSong = ""
					return
				}
				let parsed = JSON.parse(data)

				let map = new Map([
					["default", ""],
					["firefox", ""],
					["chrome", ""],
					["cliamp", ""],
					["spotify", ""],
				])
				currentSong = `${map.get(parsed.alt) + ' - ' || ''}${parsed.text}`.replace("[paused]", "")
			}
		}
		Component.onCompleted: running = true
	}
	Process {
		id: batteryProc
		command: ["sh", "-c", "for battery in /sys/class/power_supply/BAT*; do echo $(basename $battery); cat $battery/capacity $battery/status; done"]
		stdout: StdioCollector {
			onStreamFinished: {
				if (!this.text) {
					return
				}
				let data = this.text.trim().split("\n")
				if (data.length < 3) {
					runBatteryTimer = false
					return
				}
				let status = ""
				let percent = parseInt(data[1])
				if (data[2] == "Charging") {
					status = ""
				} else if (data[2] == "Not charging") {
					status = ""
				} else if (data[2] == "Full") {
					status = ""
				} else if (percent <= 10) {
					status = ""
				} else if (percent <= 25) {
					status = ""
				} else if (percent <= 50) {
					status = ""
				} else if (percent <= 75) {
					status = ""
				} else {
					status = ""
				}

				batteryStatus = `${status} ${percent}%`
			}
		}
	}

	Timer {
		interval: 10000
		running: true
		repeat: runBatteryTimer
		onTriggered: {
			batteryProc.running = true
		}
	}

	Timer {
		interval: 2000
		running: true
		repeat: true
		onTriggered: {
			cpuProc.running = true
			memProc.running = true
			playerProc.running = true
		}
	}
	RowLayout {
		anchors.fill: parent
		anchors.margins: 8
		spacing: 8

		// Workspaces
		Repeater {
			model: 9
			Text {
				property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
				property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
				text: index + 1
				color: isActive ? Theme.fg : (ws ? Theme.color6 : Theme.muted)
				font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
				MouseArea {
					anchors.fill: parent
					onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace=${index + 1}})`)
				}
			}
		}

		Item { Layout.fillWidth: true }

		// player
		Item {
			Layout.fillWidth: true
			height: currentSongText.implicitHeight
			Text {
				anchors.fill: parent
				id: currentSongText
				horizontalAlignment: Text.AlignRight
				wrapMode: Text.WordWrap
				width: Math.min(parent.width - 20, 50)
				text: currentSong
				color: Theme.color7
				font { family: Theme.font; pixelSize: Theme.fontSize; bold: false }
			}
		}

		Rectangle { width: 1; height: 16; color: Theme.muted }

		// Weather
		Weather {}

		Rectangle { width: 1; height: 16; color: Theme.muted }

		// CPU
		Text {
			text: "CPU: " + cpuUsage + "%"
			color: Theme.color1
			font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
		}

		Rectangle { width: 1; height: 16; color: Theme.muted }

		// Memory
		Text {
			text: "Mem: " + memUsage + "%"
			color: Theme.color5
			font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
		}


		Rectangle { visible: batteryStatus; width: 1; height: 16; color: Theme.muted }

		// Battery
		Text {
			visible: batteryStatus
			id: batteryItem
			text: batteryStatus
			color: Theme.color2
			font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
		}

		Rectangle { width: 1; height: 16; color: Theme.muted }

		// Network
		Network {}

		Rectangle { width: 1; height: 16; color: Theme.muted }

		// Audio
		Audio {}

		Rectangle { width: 1; height: 16; color: Theme.muted }

		// Clock
		Text {
			id: clock
			color: Theme.color6
			font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
			text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
			Timer {
				interval: 1000
				running: true
				repeat: true
				onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
			}
		}
	}
}
