import QtQuick
import QtQuick.Controls
import "../Style"

Row {
    id:row
    property string strData: "demo"

    property string strRichData: "demo"
    property string dateString: ""

    property bool showTime: false
    property bool isSendedData: false
    property bool hexEnable: false
    height: textArea.contentHeight +2
    width:parent.width
    function toHex(str) {
        var result = '';
        var j = 0;
        for (var i=0; i<str.length; i++) {
        if (str.charCodeAt(i) < 16)
            result += '0'
        result += str.charCodeAt(i).toString(16)
        result += ' ';
      }
      return result;
    }
    TextArea{
        id: textArea
        anchors.top: parent.top
        height: textArea.contentHeight +2
        width: parent.width
        text: (isSendedData)?"<font color=\"blue\">" + (((showTime == true)? dateString + " : " : "") + ((hexEnable)?toHex(strData) : strRichData)) + "</font>"
                           :  (((showTime == true)? dateString + " : " : "") + ((hexEnable) ? toHex(strData) : strRichData))

        horizontalAlignment: Text.AlignLeft
        //verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        bottomPadding: 1
        topPadding: 1
        textFormat: Text.RichText
        leftPadding: 5
        selectByMouse: true
        readOnly: true

        Component.onCompleted: {
            strRichData = strData.replace(/\n/g, "<br />")
//            row.height = textArea.contentHeight +2
//            textArea.height = textArea.contentHeight +2
            /*
            let lines = strData.split(/\r|\r\n|\n/);
            let count = lines.length;
            if (count == 1)
            {
                row.height = textArea.implicitHeight/2
                textArea.height = textArea.implicitHeight/2
            }
            */
            console.log(textArea.contentHeight);
        }
    }

}
