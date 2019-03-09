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
                text: qsTr("Wheel")
                Layout.fillHeight: false
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
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                source: "../images/Wheel.png"
                
                Rectangle {
                    color: "transparent"
                    radius: 10
                    border.width: 2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.color: "black"
                    width: parent.paintedWidth + border.width
                    height: parent.paintedHeight + border.width
                }
            }




            Text {
                id: body
                color: "#d3d7cf"
                text: qsTr("Karma 推出的22英寸碳纤维轮毂，该设计成功均衡了大型设计比例，复杂造型和低滚动惯量， 为用户带来极致奢华的性能体验。 两件式车轮设计方案，中心铝制轮辐部分直接固定在炭纤维轮圈上，提供了低滚动惯量， 降低了车辆的非簧载质量，从而改善了转向/操纵特性，增加了车辆加速度，保证了复杂造型的同时并满足了结构耐久性能要求。该22英寸轮毂上的碳影直接反映出了Karma Automotive 高性能和奢华的愿景。")
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
