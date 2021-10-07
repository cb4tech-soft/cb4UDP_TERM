import QtQuick 2.0
import SerialInfo 1.0
import QtQuick.Controls 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.11

import "../Style"
import SerialManager 1.0


AppRectangle {
    id: serialConfig
    width: 200
    height: 400
    clip: true
    signal connectClicked;
    property int baudrate: baudRateList.currentValue
    onBaudrateChanged: {
        if (serialConfig.manager.isConnected)
            serialConfig.manager.baudrate = serialConfig.baudrate
    }

    property string port: comList.port.currentText
    property SerialManager manager

        AppLabel {
            id: label
            text: "Serial port Settings"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            height:80
        }
        SerialManagerDeviceList{
            id:comList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: label.bottom
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 5
            height: 40
        }
        AppLabel {
            id: label2
            text: "Baudrate"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: comList.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 5
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            height:40
        }
        AppComboBox{
            id:baudRateList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: label2.bottom
            anchors.topMargin: 5
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            currentIndex: 1
            model: [9600, 19200, 38400, 57600, 76800, 115200]
            height: 40
        }
        AppButton{
            id:connectButton
            text: "Connection"
            anchors.top: baudRateList.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (serialConfig.manager)
                {
                    serialConfig.manager.baudrate = serialConfig.baudrate
                    serialConfig.manager.connectToPort(serialConfig.port)
                }
                else
                {
                    connectClicked()
                }
            }
        }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
