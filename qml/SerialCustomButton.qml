import QtQuick
import QtQuick.Controls


Button {
    id : button

    property string serialString
    text:"1"
    signal sendString(serialString: string)
    onClicked: {
        sendString(serialString)
    }

}
