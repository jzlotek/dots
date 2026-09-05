pragma Singleton


import QtQuick
import Quickshell
import Quickshell.Services.Notifications


Singleton {
	id: root


	NotificationServer {

		onNotification: function(notification) {
			console.log(notification)
		}
	}
}
