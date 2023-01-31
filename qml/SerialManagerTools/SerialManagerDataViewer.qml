import QtQuick 2.15
import QtQuick.Controls 2.12
import Qt.labs.platform 1.1
import  "../Style"
import SerialManager 1.0

AppRectangle {
    id: appRectangle
    width: 400
    height: 300
    property alias dataView: dataView
    property alias serialData: serialData

    property SerialManager manager

    function logToText() {
        var chaine =[]
        for(let i = 0; i < serialData.count; i++) {
            if(ctrlTime.checked) {
                //This needs to be improved...
                var timehtml = serialData.get(i).timestamp
                var timestamp = timehtml.replace("<font color=\"grey\">", "");
                timestamp = timestamp.replace("</font>", "");
                timestamp+= " : "
                chaine.push(timestamp)
            }
            chaine.push(serialData.get(i).serData)
        }
        return chaine;
    }

    function lineUpdate()
    {

        while (manager.isLineAvailable())
        {
            var dataLine = manager.readLine()
            if (dataLine[dataLine.length-1] == '\n')
                dataLine =  dataLine.slice(0, -1)
            append(dataLine);
        }
    }

    function dataUpdate() {
        var data = manager.readAll()
        append(data)
    }

    Connections {
        target: manager
        function onLineAvailable(){ lineUpdate() }
        function onDataAvailable(){ dataUpdate() }
    }


    clip: true


    ListModel {
        id: serialData
    }

    function appendOut(outData)
    {
        console.log(outData)
        var r=""
        var i = 0;
        while (i < outData.length)
        {
            r+=String.fromCharCode(outData[i]);
            i++;
        }
        var currentDate = new Date
        var dateString = "<font color=\"grey\">" + currentDate.toLocaleTimeString(Qt.locale("fr_FR"),"h:mm:ss") + "</font>";

        serialData.append({"timestamp": dateString ,"serData": r, "isSend": true})
        console.log(r)
    }

    function send(outData)
    {
        serManager.sendData(outData)
        if (ctrlEcho.checked)
            appendOut(outData)
    }


    function sendString(outData)
    {
        serManager.sendString(outData)
        if (ctrlEcho.checked)
            apprendOutString(outData)
    }

    function apprendOutString(outData)
    {
        var currentDate = new Date
        var dateString = "<font color=\"grey\">" + currentDate.toLocaleTimeString(Qt.locale("fr_FR"),"h:mm:ss") + "</font>";

        serialData.append({"timestamp": dateString ,"serData": outData, "isSend": true})
    }

    function append(outData)
    {
        var currentDate = new Date
        var dateString = "<font color=\"grey\">" + currentDate.toLocaleTimeString(Qt.locale("fr_FR"),"h:mm:ss") + "</font>";

        serialData.append({"timestamp": dateString ,"serData": outData, "isSend": false})
    }

    FolderDialog{
        id: saveDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        title: "Select save destination :"
        onAccepted: {
                        var log = logToText()
                        console.log(this.currentFolder)
                        manager.saveToFile(log, this.currentFolder, ctrlTime.checked)
            }
    }

    Item {
        id: dataViewController
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        Row{
            anchors.fill: parent
            z: 1
            anchors.topMargin: 5
            layoutDirection: Qt.RightToLeft

            AppButton{
                id:ctrlClear
                text: "clear"
                onClicked: serialData.clear()
                height: parent.height
            }
            AppButton{
                id:ctrlSave
                text: "Save Log"
                onClicked: saveDialog.open()
                height: parent.height
            }
            AppCheckBox{
                id: ctrlTime
                text: "Show Time"
                checkable: true
                checked: true
                height: parent.height
            }
            AppCheckBox{
                id: ctrlScroll
                text: "Auto Scroll"
                checkable: true
                checked: true
                height: parent.height
            }
            AppCheckBox{
                id: ctrlEcho
                text: "Echo Mode"
                checkable: true
                checked: true
                height: parent.height
            }
            AppCheckBox{
                id: ctrlHex
                text: "Hex Mode"
                checkable: true
                checked: false
                height: parent.height
            }
        }

    }

    ListView {
        id: dataView
        clip: false
        height: parent.height - dataViewController.height - 16
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        model:serialData


        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
            active: ScrollBar.AlwaysOn
        }
        delegate: DataLine{
            id:contentLine
            showTime: ctrlTime.checked
            strData: serData
            isSendedData: isSend
            hexEnable: ctrlHex.checked
            dateString: timestamp

        }
        onCountChanged: {
            if (ctrlScroll.checked)
                dataView.positionViewAtEnd()
        }

    }


}
