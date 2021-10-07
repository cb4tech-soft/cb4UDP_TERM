import QtQuick 2.0
import SerialManager 1.0
import QtQuick.Controls 2.12
import SerialInfo 1.0
import "../Style"
Item {
//    property SerialManager serialManager: undefined


    QtObject{
        id:internal
        property var portList: []
    }
    property alias port: port
    function updateList()
    {
        internal.portList = SerialInfo.getPortList()
    }

    Component.onCompleted: {
        updateList();
        console.log(internal.portList)
        port.currentIndex = port.count-1
    }
    AppComboBox{
        id: port
        model: internal.portList
        width: parent.width
        onDownChanged: {
            if (down)
                updateList()
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
