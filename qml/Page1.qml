import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.5

Item {
    id: element
    width: 800
    height: 1080
    anchors.fill: parent
    Rectangle {
        id: frameOuter
        color: "#262626"
        radius: 10
        border.width: 1
        anchors.fill: parent
        anchors.margins: 16

        ColumnLayout {
            id: frameInner
            anchors.rightMargin: 16
            anchors.leftMargin: 16
            anchors.bottomMargin: 16
            anchors.topMargin: 16
            anchors.fill: parent


            Text {
                id: heading
                color: "#ffffff"
                text: qsTr("Rear Drive Motor (RDM)")
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                font.bold: true
                font.pointSize: 26
            }

            Image {
                id: image
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                source: "../images/RDM.jpg"
            }

            Text {
                id: description
                color: "#d3d7cf"
                text: qsTr("Lorem ipsum tortor duis condimentum ultrices in etiam class tellus, suscipit pharetra tellus iaculis sed interdum fusce aliquam aenean, dapibus in adipiscing a blandit massa turpis aenean elit metus sollicitudin curabitur interdum primis velit nisi purus primis, a sollicitudin tempor scelerisque cursus vehicula dictumst ante fames consequat purus odio ullamcorper tempor mattis ipsum, volutpat nam in viverra venenatis sociosqu, inceptos porta feugiat non purus urna vivamus class augue ipsum adipiscing lacus taciti nisl pellentesque vivamus donec interdum, elit non gravida tempor senectus proin luctus egestas curabitur.")
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: false
                Layout.fillWidth: true
                wrapMode: Text.WordWrap

            }

            Text {
                id: specsHeading
                color: "#ffffff"
                text: qsTr("Specifications")
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: false
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.bold: true
                font.pointSize: 26

            }

            Text {
                id: specsText
                color: "#d3d7cf"
                text: qsTr("Lorem ipsum tortor duis condimentum ultrices in etiam class tellus, suscipit pharetra tellus iaculis sed interdum fusce aliquam aenean, dapibus in adipiscing a blandit massa turpis aenean elit metus sollicitudin curabitur interdum primis velit nisi purus primis, a sollicitudin tempor scelerisque cursus vehicula dictumst ante fames consequat purus odio ullamcorper tempor mattis ipsum, volutpat nam in viverra venenatis sociosqu, inceptos porta feugiat non purus urna vivamus class augue ipsum adipiscing lacus taciti nisl pellentesque vivamus donec interdum, elit non gravida tempor senectus proin luctus egestas curabitur.")
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                wrapMode: Text.WordWrap

            }
        }

    }


}










/*##^## Designer {
    D{i:1;anchors_height:1080;anchors_width:800}
}
 ##^##*/
