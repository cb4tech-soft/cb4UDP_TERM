import QtQuick 2.12
import QtQuick.Controls 2.12
import  "../Style"
import SerialManager 1.0


AppRectangle {
    id:root
    property SerialManager manager
    width: 600
    height: 80
    signal sendStringData(var stringData);

    AppButton{
        id: sendButton
        x: 492
        y: 20
        text: "Send"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        height: (root.height > 60) ?40 : root.height - 20
        onClicked: sendStringData(textLine.text)
    }
    AppTextField{
        id: textLine
        anchors.left: parent.left
        anchors.right: sendButton.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignLeft
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        largeSeparator: true


    }
}
