import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Dropdown {
	id: audio

	readonly property PwNode sink: Pipewire.defaultAudioSink
	readonly property real vol: (sink && sink.audio) ? sink.audio.volume : 0
	readonly property bool muted: (sink && sink.audio) ? sink.audio.muted : false

	function setVol(v) {
		if (sink && sink.audio)
			sink.audio.volume = Math.max(0, Math.min(1, v))
	}
	function toggleMute() {
		if (sink && sink.audio)
			sink.audio.muted = !sink.audio.muted
	}

	PwObjectTracker { objects: audio.sink ? [audio.sink] : [] }

	Text {
		text: {
			if (audio.muted || audio.vol <= 0) return ""
			if (audio.vol < 0.5) return ""
			return ""
		}
		color: audio.muted ? Theme.muted : Theme.color4
		font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
	}
	Text {
		text: `${Math.round(audio.vol * 100)}%`
		color: audio.muted ? Theme.muted : Theme.color4
		font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
	}

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
		onWheel: e => audio.setVol(audio.vol + (e.angleDelta.y > 0 ? 0.05 : -0.05))
	}
	TapHandler {
		onTapped: audio.toggleMute()
	}

	popup: Component {
		Column {
			spacing: 6

			Text {
				text: audio.sink ? audio.sink.description : "No sink"
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
				width: Math.min(implicitWidth, 260)
				elide: Text.ElideRight
			}
			Row {
				spacing: 8

				Rectangle {
					id: track
					anchors.verticalCenter: parent.verticalCenter
					width: 160
					height: 6
					radius: 3
					color: Theme.muted

					Rectangle {
						width: parent.width * Math.max(0, Math.min(1, audio.vol))
						height: parent.height
						radius: 3
						color: audio.muted ? Theme.muted : Theme.color4
					}
					MouseArea {
						anchors.fill: parent
						anchors.margins: -8
						onPressed: e => audio.setVol(e.x / track.width)
						onPositionChanged: e => audio.setVol(e.x / track.width)
					}
				}
				Text {
					text: `${Math.round(audio.vol * 100)}%`
					color: Theme.fg
					font { family: Theme.font; pixelSize: Theme.fontSize }
				}
			}
			Text {
				text: audio.muted ? "Muted — click to unmute" : "Click to mute · scroll to adjust"
				color: Theme.muted
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
		}
	}
}
