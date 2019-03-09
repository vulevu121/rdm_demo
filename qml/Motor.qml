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
                text: qsTr("Motor")
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
                source: "../images/Motor.png"
            }


            Text {
                id: body
                color: "#d3d7cf"
                text: qsTr("Karma战略合作伙伴开发的高速动力电机，200kW的峰值功率并可达13,000 rpm的最高转速。豪华版车型配备的电机可提供370Nm峰值扭矩，运动款车型配备的电机可提供420Nm峰值扭矩。")
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
                text: qsTr("Peak Power: 200 kW @ 5000 rpm\nPeak Torque: 370 Nm 0-4000 rpm\nContinuous Power: 60 kW\nRated Voltage: 370 V\nMax Speed: 13,7000 rpm")
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