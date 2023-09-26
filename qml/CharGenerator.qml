import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


ApplicationWindow {
    width: 600
    height: 600
    property var bitValueArray: []
    function updateText(){
        var strStruct = "#define " + titre.text + "{\\"
        var i = 0
        var j = 0
        var ind = 0
        strStruct = strStruct + "\n" + spinWidth.value + ",\\\n" + spinHeight.value + ","
        while (i < spinHeight.value)
        {
            strStruct = strStruct + "\\\n0B"
            while (j < spinWidth.value)
            {
                strStruct = strStruct + bitValueArray[ind]
                ind++
                j++
            }
            j = 0

            i++
            if (i < spinHeight.value)
                strStruct = strStruct + ","
        }
        strStruct = strStruct + "\\\n}"
        textArea.text = strStruct
    }

    SplitView{
        id: splitView
        anchors.fill: parent



    Item {
        id: item1
        width: 266
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0

        SplitView.preferredWidth: 350
        RowLayout{
            id: colSettings
            height: 50
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0
            TextArea {
                id: titre
                text: "LETTER"
                onTextChanged: updateText()
            }

            SpinBox{
                id : spinWidth
                from: 1
                to: 32
            }
            SpinBox{
                id : spinHeight
                from: 1
                to: 32
            }
        }
        GridLayout {
            id: gridView
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.top: colSettings.bottom
            anchors.bottom: parent.bottom
            rowSpacing: 5
            columnSpacing: 5
            anchors.topMargin: 5
            property int nbCase: spinWidth.value * spinHeight.value
            onNbCaseChanged: {
                bitValueArray = Array(nbCase)
            }

            columns: spinWidth.value
            Repeater{
                model: gridView.nbCase

                delegate : Rectangle {
                    property int sizeSC:  Math.min(gridView.width/spinWidth.value - 5 , gridView.height/spinHeight.value - 5)
                    property int selected: 0
                    onSelectedChanged: {
                        bitValueArray[index] = selected
                        console.log(index, "->", selected)
                        updateText()
                    }
                    Component.onCompleted: {
                        bitValueArray[index] = selected
                    }

                    width:sizeSC
                    height: sizeSC
                    color: (selected)? "lightBlue" : "white"
                    radius: 2
                    border.width: 1

                    MouseArea{
                        anchors.fill: parent
                        onClicked: parent.selected = !parent.selected
                    }

                }

            }
        }
    }

    TextArea {
        id: textArea
        placeholderText: qsTr("Text Area")
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        SplitView.maximumWidth: 200
    }

    }
}
