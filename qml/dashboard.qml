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

import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4

Window {
    id: root
    visible: true
    width: 1920
    height: 1080

    color: "#161616"
    title: "RDM Demo"

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

                    onLeftRPMSignal: {
                        tachometerLeft.value = Math.abs(RDMBench.leftRPM)
                    }

                }


                ProgressBar {
                    id: leftTorque
                    height: 200
                    z: 1
                    anchors.centerIn: parent
                    width: height
                    property real gaugeValue
                    x: 100
                    y: 100
                    maximumValue: 15
                    minimumValue: -15
                    style: CircularProgressBarStyle { }

                    Behavior on gaugeValue {
                        NumberAnimation { duration: 300 }
                    }

                    Connections {
                        target: RDMBench

                        onLeftRPMSignal: {
                            leftTorque.gaugeValue = RDMBench.leftTorque
                        }

                    }
                }
            }

            DropShadow {
                anchors.fill: tachometerLeft
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                samples: 17
                color: "#80000000"
                cached: true
                source: tachometerLeft
            }




            CircularGauge {
                id: tachometerRight
                width: height
                height: 400
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: tachometerLeft.right
                anchors.leftMargin: 24
                maximumValue: 500
                z: 0

                style: TachometerStyle {}

                Behavior on value {
                    NumberAnimation { duration: 300 }
                }

                Connections {
                    target: RDMBench

                    onRightRPMSignal: {
                        tachometerRight.value = Math.abs(RDMBench.rightRPM)
                    }

                }

                ProgressBar {
                    id: rightTorque
                    height: 200
                    z: 1
                    anchors.centerIn: parent
                    width: height
                    property real gaugeValue
                    x: 100
                    y: 100
                    maximumValue: 15
                    minimumValue: -15
                    style: CircularProgressBarStyle {}

                    Behavior on gaugeValue {
                        NumberAnimation { duration: 300 }
                    }

                    Connections {
                        target: RDMBench

                        onRightRPMSignal: {
                            rightTorque.gaugeValue = RDMBench.rightTorque
                        }

                    }

                }
            }

            DropShadow {
                anchors.fill: tachometerRight
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                samples: 17
                cached: true
                color: "#80000000"
                source: tachometerRight
            }


        }


        Item {
            id: infoContainer
            x: 906
            width: 936
            anchors.right: parent.right
            anchors.rightMargin: 72
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            AnimatedImage {
                id: scrollDownImage
                x: 872
                y: 961
                width: 64
                height: 64
                anchors.right: parent.right
                anchors.rightMargin: 50
                fillMode: Image.PreserveAspectCrop
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 49
                rotation: 180
                z: 1
                source: "../images/scroll_up.gif"
            }

            AnimatedImage {
                id: scrollUpImage
                x: 872
                width: 64
                height: 64
                anchors.right: parent.right
                anchors.rightMargin: 46
                fillMode: Image.PreserveAspectCrop
                anchors.top: parent.top
                anchors.topMargin: 46
                z: 1
                source: "../images/scroll_up.gif"

            }

            SwipeView {
                id: swipeView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                orientation: Qt.Vertical
                wheelEnabled: true
                anchors.rightMargin: 128
                anchors.bottomMargin: 24
                anchors.leftMargin: 72
                anchors.topMargin: 24

                currentIndex: 0

                Item {
                    id: firstPage
                    Loader {
                        id: pageLoader1
                        source: "RDM.qml"
                        width: parent.width
                        height: parent.height
                    }

                }
                Item {
                    Loader {
                        id: pageLoader2
                        source: "Gearbox.qml"
                        width: parent.width
                        height: parent.height
                    }
                }
                Item {
                    id: thirdPage
                    Loader {
                        id: pageLoader3
                        source: "Motor.qml"
                        width: parent.width
                        height: parent.height
                    }
                }
                Item {
                    id: fourthPage
                    Loader {
                        id: pageLoader4
                        source: "Inverter.qml"
                        width: parent.width
                        height: parent.height
                    }
                }
            }

            PageIndicator {
                id: pageIndicator
                y: 342
                wheelEnabled: true
                anchors.right: parent.right
                anchors.rightMargin: 48
                anchors.verticalCenter: parent.verticalCenter
                scale: 3
                rotation: 90

                count: swipeView.count
                currentIndex: swipeView.currentIndex

            }




            RoundButton {
                id: scrollUpButton
                x: 905
                width: 64
                height: 64
                text: ""
                anchors.right: parent.right
                anchors.rightMargin: 48
                anchors.top: parent.top
                anchors.topMargin: 48
                visible: true
                focusPolicy: Qt.NoFocus
                display: AbstractButton.IconOnly
                spacing: 5

                background: Rectangle {
                    radius: parent.width/2
                    color: parent.down ? "#161616" : "#262626"
                }

                onClicked: swipeView.setCurrentIndex(swipeView.currentIndex > 0 ? swipeView.currentIndex-1 : 0)
            }

            RoundButton {
                id: scrollDownButton
                x: 911
                y: 974
                width: 64
                height: 64
                text: ""
                anchors.right: parent.right
                anchors.rightMargin: 48
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 48
                opacity: 0.2
                focusPolicy: Qt.NoFocus
                display: AbstractButton.IconOnly
                spacing: 5

                background: Rectangle {
                    radius: parent.width/2
                    color: parent.down ? "#161616" : "#262626"
                }
                onClicked: swipeView.setCurrentIndex(swipeView.currentIndex < 3 ? swipeView.currentIndex+1 : 3)
            }

            DropShadow {
                anchors.fill: scrollUpButton
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                cached: false
                samples: 17
                color: "#80000000"
                source: scrollUpButton
            }

            DropShadow {
                anchors.fill: scrollDownButton
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                cached: false
                samples: 17
                color: "#80000000"
                source: scrollDownButton
            }





        }

        Item {
            id: logoContainer
            width: 300
            height: 200
            anchors.top: parent.top
            anchors.topMargin: 48
            anchors.left: parent.left
            anchors.leftMargin: 48
            z: 2

            ProgressBar {
                id: stageProgressBar
                height: 124
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: 0
                z: 1
                anchors.centerIn: parent
                property real gaugeValue
                x: 100
                y: 100
                width: 124
                maximumValue: 5
                minimumValue: 0
                style: CircularProgressBarStyle {
                    startColorPos: "red"
                    endColorPos: "red"
                    displayValue: false
                }

                Behavior on gaugeValue {
                    NumberAnimation { duration: 300 }
                }

                Connections {
                    target: RDMBench

                    onDemoStageSignal: {
                        stageProgressBar.gaugeValue = RDMBench.demoStage
                    }

                }
            }

            Image {
                id: logoImage
                width: 240
                height: 180
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectCrop
                source: "../images/Karma-logo.png"
            }

            DropShadow {
                anchors.fill: logoImage
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                cached: true
                samples: 17
                color: "#80000000"
                source: logoImage
            }

            RoundButton {
                id: startButton
                x: 204
                y: 48
                width: 114
                height: 114
                text: "S T A R T"
                checkable: true
                font.pointSize: 15
                font.strikeout: false
                flat: false
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                z: 2



                background: Rectangle {
                    radius: startButton.width/2

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            SequentialAnimation on color {
                                loops: 1
                                ColorAnimation { to: "#262626"; duration: 200; easing.type: Easing.InOutQuad }
                                alwaysRunToEnd: true
                            }
                            SequentialAnimation on color {
                                running: startButton.pressed
                                loops: 1
                                ColorAnimation { to: "#14148c"; duration: 200; easing.type: Easing.InOutQuad }
                                ColorAnimation { to: "#262626"; duration: 200; easing.type: Easing.InOutQuad }
                                alwaysRunToEnd: true
                            }

                        }

                        GradientStop {
                            position: 1.0
                            SequentialAnimation on color {
                                loops: 1
                                ColorAnimation { to: "#666666"; duration: 200; easing.type: Easing.InOutQuad }
                                alwaysRunToEnd: true
                            }
                            SequentialAnimation on color {
                                running: startButton.pressed
                                loops: 1
                                ColorAnimation { to: "#14aaff"; duration: 200; easing.type: Easing.InOutQuad }
                                ColorAnimation { to: "#666666"; duration: 200; easing.type: Easing.InOutQuad }
                                alwaysRunToEnd: true
                            }
                        }
                    }

                }

                onClicked: {
                    RDMBench.startButtonPressed(true)
                }

                Connections {
                    target: RDMBench
                    onStartButtonPressedSignal: {
                        startButton.text = startButtonPressed ? "S T O P" : "S T A R T"
                        startButton.checked = startButtonPressed
                    }
                }


            }
        }

        Image {
            id: image
            x: 8
            y: 54
            width: 1020
            height: 582
            z: -5
            fillMode: Image.Tile
            source: "../images/karma-revero-infortainment-system-1.png"
        }



    }
}



