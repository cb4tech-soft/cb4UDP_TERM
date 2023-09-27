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
    ListModel {
       id: nameModel
       ListElement { buttonText: "HeatMap"; command: "H" }
       ListElement { buttonText: "OPEN1"; command: "0" }
       ListElement { buttonText: "OPEN2"; command: "1" }
       ListElement { buttonText: "DAISY OUT"; command: "D" }
       ListElement { buttonText: "V1"; command: "V" }
       ListElement { buttonText: "V2"; command: "W" }
       ListElement { buttonText: "V3"; command: "X" }
       ListElement { buttonText: "LED"; command: "L" }
   }
    property var modelString : nameModel
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
