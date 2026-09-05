import QtQuick
import Quickshell
import Quickshell.Io

Dropdown {
	id: net

	property string connName: ""
	property string device: ""
	property string type: ""
	property string ip: ""
	property string ssid: ""
	property int signal: 0
	property string security: ""
	property string rate: ""

	property real rxRate: 0
	property real txRate: 0
	property var _lastRx: 0
	property var _lastTx: 0
	property var _lastT: 0
	property string _lastDev: ""

	readonly property bool wired: type === "802-3-ethernet"
	readonly property bool wireless: type === "802-11-wireless"
	readonly property bool online: connName !== ""

	function wifiIcon(sig) {
		if (sig >= 75) return String.fromCodePoint(0xF0928)
		if (sig >= 50) return String.fromCodePoint(0xF0925)
		if (sig >= 25) return String.fromCodePoint(0xF0922)
		if (sig > 0)   return String.fromCodePoint(0xF091F)
		return String.fromCodePoint(0xF092F)
	}

	function fmtRate(bps) {
		if (bps < 1024)             return `${bps.toFixed(0)} B/s`
		if (bps < 1024 * 1024)      return `${(bps / 1024).toFixed(1)} KB/s`
		return `${(bps / 1024 / 1024).toFixed(2)} MB/s`
	}

	Process {
		id: proc
		command: ["sh", "-c", `
			row=$(nmcli -t -f NAME,DEVICE,TYPE connection show --active | grep -v ':lo:' | head -1)
			name=$(printf '%s' "$row" | cut -d: -f1)
			dev=$(printf '%s' "$row" | cut -d: -f2)
			type=$(printf '%s' "$row" | cut -d: -f3)
			ip=$(nmcli -t -f IP4.ADDRESS device show "$dev" 2>/dev/null | head -1 | cut -d: -f2)
			ssid=""; sig="0"; sec=""; rate=""
			if [ "$type" = "802-11-wireless" ]; then
				w=$(nmcli -t -f ACTIVE,SSID,SIGNAL,SECURITY,RATE device wifi | grep '^yes:' | head -1)
				ssid=$(printf '%s' "$w" | cut -d: -f2)
				sig=$(printf '%s' "$w" | cut -d: -f3)
				sec=$(printf '%s' "$w" | cut -d: -f4)
				rate=$(printf '%s' "$w" | cut -d: -f5)
			fi
			rx=$(cat /sys/class/net/"$dev"/statistics/rx_bytes 2>/dev/null || echo 0)
			tx=$(cat /sys/class/net/"$dev"/statistics/tx_bytes 2>/dev/null || echo 0)
			printf '{"name":"%s","dev":"%s","type":"%s","ip":"%s","ssid":"%s","signal":%s,"security":"%s","rate":"%s","rx":%s,"tx":%s}' \
				"$name" "$dev" "$type" "$ip" "$ssid" "\${sig:-0}" "$sec" "$rate" "\${rx:-0}" "\${tx:-0}"
		`]
		stdout: StdioCollector {
			onStreamFinished: {
				try {
					let d = JSON.parse(this.text)
					net.connName = d.name
					net.device = d.dev
					net.type = d.type
					net.ip = d.ip
					net.ssid = d.ssid
					net.signal = d.signal || 0
					net.security = d.security
					net.rate = d.rate

					let now = Date.now()
					let dt = (now - net._lastT) / 1000
					if (net._lastT > 0 && dt > 0 && d.dev === net._lastDev) {
						net.rxRate = Math.max(0, (d.rx - net._lastRx) / dt)
						net.txRate = Math.max(0, (d.tx - net._lastTx) / dt)
					} else {
						net.rxRate = 0
						net.txRate = 0
					}
					net._lastRx = d.rx
					net._lastTx = d.tx
					net._lastT = now
					net._lastDev = d.dev
				} catch (e) {}
			}
		}
		Component.onCompleted: running = true
	}

	Timer {
		interval: 10000
		running: true
		repeat: true
		onTriggered: proc.running = true
	}

	Text {
		text: {
			if (net.wired) return `${String.fromCodePoint(0xF0318)} ${net.device}`
			if (net.wireless) return `${net.wifiIcon(net.signal)} ${net.device}`
			return String.fromCodePoint(0xF092F)
		}
		color: net.online ? Theme.color3 : Theme.muted
		font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
	}

	popup: Component {
		Column {
			spacing: 4

			Text {
				text: net.online
					? (net.wireless && net.ssid ? net.ssid : net.connName)
					: "Disconnected"
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
			}
			Text {
				visible: net.wireless
				text: `Signal: ${net.wifiIcon(net.signal)} ${net.signal}%`
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
			Text {
				visible: net.wireless && net.security !== ""
				text: `Security: ${net.security}`
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
			Text {
				visible: net.rate !== ""
				text: `Link rate: ${net.rate}`
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
			Text {
				text: `${String.fromCodePoint(0xF0045)} ${net.fmtRate(net.rxRate)}   ${String.fromCodePoint(0xF005D)} ${net.fmtRate(net.txRate)}`
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
			Text {
				visible: net.device !== ""
				text: `Interface: ${net.device}`
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
			Text {
				text: `IP: ${net.ip !== "" ? net.ip : "—"}`
				color: Theme.fg
				font { family: Theme.font; pixelSize: Theme.fontSize }
			}
		}
	}
}
