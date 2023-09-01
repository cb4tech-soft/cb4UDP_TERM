import QtQuick
import QtQuick.Controls
import "./Style/"


import QtQuick.Layouts
import SerialManager
import QtQuick.Window
import Qt.labs.platform as Platform


import "SerialManagerTools" as SerialTool
import MyScreenInfo



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
               title: "Addon"
               Action { text: "Heatmap"
                   onTriggered: {
                       console.log("opening heatmap")
                    heatmapLoader.source = "Heatmap.qml"
                       heatmapLoader.active = true
                       heatmapLoader.item.visible = true
                       var posX = root.x + root.width
                       var posY = root.y
                       var screenRect = MyScreenInfo.getScreenInfo( root.x ,  root.y)
                       console.log(screenRect.width)
                       if (posX + heatmapLoader.item.width >= screenRect.x + screenRect.width - 50)
                       {
                           console.log("update windows pos ", posX + heatmapLoader.item.width)
                           posX = screenRect.x + screenRect.width - heatmapLoader.item.width - 50
                       }
                       if (posY + heatmapLoader.item.height >= screenRect.y + screenRect.height - 50)
                       {
                           posY = screenRect.y + screenRect.height - heatmapLoader.item.height-50
                       }

                       console.log("windows pos = ", posX)
                       heatmapLoader.item.x = posX
                       heatmapLoader.item.y = posY
                       //heatmapLoader.item.closing = Qt.binding(function() { console.log("closing !!!") })

                   }
               }
               Action { text: "Heatmap3D"
                   onTriggered: {
                       console.log("opening heatmap")
                    heatmapLoader.source = "Heatmap3D.qml"
                       heatmapLoader.active = true
                       heatmapLoader.item.visible = true
                       var posX = root.x + root.width
                       var posY = root.y
                       var screenRect = MyScreenInfo.getScreenInfo( root.x ,  root.y)
                       console.log(screenRect.width)
                       if (posX + heatmapLoader.item.width >= screenRect.x + screenRect.width - 50)
                       {
                           console.log("update windows pos ", posX + heatmapLoader.item.width)
                           posX = screenRect.x + screenRect.width - heatmapLoader.item.width - 50
                       }
                       if (posY + heatmapLoader.item.height >= screenRect.y + screenRect.height - 50)
                       {
                           posY = screenRect.y + screenRect.height - heatmapLoader.item.height-50
                       }

                       console.log("windows pos = ", posX)
                       heatmapLoader.item.x = posX
                       heatmapLoader.item.y = posY
                       //heatmapLoader.item.closing = Qt.binding(function() { console.log("closing !!!") })

                   }
               }
               Action { text: "BitRegister"
                   onTriggered: {
                       console.log("opening bitReg")
                        bitRegister.source = "BitRegisterItem.qml"
                       bitRegister.active = true
                       bitRegister.item.visible = true
                       var posX = root.x
                       var posY = root.y + root.height
                       var screenRect = MyScreenInfo.getScreenInfo( root.x ,  root.y)
                       console.log(screenRect.width)
                       if (posX + bitRegister.item.width >= screenRect.x + screenRect.width - 50)
                       {
                           console.log("update windows pos ", posX + bitRegister.item.width)
                           posX = screenRect.x + screenRect.width - bitRegister.item.width - 50
                       }
                       if (posY + bitRegister.item.height >= screenRect.y + screenRect.height - 50)
                       {
                           posY = screenRect.y + screenRect.height - bitRegister.item.height-50
                       }

                       console.log("windows pos = ", posX)
                       bitRegister.item.x = posX
                       bitRegister.item.y = posY
                       //heatmapLoader.item.closing = Qt.binding(function() { console.log("closing !!!") })

                   }
               }
           }
           Menu {
               title: "Help"
               Action { text: "Donation"
                   onTriggered: {donation.visible = true; donation.catIndex = Math.ceil(Math.random() * 19)}
               }
           }
       }


    Loader{
        id: heatmapLoader
        active: false
        function deactivate(){
            heatmapLoader.active = false
            console.log("deactivate")
            heatmapLoader.source = ""
        }
        Connections {
            target: heatmapLoader.item
            function onClosing() {heatmapLoader.deactivate()}
        }
    }
    Loader{
        id: bitRegister
        active: false
        function deactivate(){
            bitRegister.active = false
            console.log("deactivate")
            bitRegister.source = ""
        }
        Connections {
            target: bitRegister.item
            function onClosing() {bitRegister.deactivate()}
        }
    }
    Platform.SystemTrayIcon {
        id:sysTray
        visible: true
        icon.source: "qrc:/qml/icon/logo1.ico"

        menu: Platform.Menu {
            Platform.MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
        onMessageClicked: console.log("Message clicked")

//        Component.onCompleted: showMessage("Message title", "Something important came up. Click this to know more.")

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

                sysTray.showMessage("New device found",  popup.comList.join(', '))
            }
            comList.scanPort: (root.scanPortEnable)? !serManager.isConnected : false
        }

        AppRectangle {
            id: mainSplit
            height: parent.height
            SplitView.preferredWidth: 550

            SplitView{
                id:splitViewSerial
                anchors.fill: parent
                orientation: Qt.Vertical

                    SerialTool.SerialManagerDataViewer{
                        id:dataViewer
                        SplitView.preferredHeight: parent.height - 80
                        manager : serManager
                        onLineDataAppend: function(lineData) {
                            if (heatmapLoader.active && heatmapLoader.item)
                            {
                                heatmapLoader.item.datalineAppend(lineData);
                            }
                        }
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


