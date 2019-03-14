import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick 2.0

Slider {
    id: slider
    updateValueWhileDragging: true
    stepSize: 1
    minimumValue: 3
    value: 5
    maximumValue: 60
    orientation: Qt.Vertical
    property real handleSize: 50
    property real grooveThickness: 10

    style: SliderStyle {
        handle: Item {
            width: handleSize
            height: handleSize

            Rectangle {
                id: sliderHandle
                implicitWidth: handleSize
                implicitHeight: handleSize
                radius: implicitWidth / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "#555"
            }

            Text {
                rotation: 90
                color: "white"
                text: control.value + "s"
                anchors.horizontalCenterOffset: sliderHandle.width
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: handleSize / 2
                horizontalAlignment: Text.AlignHCenter
            }
        }
        groove: Rectangle { // background groove
            implicitHeight: grooveThickness
            implicitWidth: parent.width
            radius: implicitHeight / 2
            border.color: "#333"
            color: "#111"
//            Rectangle { // active groove
//                implicitHeight: parent.height
//                implicitWidth: styleData.handlePosition
//                radius: implicitHeight / 2
//                color: "#555"
//            }
        }
    }
}












/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
