import QtQuick
import Quickshell
import Quickshell.Io

Dropdown {
	id: weather

	property string summary: ""
	property string details: ""
	readonly property string localBin: `${Quickshell.env('HOME')}/.local/bin`

	Process {
		id: proc
		command: [`${weather.localBin}/wttr`]
		stdout: StdioCollector {
			onStreamFinished: {
				try {
					let tmp = JSON.parse(this.text)
					weather.summary = tmp.text.trim()
					weather.details = tmp.tooltip
				} catch (e) {}
			}
		}
		Component.onCompleted: running = true
	}

	Timer {
		interval: 3600000
		running: true
		repeat: true
		onTriggered: proc.running = true
	}

	Text {
		text: weather.summary
		color: Theme.color3
		font { family: Theme.font; pixelSize: Theme.fontSize; bold: false }
	}

	popup: Component {
		Text {
			text: weather.details.replace(/\n/g, "<br/>")
			textFormat: Text.StyledText
			lineHeight: 0.75
			color: Theme.fg
			font { family: Theme.font; pixelSize: Theme.fontSize; bold: false }
		}
	}
}
