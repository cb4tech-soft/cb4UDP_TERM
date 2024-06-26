import QtQuick
import QtQuick.Controls
import "./Style/"


import QtQuick.Layouts
import UdpManager
import QtQuick.Window
import Qt.labs.platform as Platform


import "SerialManagerTools" as SerialTool
import MyScreenInfo

import PluginInfo

import 'qrc:/js/fileStringTools.js' as FileStringTools

ApplicationWindow {
    id:root
    property bool themeDark: true
    property bool scanPortEnable : true
    property bool clearOnSend : false
    property alias serManager: serManager

    Connections {
        target: PluginInfo
        function onPluginFilesChanged() {
            console.log(PluginInfo.pluginFiles)
        }
    }

    menuBar: AppUDPMenu{}

    Repeater{
        id: pluginLoader
        model: PluginInfo.pluginFiles
        Loader{
            id: pluginLoaderItem
            active: false
            function deactivate(){
                pluginLoaderItem.active = false
                console.log("deactivate")
                pluginLoaderItem.source = ""
            }
            Connections {
                target: pluginLoaderItem.item
                function onClosing() {
                    pluginLoaderItem.deactivate()
                    pluginLoaderItem.source = ""
                }
                function onSendString(serialString) {
                    console.log(serialString)
                    serialManagerLineSender.sendStringData(serialString)
                }
            }
            Connections {
                target: dataViewer
                function onLineDataAppend(lineData) {
                    if (pluginLoaderItem.active && pluginLoaderItem.item && pluginLoaderItem.item.receiveLineFeatureEnable)
                    {
                        pluginLoaderItem.item.receiveString(lineData);
                    }
                }
            }

            Component.onCompleted: {
                console.log(index, "complete loader")
            }
        }
    }

    Loader{
        id: customButton
        active: false
        function deactivate(){
            customButton.active = false
            console.log("deactivate")
            customButton.source = ""
        }
        Connections {
            target: customButton.item
            function onClosing() { customButton.deactivate() }
            function onSendString(serialString) {
                serialManagerLineSender.sendStringData(serialString)
            }

        }
    }
    visible: true
    width:850
    //height:Math.min(MyScreenInfo.getScreenInfo(x,  y).height - 100, 850);

    Component.onCompleted: {
        root.height = Math.min(MyScreenInfo.getScreenInfo(x,  y).height - 100, 850)
        root.y = MyScreenInfo.getScreenInfo(x,  y).height - root.height - 100
        if (root.y < 0) root.y = 0
    }

    Donate{
        id:donation
        anchors.fill:parent
        z:10
        visible: false
    }

    UdpManager{
        id: serManager
    }
    SplitView{
        id:splitView
        anchors.fill: parent
        SerialTool.UdpManagerConfig{
            id:serialConfig
            SplitView.preferredWidth: 200
            manager: serManager
        }
        SplitView{
            id:splitViewSerial
            orientation: Qt.Vertical
            SerialTool.UdpManagerDataViewer{
                id:dataViewer
                SplitView.fillHeight: true
                manager : serManager
                onLineDataAppend: function(lineData) {
                    if (heatmapLoader.active && heatmapLoader.item)
                    {
                        heatmapLoader.item.datalineAppend(lineData);
                    }
                }
            }

            SerialTool.UdpManagerLineSender {
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
    }

}


