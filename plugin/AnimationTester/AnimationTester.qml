import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


/*
  this is a test animation view
  we can customize the number of frames and the speed of the animation
  */
ApplicationWindow {
    id: window
    width: 450
    height: 450
    visible: true
    title: qsTr("Animation Tester")

    property int frameCount: 8
    property int frameDuration: 100
    property bool running: false
    property int currentFrame: 0
    property string animation: "qrc:/images/"


    Timer {
        id: timer
        interval: frameDuration
        running: window.running
        repeat: true
        onTriggered: {
            currentFrame = (currentFrame + 1) % frameCount
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout {
            spacing: 10
            Button {
                text: "Start"
                onClicked: running = true
            }
            Button {
                text: "Stop"
                onClicked: running = false
            }
        }

        RowLayout{
            spacing: 10
            Label {
                text: "Animation folder"
                width: 200
            }
            TextField {
                text: animation
                onTextChanged: animation = text
                Layout.fillWidth: true

            }
            anchors.right: parent.right
            anchors.left: parent.left

        }

        RowLayout {
            spacing: 10
            Label {
                text: "Frame Count"
            }
            SpinBox {
                from: 1
                to: 100
                value: frameCount
                onValueChanged: frameCount = value
            }
        }

        RowLayout {
            spacing: 10
            Label {
                text: "Frame Duration"
            }
            SpinBox {
                from: 1
                to: 1000
                value: frameDuration
                onValueChanged: frameDuration = value
            }
        }

        RowLayout {
            spacing: 10
            Label {
                text: "Current Frame"
            }
            Label {
                text: currentFrame
            }
        }

        RowLayout {
            spacing: 10
            Label {
                text: "Animation"
            }
            Image {
                source: "qrc:/images/animation.png"
                width: 32
                height: 32
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 32 * frameCount
                sourceSize.height: 32
                x: -32 * currentFrame
            }
        }
    }
}
