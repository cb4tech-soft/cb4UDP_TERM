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
    signal sendHexaData(var hexaData);

    function splitMulti(str, tokens){
            var tempChar = tokens[0];
            for(var i = 1; i < tokens.length; i++){
                str = str.split(tokens[i]).join(tempChar);
            }
            str = str.split(tempChar);
            return str;
    }

    function triggerSend() {
        var stringToSend = textLine.text
        switch(comboCLRF.currentIndex) {
            case 0:
                //stringToSend.replace('\n', '')
                //stringToSend.replace('\r', '')
                break
            case 1:
                //stringToSend.replace('\r', '')
                stringToSend+= "\n"
                break
            case 2:
                //stringToSend.replace('\n', '')
                stringToSend+= "\r"
                break
            case 3:
                stringToSend+= "\r\n"
                break
        }
        if(switchHex.checked) {
            var bytes = splitMulti(stringToSend, [' ', ',', '-', ';'])
            //var bytes = stringToSend.split(',')
            var ok = true;
            var count = 0
            var hexaBytes = []
            while(ok && count < bytes.length) {
                hexaBytes.push(parseInt(bytes[count], 16))
                console.log(hexaBytes[count] + " - " + bytes[count])
                if(hexaBytes[count] > 0xFF) {
                    ok = false
                    hexaBytes = []
                    console.log("Hexa conversion error.")
                }
                count++
            }
            console.log(stringToSend)
            stringToSend = hexaBytes
            sendHexaData(stringToSend)
       } else {
            sendStringData(stringToSend)
        }
    }

    focus: true
    Keys.onPressed: {
                    if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                        triggerSend()
                    }
                    }


    AppButton{
        id: sendButton
        text: "Send"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        height: (root.height > 60) ?40 : root.height - 20
        onClicked: {
            triggerSend()
        }
    }
    AppTextField{
        id: textLine
        anchors.left: parent.left
        anchors.right: switchHex.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignLeft
        anchors.leftMargin: 5
        anchors.rightMargin: 86
        largeSeparator: true
        placeholderText: "Hello World!"

    }

    AppSwitch {
        id: switchHex
        anchors.right: sendButton.left
        anchors.top: parent.top
        text: "Hex  "
        onClicked: {
            if(this.checked)
                textLine.placeholderText = "128,1,2,3"
            else
                textLine.placeholderText = "Hello World!"

        }
    }

    AppComboBox {
        id: comboCLRF
        anchors.right: sendButton.left
        anchors.top:switchHex.bottom
        model: ["No CRLF", "Line feed", "Carriage return", "Both"]
        height: 40
        anchors.rightMargin: 5
    }
}
