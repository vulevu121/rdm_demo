/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4

import QtQuick 2.3
import QtGraphicalEffects 1.0



Window {
    id: root
    visible: true
    width: 1920
    height: 1080

    color: "#161616"
    title: "RDM Demo"

    ValueSource {
        id: valueSource
    }

    // Dashboards are typically in a landscape orientation, so we need to ensure
    // our height is never greater than our width.
    Item {
        id: container
        width: root.width
        height: root.height
        z: 2
        anchors.centerIn: parent


        Item {
            id: gaugeContainer
            width: 900
            height: 400
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 64
            anchors.left: parent.left
            anchors.leftMargin: 64




            //            CircularGauge {
            //                id: speedometer
            //                value: valueSource.kph
            //                anchors.verticalCenter: parent.verticalCenter
            //                maximumValue: 280
            //                // We set the width to the height, because the height will always be
            //                // the more limited factor. Also, all circular controls letterbox
            //                // their contents to ensure that they remain circular. However, we
            //                // don't want to extra space on the left and right of our gauges,
            //                // because they're laid out horizontally, and that would create
            //                // large horizontal gaps between gauges on wide screens.
            //                width: height
            //                height: container.height * 0.5

            //                style: DashboardGaugeStyle {}
            //            }

            //            Button {
            //                id: button
            //                text: qsTr("Button")
            //                onClicked: RDMBench.random_value()
            //            }


            CircularGauge {
                id: tachometerLeft
                width: height
                height: 400
                z: 0

                minimumValue: 0
                maximumValue: 500
                anchors.verticalCenter: parent.verticalCenter

                style: TachometerStyle {}

                Behavior on value {
                    NumberAnimation { duration: 300 }
                }

                Connections {
                    target: RDMBench

                    // say signal handler, "on" + "[your function name]"
                    onLeftRPMSignal: {
                        tachometerLeft.value = RDMBench.leftRPM
                    }

                }


                ProgressBar {
                    id: leftTorque
                    height: 200
                    z: 1
                    anchors.centerIn: parent
                    width: height
                    property real gaugeValue: RDMBench.leftTorque
                    x: 100
                    y: 100
                    maximumValue: 15
                    minimumValue: -15
                    style: CircularProgressBarStyle {}

                    Behavior on gaugeValue {
                        NumberAnimation { duration: 300 }
                    }
                }
            }

            CircularGauge {
                id: tachometerRight
                width: height
                height: 400
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: tachometerLeft.right
                anchors.leftMargin: 64
                maximumValue: 500
                z: 0

                style: TachometerStyle {}


                Behavior on value {
                    NumberAnimation { duration: 300 }
                }

                Connections {
                    target: RDMBench

                    // say signal handler, "on" + "[your function name]"
                    onRightRPMSignal: {
                        tachometerRight.value = RDMBench.rightRPM
                    }

                }

                ProgressBar {
                    id: rightTorque
                    height: 200
                    z: 1
                    anchors.centerIn: parent
                    width: height
                    property real gaugeValue: RDMBench.rightTorque
                    x: 100
                    y: 100
                    maximumValue: 15
                    minimumValue: -15
                    style: CircularProgressBarStyle {}

                    Behavior on gaugeValue {
                        NumberAnimation { duration: 300 }
                    }

                }
            }

        }

        Item {
            id: infoContainer
            x: 648
            y: 190
            width: 352
            height: 295

        }

        Item {
            id: logoContainer
            anchors.top: parent.top
            anchors.topMargin: 64
            anchors.left: parent.left
            anchors.leftMargin: 64
            width: 278
            height: 203

            Image {
                id: logoImage
                width: 240
                height: 180
                fillMode: Image.PreserveAspectCrop
                source: "../images/Karma-logo.png"
            }

            ToggleButton {
                id: toggleButton
                y: 40
                text: qsTr("Start")
                anchors.left: logoImage.right
                anchors.leftMargin: -170
                width: 100
                height: 100


                style: ToggleButtonStyle {
                    checkedGradient: Gradient {
                        //                        GradientStop { position: 0.0; color: "red" }
                        GradientStop { position: 0.33; color: "yellow" }
                        GradientStop { position: 1.0; color: "green" }
                    }

                    uncheckedGradient: Gradient {
                        //                        GradientStop { position: 0.0; color: "red" }
                        GradientStop { position: 0.33; color: "yellow" }
                        GradientStop { position: 1.0; color: "red" }
                    }


                }
            }
        }
    }
}
