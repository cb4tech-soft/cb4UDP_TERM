import QtQuick
import QtQuick.Controls
import "../Style/"


import QtQuick.Layouts
import SerialManager
import QtQuick.Window




Popup {
    id: popup
    modal: true
    focus: true
    property alias timer: timer
    property var comList: []

    function update_text()
    {
        label.text = "New device found:\n" + popup.comList.join(', ')
    }

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnPressOutside
    onOpened: {
        //var str

        timer.running = true
    }
    onComListChanged: {
        console.log("update comlist ", popup.comList)

    }

    AppLabel{
        id: label
        anchors.fill: parent
        text: "New device found:\n" + popup.comList.join(', ')
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

    }

    Timer{
        id:timer
        interval: 4000
        running: false
        onTriggered: {
            console.log("clear Com List")
            comList.length = 0
            popup.close();
        }
    }
}
