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
    property var comList: [""]
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnPressOutside
    onOpened: {
        //var str

        timer.running = true
    }
    AppLabel{
        id: label
        anchors.fill: parent
        text: "New device found:\n" + popup.comList.join(', ')
        horizontalAlignment: Text.AlignHCenter

    }

    Timer{
        id:timer
        interval: 4000
        running: false
        onTriggered: {
            popup.close();
        }
    }
}
