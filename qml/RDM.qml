import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2

Item {
    id: root
    width: 800
    height: 1080
    anchors.fill: parent
    Rectangle {
        id: frameOuter
        color: "#222222"
        radius: parent.height * 0.02
        border.width: 1
        anchors.fill: parent
        anchors.margins: 16

        ColumnLayout {
            id: frameInner
            anchors.rightMargin: Math.max(parent.height, parent.width) * 0.04
            anchors.leftMargin: Math.max(parent.height, parent.width) * 0.04
            anchors.bottomMargin: Math.max(parent.height, parent.width) * 0.04
            anchors.topMargin: Math.max(parent.height, parent.width) * 0.04
            anchors.fill: parent

            Text {
                id: pageHeading
                color: "#d3d7cf"
                text: qsTr("Rear Drive Motor")
                antialiasing: false
                font.underline: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                font.bold: false
                font.pointSize: 20
            }

            Image {
                id: image
                Layout.fillWidth: true
                Layout.maximumHeight: parent.height * 0.4
                Layout.fillHeight: true
                Layout.maximumWidth: 1280
                sourceSize.height: 960
                sourceSize.width: 1280
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                source: "../images/RDM.png"
            }


            Text {
                id: body
                color: "#d3d7cf"
                text: qsTr("KARMA Revero 2.0 后驱系统是由两套独立的高速永磁同步电机和逆变器，一个独立驱动齿轮箱（减速器），隔离衬套和液体冷却系统组成。该系统的主要功能是将高压直流电能转换成永磁同步电机的机械动能，并通过减速器来讲该动力传递给车轮（地面）来推动车辆）。由于单独驱动单侧后轮，此后驱系统可以提供全时的扭矩矢量控制，提高和改善车辆的动态响应，操控性，以及驾驶体验，并且在刹车的过程中捕获动能来执行再生制动。")
                verticalAlignment: Text.AlignVCenter
                antialiasing: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 16
            }

            Text {
                id: specsHeading
                color: "#d3d7cf"
                text: qsTr("规格")
                antialiasing: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: false
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.bold: false
                font.pointSize: 20

            }

            Text {
                id: specsText
                color: "#d3d7cf"
                text: qsTr("Power: 400 kW\nWheel Torque: 6,340 Nm (Luxury)\nMass: 190 kg\nEfficiency: >94%\nVoltage: 360 VDC")
                antialiasing: false
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 16
            }

        }

    }

    DropShadow {
        color: "#80000000"
            anchors.fill: frameOuter
            horizontalOffset: 0
            verticalOffset: 7
            radius: 8
            cached: true
            samples: 17
            source: frameOuter
    }


}
















/*##^## Designer {
    D{i:1;anchors_height:1080;anchors_width:800}
}
 ##^##*/
