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
    property bool clearOnSend : false
    property alias serManager: serManager

    menuBar: MenuBar {
           Menu {
               title: "Advanced"
               Action { text: "Scan port"; checkable: true; checked:root.scanPortEnable
                   onCheckedChanged: function (checked) {
                       root.scanPortEnable = checked
                       checked = Qt.binding(function() { return root.scanPortEnable })
                   }

               }
               Action { text: "ClearOnSend"; checkable: true; checked:root.clearOnSend
                   onCheckedChanged: function (checked) {
                       root.clearOnSend = checked
                       checked = Qt.binding(function() { return root.clearOnSend })
                   }
               }
               MenuSeparator { }
               Action { text: qsTr("&Quit")
                        onTriggered: Qt.quit()
               }
           }
           Menu {
               title: "Help"
               Action { text: "Donation"
                   onTriggered: {donation.visible = true; donation.catIndex = Math.ceil(Math.random() * 19)}
               }
           }
       }
    visible: true
    width:850
    height:800
    Donate{
        id:donation
        anchors.fill:parent
        z:10
        visible: false
    }

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
                var i = 0
                while (i < portname.length)
                {
                    popup.comList.push(portname[i])
                    i++;
                }
                popup.update_text()
                popup.open()
                popup.timer.interval = 4000;
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
                        onSendStringData: function(stringData){
                            dataViewer.sendString(stringData);
                            if (root.clearOnSend)
                                serialManagerLineSender.textInput = ""
                        }
                        onSendHexaData: function(hexaData){ dataViewer.send(hexaData)
                            if (root.clearOnSend)
                                serialManagerLineSender.textInput = "" }
                    }
            }
        }


    }



}


