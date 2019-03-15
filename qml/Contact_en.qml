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
                text: qsTr("Contact Us")
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
                source: "../images/qrcode.png"
            }

            Text {
                id: body
                color: "#d3d7cf"
                text: qsTr("For any inquiries regarding our technology or Engineering Services, please contact us.")
                verticalAlignment: Text.AlignVCenter
                antialiasing: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 20
            }

            Text {
                id: specsHeading
                color: "#d3d7cf"
                antialiasing: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: false
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.bold: false
                font.pointSize: 16

            }

            Text {
                id: specsText
                color: "#d3d7cf"
                text: qsTr("E-Mail: businessdev@karmaautomotive.com\nWebsite (China): www.karmaautomotive.cn\nWebsite (US): www.karmaautomotive.com")
                antialiasing: false
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 20
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
    D{i:0;height:2160;width:1536}D{i:1;anchors_height:1080;anchors_width:800}
}
 ##^##*/
