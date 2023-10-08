import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 300
    height: 480

    signal sendString(serialString: string)
    property bool receiveLineFeatureEnable: true

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString)
        label.text = serialString
    }
    Rectangle{
        color: "red"
        width: 100
        height: 100
    }

    Label {
        id: label
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }

}
