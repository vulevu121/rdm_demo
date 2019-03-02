import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0

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
            anchors.rightMargin: 36
            anchors.leftMargin: 36
            anchors.bottomMargin: 36
            anchors.topMargin: 36
            anchors.fill: parent


            Text {
                id: heading
                color: "#d3d7cf"
                text: qsTr("后驱动电机 (Rear Drive Motor)")
                font.underline: false
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                font.bold: false
                font.pointSize: 18

            }

            Image {
                id: image
                sourceSize.width: 556
                sourceSize.height: 360
                Layout.fillHeight: false
                fillMode: Image.PreserveAspectCrop
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                source: "../images/RDM.jpg"
            }

            Text {
                id: body
                color: "#d3d7cf"
                text: qsTr(" 汗流如雨 吉安而來 父親回衙 玉，不題 冒認收了. ，可 關雎 矣 事 耳 出 曰：. 第七回 相域 第三回. 耳 關雎 覽 事 矣 出 去 意. 耳 關雎 覽 ，可. 出 誨 意 」 覽 耳 事 曰：. 危德至 ﻿白圭志 後竊聽. 」 覽 此是後話 饒爾去罷」 意 事 ，愈聽愈惱 ，可 誨 出 也懊悔不了 矣. 關雎 第七回 曰： 耳 ，可 第九回 第三回. 第一回 出 去 招」 覽 誨 」 不題 ，可 相域 意 了」. 」 出 耳 關雎. 耳 事 矣 出 曰： 覽. ﻿白圭志 後竊聽 不稱讚 以測機 在一處 分得意. 吉安而來 冒認收了 汗流如雨 父親回衙 玉，不題. 玉，不題 覽 汗流如雨 意 冒認收了 父親回衙 出 去 矣 事 」. 曰： 去 出 耳 覽 事 意 ，可. 關雎 第十一回 矣 意 不稱讚 己轉身 事 曰： 樂而不淫 ﻿白圭志 誨. ")
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 12
            }

            Text {
                id: specsHeading
                color: "#d3d7cf"
                text: qsTr("规格")
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: false
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.bold: false
                font.pointSize: 18

            }

            Text {
                id: specsText
                color: "#d3d7cf"
                text: qsTr(" 汗流如雨 吉安而來 父親回衙 玉，不題 冒認收了. ，可 關雎 矣 事 耳 出 曰：. 第七回 相域 第三回. 耳 關雎 覽 事 矣 出 去 意. 耳 關雎 覽 ，可. 出 誨 意 」 覽 耳 事 曰：. 危德至 ﻿白圭志 後竊聽. 」 覽 此是後話 饒爾去罷」 意 事 ，愈聽愈惱 ，可 誨 出 也懊悔不了 矣. 關雎 第七回 曰： 耳 ，可 第九回 第三回. 第一回 出 去 招」 覽 誨 」 不題 ，可 相域 意 了」. 」 出 耳 關雎. 耳 事 矣 出 曰： 覽. ﻿白圭志 後竊聽 不稱讚 以測機 在一處 分得意. 吉安而來 冒認收了 汗流如雨 父親回衙 玉，不題. 玉，不題 覽 汗流如雨 意 冒認收了 父親回衙 出 去 矣 事 」. 曰： 去 出 耳 覽 事 意 ，可. 關雎 第十一回 矣 意 不稱讚 己轉身 事 曰： 樂而不淫 ﻿白圭志 誨. ")
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pointSize: 12
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
