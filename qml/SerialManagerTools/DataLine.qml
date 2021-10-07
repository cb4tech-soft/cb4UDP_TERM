import QtQuick 2.12
import "../Style"

Row {
    property string strData: ""
    property string dateString: ""

    property bool showTime: false
    property bool isSendedData: false
    property bool hexEnable: false
    height: label.contentHeight
    width: (parent) ? parent.width : 0
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
    AppLabel{
        id: label
        width: parent.width -10
        text:(isSendedData)?"<font color=\"blue\">" + (((showTime == true)? dateString + " : " : "") + ((hexEnable)?toHex(strData) : strData)) + "</font>"
                           :  (((showTime == true)? dateString + " : " : "") + ((hexEnable)?toHex(strData) : strData))

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        leftPadding: 5
    }

}
