import QtQuick 2.0
import QtQuick.Controls 2.15
import "./Style/"


import QtQuick.Layouts 1.11
import SerialManager 1.0

import "SerialManagerTools" as SerialTool


AppRectangle {
    id:root
    width:850
    height:800
    
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
            SplitView.preferredWidth: 140
            manager: serManager
        }

        AppRectangle {
            id: mainSplit
            height: parent.height
            SplitView.preferredWidth: 550
            /*
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
*/
            SplitView{
                id:splitViewSerial
                anchors.fill: parent
                orientation: Qt.Vertical

                    SerialTool.SerialManagerDataViewer{
                        id:dataViewer
                        SplitView.preferredHeight: parent.height - 80

                        manager : serManager

                    }

                    SerialTool.SerialManagerLineSender {
                        id: serialManagerLineSender
                        y: 0

                        SplitView.preferredHeight: 80
                        manager : serManager
                        onSendStringData: function(stringData){ dataViewer.sendString(stringData)}
                        onSendHexaData:function(hexaData){ dataViewer.send(hexaData) }
                    }
            }
        }


    }



}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
