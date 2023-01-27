import QtQuick 2.0
import QtQuick.Controls 2.15
import "./Style/"


import QtQuick.Layouts 1.11
import SerialManager 1.0

import "SerialManagerTools" as SerialTool


AppRectangle {
    id:root
    width:850
    height:400
    property int nbClick: 0
    property bool themeDark: true
    property alias serManager: serManager


    onThemeDarkChanged: {
        AppStyle.darkEnable = themeDark
    }
    SerialManager{
        id: serManager
        baudrate: SerialManager.Baud19200

    }
    SplitView{
        id:splitView
        anchors.fill: parent
        SerialTool.SerialManagerConfig{
            id:serialConfig
            width:200
            SplitView.preferredWidth: 130
            manager: serManager
        }

        AppRectangle {
            id: mainSplit
            height: parent.height
            SplitView.preferredWidth: 550
            AppLabel {
                id: labelConnect
                height: 40
                text: qsTr("===  " + ((serManager.isConnected) ? ("Connected") : "Disconnected") + "  ===")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.topMargin: 0
                anchors.leftMargin: 2
                anchors.rightMargin: 0
            }

            SerialTool.SerialManagerDataViewer{
                id:dataViewer
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: labelConnect.bottom
                anchors.bottom: serialManagerLineSender.top
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                manager : serManager

            }

            SerialTool.SerialManagerLineSender {
                id: serialManagerLineSender
                y: 0
                height: 80
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                manager : serManager
                onSendStringData: dataViewer.sendString(stringData)
                onSendHexaData: dataViewer.send(hexaData)
            }
        }


    }



}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
