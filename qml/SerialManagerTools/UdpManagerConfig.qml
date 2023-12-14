import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.11

import "../Style"
import UdpManager 1.0
import Qt.labs.settings


AppRectangle {
    id: serialConfig
    width: 250
    height: 400
    color: "#ffffff"
    border.color: "#ffffff"
    clip: true
    signal connectClicked;
    property string listenIp: textFieldListenIp.text
    property string targetIp: textFieldTargetIp.text
    property int listenPort: textFieldlistenPort.value
    property int targetPort: textFieldTargetPort.value
    Settings {
        //property alias comListIndex: comList.port.currentIndex
        property alias textFieldListenIpText: textFieldListenIp.text
        property alias textFieldTargetIpText: textFieldTargetIp.text
        property alias textFieldListenPortValue: textFieldlistenPort.value
        property alias textFieldTargetPortValue: textFieldTargetPort.value
    }

    onListenIpChanged: {

    }
    onTargetIpChanged: {

        serialConfig.manager.targetIp = serialConfig.targetIp
    }

    onTargetPortChanged: {
        serialConfig.manager.targetPort = serialConfig.targetPort
    }


    property UdpManager manager

    AppLabel {
        id: labelTitle
        text: "UDP Settings"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        height:44
    }

    AppToolSeparator{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: labelTitle.bottom
        anchors.rightMargin: 25
        anchors.leftMargin: 25
        height: 11
    }
    AppLabel {
        id: label2
        text: "Listen IP"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: labelTitle.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 5
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        height:40
    }

    TextField {
        id: textFieldListenIp
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label2.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 6
        anchors.leftMargin: 10
        placeholderText: qsTr("any")
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    SpinBox {
        id: textFieldlistenPort
        value: 4242
        from: 0
        to : 65535
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: textFieldListenIp.bottom
        editable: true
        anchors.topMargin: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        height:40
    }
    AppToolSeparator{
        id: propFieldSeparator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: textFieldlistenPort.bottom
        anchors.topMargin: 15
        anchors.rightMargin: 25
        anchors.leftMargin: 25
        height: 11
    }

    AppLabel {
        id: label3
        text: "target IP"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: propFieldSeparator.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        height:40
    }

    TextField {
        id: textFieldTargetIp
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label3.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 6
        anchors.leftMargin: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        placeholderText: qsTr("")
    }

    SpinBox {
        id: textFieldTargetPort
        value: 4242
        from: 0
        to : 65535
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: textFieldTargetIp.bottom
        editable: true
        anchors.topMargin: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        height:40
    }

    AppToolSeparator{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: textFieldTargetPort.bottom
        anchors.topMargin: 10
        anchors.rightMargin: 25
        anchors.leftMargin: 25
        height: 11
    }
    AppButton{
        id:connectButton
        text:(!serialConfig.manager.isConnected) ? "Open" : "Close"
        anchors.top: textFieldTargetPort.bottom
        anchors.horizontalCenterOffset: 0
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if (!serialConfig.manager.isConnected)
            {
                serialConfig.manager.listenIp = serialConfig.listenIp
                serialConfig.manager.listenPort = serialConfig.listenPort
                serialConfig.manager.targetIp = serialConfig.targetIp
                serialConfig.manager.targetPort = serialConfig.targetPort
                serialConfig.manager.connectToPort()
                /*
                serialConfig.manager.baudrate = serialConfig.baudrate
                serialConfig.manager.dataBits = serialConfig.dataBits
                serialConfig.manager.flowControl = serialConfig.flowControl
                serialConfig.manager.parity = serialConfig.parity
                serialConfig.manager.stopBits = serialConfig.stopBits
                serialConfig.manager.connectToPort(serialConfig.port)
                */
            }
            else
            {
                serialConfig.manager.disconnectFromPort();
            }
        }
    }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
