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
        switch(comboCRLF.currentIndex) {
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
            var error = false
            while(ok && count < bytes.length) {
                hexaBytes.push(parseInt(bytes[count], 16))
                console.log(hexaBytes[count] + " - " + bytes[count])
                if(hexaBytes[count] > 0xFF) {
                    ok = false
                    hexaBytes = []
                    textLine.background.color = "pink"
                    console.log("Hexa conversion error.")
                    error = true
                }
                count++
            }
            console.log(stringToSend)
            if(!error) {
                textLine.background.color = AppStyle.backgroundLight
                stringToSend = hexaBytes
                sendHexaData(stringToSend)
            }
       } else {
            textLine.background.color = AppStyle.backgroundLight
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
        anchors.right: comboCRLF.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignLeft
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        largeSeparator: true
        enabled: serialConfig.manager.isConnected
        placeholderText: "Hello World!"

    }

    AppSwitch {
        id: switchHex
        anchors.right: sendButton.left
        anchors.top: parent.top
        text: "Hex  "
        onClicked: {
            if(this.checked)
                textLine.placeholderText = "80,1,2,3"
            else
                textLine.placeholderText = "Hello World!"
        }
    }

    AppComboBox {
        id: comboCRLF
        anchors.right: sendButton.left
        anchors.top:switchHex.bottom
        model: ["No CRLF", "Line feed", "Carriage return", "Both"]
        height: 37
        anchors.rightMargin: 5
    }
}
