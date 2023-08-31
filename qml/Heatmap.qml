import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import MyScreenInfo
import HeatMapData
import SerialManager


ApplicationWindow {
    property int resolution: 8
    property int updateTimeMs: 200
    Popup {
        id: popup
        width: parent.width
        modal: true
        focus: true
        property alias timerPopup: timerPopup
        property alias text: label.text

        closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnPressOutside
        onOpened: {
            timerPopup.running = true
        }
        Shortcut {
            sequence: "Esc"
            onActivated: {
                popup.close()
            }
        }
        Label{
            id: label
            anchors.fill: parent
            text: "data format : <b>*h[padNum]:[value]\\n</b><br/> Value must be between 0 -> 2000"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            textFormat: Text.RichText

        }

        Timer{
            id:timerPopup
            interval: 4000
            running: false
            onTriggered: {
                popup.close();
            }
        }
    }


    function datalineAppend(lineData)
    {
        console.log("dataLine append")
        HeatMapData.populate(lineData)
    }

    onResolutionChanged: {
        console.log("resolution change")
    }

    id: heatmap
    RowLayout{
        id:configRow
        height: ScreenInfo.pixelDensity * 12
        SpinBox{
            Layout.fillHeight: true
            Layout.fillWidth: true
            editable: true
            value: heatmap.resolution
            onValueChanged: {
                heatmap.resolution = value
            }

        }
        Button{
            id: info
            onClicked: {
                popup.open()
            }
        }

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0
    }

    width: 300
    height: 300


    GridLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: configRow.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        columnSpacing: 1
        rowSpacing: 1
        columns: heatmap.resolution
        rows: heatmap.resolution
        Repeater {
            id:repModel
            model: (heatmap.resolution * heatmap.resolution)
            Rectangle {
                id:heatItem
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "red"
                required property int index
                property int dist: 0

                function getColorFromDistance(distance) {
                    // Define the colors
                    const blue = [0, 0, 255];
                    const purple = [128, 0, 128];
                    const red = [255, 0, 0];

                    // Clamp the distance between 0 and 2000
                    distance = Math.max(0, Math.min(2000, distance));

                    let resultColor;

                    if (distance <= 1000) {
                        // Interpolate between red and purple for distances between 0 and 1000
                        const factor = distance / 1000;
                        resultColor = [
                            red[0] + factor * (purple[0] - red[0]),
                            red[1] + factor * (purple[1] - red[1]),
                            red[2] + factor * (purple[2] - red[2]),
                        ];
                    } else {
                        // Interpolate between purple and blue for distances between 1000 and 2000
                        const factor = (distance - 1000) / 1000;
                        resultColor = [
                            purple[0] + factor * (blue[0] - purple[0]),
                            purple[1] + factor * (blue[1] - purple[1]),
                            purple[2] + factor * (blue[2] - purple[2]),
                        ];
                    }

                    // Convert the result to a hex color string
                    return '#' + resultColor.map(channel => {
                        const hex = Math.round(channel).toString(16);
                        return hex.length === 1 ? '0' + hex : hex;
                    }).join('');
                }

                onDistChanged: {
                    heatItem.color = getColorFromDistance(dist)
                }

                Connections {
                    target: timer
                    function onTriggered(){
                        dist = HeatMapData.get(index)
                    }
                }

                Text {
                    id: valueLabel
                    text: heatItem.dist
                    anchors.fill: parent
                }
            }
        }
    }
    Component.onCompleted: {
        console.log("HEATMAP open")
    }
    Component.onDestruction: {
        console.log("HEATMAP destroyed")

    }
    onClosing: {
        console.log("HEATMAP close")
    }
    Timer{
        id : timer
        interval: heatmap.updateTimeMs
        running: true
        repeat: true
        onTriggered: {
            console.log("heatmap update")
        }
    }
}
