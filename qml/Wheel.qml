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
        radius: 10
        border.width: 1
        anchors.fill: parent
        anchors.margins: 16

        ColumnLayout {
            id: frameInner
            anchors.rightMargin: Math.max(parent.height, parent.width) * 0.02
            anchors.leftMargin: Math.max(parent.height, parent.width) * 0.02
            anchors.bottomMargin: Math.max(parent.height, parent.width) * 0.02
            anchors.topMargin: Math.max(parent.height, parent.width) * 0.02
            anchors.fill: parent



            Text {
                id: pageHeading
                color: "#d3d7cf"
                text: qsTr("Wheel")
                antialiasing: false
                font.underline: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                font.bold: false
                font.pointSize: 20

            }

            Rectangle {
                id: imageHolder
                color: "black"
                Layout.minimumHeight: 480
                Layout.minimumWidth: 640

                Layout.fillWidth: false
                Layout.fillHeight: false
                Layout.maximumHeight: 960
                Layout.maximumWidth: 1280
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                Image {
                    id: image
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    anchors.fill: parent
                    sourceSize.height: 960
                    sourceSize.width: 1280
                    fillMode: Image.PreserveAspectFit
                    source: "../images/Wheel.png"

                }
            }




            Text {
                id: body
                color: "#d3d7cf"
                text: qsTr("Karma Automotive推出的22英寸碳纤维轮。 22英寸的碳纤维车轮平衡了大型设计比例，复杂的造型和低滚动惯性。 带来极致奢华的性能体验。 低滚动惯性是通过两件式车轮策略实现的：中心铝制轮辐部分固定在碳纤维箍上。 两件式铝/碳策略降低了车辆的非簧载质量，从而改善了转向/操纵特性，增加了车辆加速度，无与伦比的造型复杂性以及超出结构耐久性能要求。 22英寸碳影反映了Karma Automotive 的高性能奢华愿景。")
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
                text: qsTr("Hoop Material: Carbon Fiber\nSpokes Material: HPC Aluminum A356-T6\nFront Wheel: 22x8.5J (11.7 kg - 34% reduction*)\nRear Wheel: 22x9.5J (12.9 kg - 35% reduction*)\nFront Rolling Inertia: 0.320 kg-m2 (43% reduction*)\nRear Rolling Inertia: 0.383 kg-m2 (38% reduction*)\n0-100 kph Improvement: Δ0.1s\n\n*As compared to a cast wheel with same size, same loading requirements, and similar styling complexity.")
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