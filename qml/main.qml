import QtQuick
import QtQuick.Controls
import "./Style/"


import QtQuick.Layouts
import SerialManager
import QtQuick.Window


import "SerialManagerTools" as SerialTool


ApplicationWindow {
    id:root

    property int nbClick: 0
    property bool themeDark: true
    property bool scanPortEnable : true
    property alias serManager: serManager

    menuBar: MenuBar {
           Menu {
               title: "Advanced"
               Action { text: "Scan port"; checkable: true; checked:root.scanPortEnable
                   onCheckedChanged: function (checked) {
                       scanPortEnable = checked
                       checked = Qt.binding(function() { return root.scanPortEnable })
                   }

               }
               Action { text: qsTr("&Open...") }
               Action { text: qsTr("&Save") }
               Action { text: qsTr("Save &As...") }
               MenuSeparator { }
               Action { text: qsTr("&Quit") }
           }
           Menu {
               title: qsTr("&Help")
               Action { text: qsTr("&About") }
           }
       }
    visible: true
    width:850
    height:800


    SerialTool.ComPluggedPopup {
        id: popup
        anchors.centerIn: Overlay.overlay
        height: 300
        width: 200
    }
    Component.onCompleted: {
    }

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
            comList.onNewComPort: function (portname){
                popup.comList = portname
                popup.open()
            }
            comList.scanPort: (root.scanPortEnable)? !serManager.isConnected : false
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
                        onSendHexaData: function(hexaData){ dataViewer.send(hexaData) }
                    }
            }
        }


    }



}


