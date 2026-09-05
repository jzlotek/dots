import QtQuick
import Quickshell

Item {
	id: root

	default property alias barContent: barRow.data
	property Component popup: null
	property real popupPadding: 12
	property int closeDelay: 250
	property bool forceOpen: false

	implicitWidth: barRow.implicitWidth
	implicitHeight: barRow.implicitHeight

	Row {
		id: barRow
		anchors.centerIn: parent
		spacing: 6
	}

	HoverHandler { id: barHover }

	readonly property bool active: barHover.hovered || panelHover.hovered

	property bool _open: false

	onActiveChanged: {
		if (active) {
			closeTimer.stop()
			_open = true
		} else {
			closeTimer.restart()
		}
	}

	Timer {
		id: closeTimer
		interval: root.closeDelay
		onTriggered: root._open = false
	}

	PopupWindow {
		id: win
		visible: root._open || root.forceOpen
		color: "transparent"

		anchor.item: root
		anchor.edges: Edges.Bottom
		anchor.gravity: Edges.Bottom
		anchor.margins.top: 6

		implicitWidth: Math.max(1, frame.implicitWidth)
		implicitHeight: Math.max(1, frame.implicitHeight)

		Rectangle {
			id: frame
			implicitWidth: bodyLoader.implicitWidth + root.popupPadding * 2
			implicitHeight: bodyLoader.implicitHeight + root.popupPadding * 2
			color: Theme.bg
			border.color: Theme.muted
			border.width: 1
			radius: 6

			HoverHandler { id: panelHover }

			Loader {
				id: bodyLoader
				anchors.centerIn: parent
				sourceComponent: root.popup
			}
		}
	}
}
