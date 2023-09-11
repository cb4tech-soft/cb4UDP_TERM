import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import MyScreenInfo
import SerialManager


ApplicationWindow {
    id: root
    width: 700
    height: 100
    /* model : ListElement { buttonText: "Alice"; command: "Crypto" }*/
    property var modelString : []
    signal sendString(serialString: string)
    GridLayout{
        anchors.fill: parent
        columns: 6
        Repeater{
            model: modelString

            SerialCustomButton{
                Layout.fillHeight: true
                Layout.fillWidth: true
                text: buttonText
                serialString: command
                onSendString: function(serialString) {
                    root.sendString(serialString)
                }

            }
        }
    }

}
