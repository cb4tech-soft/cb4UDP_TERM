import QtQuick
import QtQuick.Controls
import  "../Style"
import SerialManager
import QtQuick.Layouts


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
        if (!textLine.text.length)
            return
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
            var bytes = splitMulti(stringToSend, [' ', ',', '-', ';', '\n'])
            //var bytes = stringToSend.split(',')
            var ok = true;
            var count = 0
            var hexaBytes = []
            var error = false
            while(ok && count < bytes.length) {
                hexaBytes.push(parseInt(bytes[count], 16))
                //console.log(hexaBytes[count] + " - " + bytes[count])
                if(hexaBytes[count] > 0xFF) {
                    ok = false
                    hexaBytes = []
                    //textLine.background.color = "pink"
                    console.log("Hexa conversion error.")
                    error = true
                }
                count++
            }
            //console.log(stringToSend)
            if(!error) {
                //textLine.backgroundColor = AppStyle.backgroundLight
                stringToSend = hexaBytes
                sendHexaData(stringToSend)
            }
       } else {
            //textLine.backgroundColor = AppStyle.backgroundLight
            sendStringData(stringToSend)
        }
    }

    focus: true


    ColumnLayout{
        id:sendLayout
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 1
        anchors.bottomMargin: 4
        anchors.rightMargin: 8
        anchors.right: parent.right
        property bool advancedMode: false
        SpinBox{
            id:repeatTime
            Layout.preferredHeight: root.height - sendButton.height - 4
            visible: sendLayout.advancedMode
            stepSize: 100
            to: 5000
            from: 10
            value: 500
            editable: true
            Layout.topMargin: 1

        }

        AppButton{
            id: sendButton
            Timer{
                id:timerRepeat
                repeat: true
                interval: repeatTime.value
                running: false
                onTriggered: {
                    triggerSend()
                }
            }

            text: (sendLayout.advancedMode) ?
                      (!timerRepeat.running) ? "Send " + repeatTime.value + " ms" : "stop"
                                            : "Send"
            Layout.bottomMargin: 3
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: (root.height > 60) ? 40 : root.height - 20
            onClicked: {
                if (sendLayout.advancedMode)
                {
                    if (timerRepeat.running)
                    {
                        timerRepeat.stop()
                    }
                    else
                    {
                        timerRepeat.start()
                    }
                }
                else
                {
                    triggerSend()
                }
            }
            onPressAndHold: {
                sendLayout.advancedMode = !sendLayout.advancedMode
            }
        }
    }
    ScrollView{
        id: textLineView
        anchors.left: parent.left
        anchors.right: columnOption.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 10
        anchors.bottomMargin: 5
        TextArea{
            id: textLine
            horizontalAlignment: Text.AlignLeft
            enabled: serialConfig.manager.isConnected
            placeholderText: "Hello World!"
            anchors.top: parent.top
            anchors.topMargin: 4

            Keys.onReleased: (event) => {
                if ((event.key == Qt.Key_Return || event.key == Qt.Key_Enter) && !(event.modifiers & Qt.ShiftModifier)) {
                    var pos = cursorPosition
                    text = text.substring(0, pos - 1) + text.substring(pos, text.length)
                    cursorPosition = text.length
                    triggerSend()
                }
            }

        }
    }

    ColumnLayout{
        id: columnOption
        anchors.right: sendLayout.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        spacing: 1
        AppSwitch {
            id: switchHex
            text: "Hex  "
            Layout.fillHeight: true
            onClicked: {
                if(this.checked)
                    textLine.placeholderText = "4A,01,CB,47"
                else
                    textLine.placeholderText = "Hello World!"
            }
        }

        AppComboBox {
            id: comboCRLF
            model: ["No CRLF", "Line feed", "Carriage return", "Both"]
            height: 37
            Layout.fillHeight: true
            anchors.rightMargin: 5
        }
    }
}
