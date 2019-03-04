import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0

Window {
    id: root
    visible: true
    width: 1920
    height: 1080
    //    visibility: Window.FullScreen

    color: "#161616"
    title: "RDM Demo"



    Item {
        id: controlContainer
        width: root.width * 0.5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        z: 2


        Item {
            id: karmaContainer
            height: parent.height * 0.2
            anchors.rightMargin: parent.width *0.02
            anchors.leftMargin: parent.width * 0.02
            anchors.topMargin: parent.height * 0.04
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top

            Image {
                id: karmaHeader
                anchors.leftMargin: 24
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                sourceSize.height: 109
                sourceSize.width: 695
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.left: startButtonContainer.right
                anchors.right: parent.right
                source: "../images/karma-logo-header.png"
                fillMode: Image.PreserveAspectFit
            }

            Item {
                id: startButtonContainer
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width * 0.02
                anchors.left: parent.left
                z: 2



                Image {
                    id: logoImage
                    width: height
                    height: startButtonContainer.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "../images/Karma-logo.png"

                    ProgressBar {
                        id: stageProgressBar
                        width: height
                        height: parent.height * 0.7
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: 0
                        z: 1
                        anchors.centerIn: parent
                        property real gaugeValue
                        x: 100
                        y: 100
                        maximumValue: 5
                        minimumValue: 0
                        style: CircularProgressBarStyle {
                            startColorPos: "red"
                            endColorPos: "red"
                            displayValue: false
                            borderWidth: 10
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

                        RoundButton {
                            id: startButton
                            x: 204
                            y: 48
                            width: height
                            height: parent.height - 16
                            text: "S T A R T"
                            checkable: true
                            font.strikeout: false
                            flat: false
                            highlighted: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: startButtonContainer.height*0.1
                            z: 3

                            background: Rectangle {
                                radius: startButton.width/2
                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        SequentialAnimation on color {
                                            loops: 1
                                            ColorAnimation { to: "#666666"; duration: 200; easing.type: Easing.InOutQuad }
                                            alwaysRunToEnd: true
                                        }
                                        SequentialAnimation on color {
                                            running: startButton.pressed
                                            loops: 1
                                            ColorAnimation { to: "#14148c"; duration: 200; easing.type: Easing.InOutQuad }
                                            ColorAnimation { to: "#666666"; duration: 200; easing.type: Easing.InOutQuad }
                                            alwaysRunToEnd: true
                                        }

                                    }

                                    GradientStop {
                                        position: 1.0
                                        SequentialAnimation on color {
                                            loops: 1
                                            ColorAnimation { to: "#262626"; duration: 200; easing.type: Easing.InOutQuad }
                                            alwaysRunToEnd: true
                                        }
                                        SequentialAnimation on color {
                                            running: startButton.pressed
                                            loops: 1
                                            ColorAnimation { to: "#14aaff"; duration: 200; easing.type: Easing.InOutQuad }
                                            ColorAnimation { to: "#262626"; duration: 200; easing.type: Easing.InOutQuad }
                                            alwaysRunToEnd: true
                                        }
                                    }
                                }

                            }

                            onClicked: {
                                RDMBench.startButtonPressed(true)
                                startButton.checked ? video.pause() : video.play()
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



            }
        }

        Item {
            id: clusterContainer
            y: 348
            height: width*0.375
            anchors.rightMargin: parent.width * 0.02
            anchors.right: parent.right
            anchors.leftMargin: parent.width * 0.02
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: clusterBackground
                anchors.fill: parent
                source: "../images/DIS_stealth_turn_np.png"
                fillMode: Image.PreserveAspectFit
                z: -2
            }

            DropShadow {
                anchors.fill: clusterBackground
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                samples: 17
                color: "#80000000"
                cached: true
                source: clusterBackground
            }


            Item {
                id: gaugeContainer
                x: 121
                y: 84
                width: clusterContainer.width * 0.8
                height: clusterContainer.height * 0.7
                anchors.verticalCenterOffset: 10
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                z: 5


                CircularGauge {
                    id: tachometerLeft
                    width: height
                    height: gaugeContainer.height
                    z: 0

                    minimumValue: 0
                    maximumValue: 500
                    anchors.verticalCenter: parent.verticalCenter

                    style: TachometerStyle {
                        showValue: false
                    }

                    Behavior on value {
                        NumberAnimation { duration: 500 }
                    }

                    Connections {
                        target: RDMBench

                        onLeftRPMSignal: {
                            tachometerLeft.value = Math.abs(RDMBench.leftRPM)
                        }

                    }


                    ProgressBar {
                        id: leftTorque
                        height: tachometerLeft.height / 2
                        z: 1
                        anchors.centerIn: parent
                        width: height
                        property real gaugeValue

                        maximumValue: 15
                        minimumValue: -15
                        style: CircularProgressBarStyle {
                            borderWidth: 6
                        }

                        Behavior on gaugeValue {
                            NumberAnimation { duration: 500 }
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
                    height: gaugeContainer.height
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    maximumValue: 500
                    z: 0

                    style: TachometerStyle {
                        showValue: false
                    }

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
                        height: tachometerRight.height / 2
                        z: 1
                        anchors.centerIn: parent
                        width: height
                        property real gaugeValue
                        x: 100
                        y: 100
                        maximumValue: 15
                        minimumValue: -15
                        style: CircularProgressBarStyle {
                            borderWidth: 6
                        }

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

            Image {
                id: videoBackground
                width: clusterContainer.width * 0.45
                height: width * 700 / 1400
                source: "../images/VideoBackground.png"
                anchors.verticalCenterOffset: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Video {
                    id: video
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 30
                    anchors.topMargin: 30
                    anchors.fill: parent
                    source: "../videos/IMG_4581.mp4"
                    autoPlay: true
                    loops: Animation.Infinite
                    muted: true

                }

            }

            //            Rectangle {
            //                id: videoHolder
            //                width: clusterContainer.width * 0.45
            //                height: width * 430 / 1370
            //                color: "#121212"
            //                anchors.verticalCenterOffset: 0
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                anchors.verticalCenter: parent.verticalCenter


            //                Video {
            //                    id: video
            //                    anchors.rightMargin: 5
            //                    anchors.leftMargin: 5
            //                    anchors.bottomMargin: 5
            //                    anchors.topMargin: 5
            //                    anchors.fill: parent
            //                    source: "../videos/IMG_4581.mp4"
            //                    autoPlay: true
            //                    loops: Animation.Infinite


            //                }
            //            }
        }









    }

    Item {
        id: infoContainer
        x: 974
        y: 0
        width: root.width * 0.5
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        SwipeView {
            id: swipeView
            anchors.rightMargin: parent.width * 0.15
            anchors.leftMargin: parent.width * 0.02
            anchors.bottomMargin: parent.height * 0.02
            anchors.topMargin: parent.height * 0.02
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            orientation: Qt.Vertical
            wheelEnabled: true

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
            anchors.rightMargin: parent.width * 0.04
            wheelEnabled: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            scale: 3
            rotation: 90

            count: swipeView.count
            currentIndex: swipeView.currentIndex

        }




        Button {
            id: scrollUpButton
            x: 905
            width: root.width * 0.035
            height: width
            text: "^"
            anchors.rightMargin: parent.width * 0.02
            anchors.topMargin: parent.height * 0.1
            anchors.right: parent.right
            anchors.top: parent.top
            visible: true
            //                focusPolicy: Qt.NoFocus
            //                display: AbstractButton.IconOnly
            //                spacing: 5

            //                background: Rectangle {

            //                    radius: parent.width/2
            //                    color: parent.down ? "#161616" : "#262626"
            //                }

            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    //                            border.color: "#888"
                    radius: control.width/2
                    color: control.pressed ? "#161616" : "#262626"
                    //                            gradient: Gradient {
                    //                                GradientStop { position: 0 ; color: control.pressed ? "#161616" : "#262626" }
                    //                                GradientStop { position: 1 ; color: control.pressed ? "#262626" : "#aaa" }
                    //                            }
                }

                label: Component {
                    Text {
                        text: control.text
                        font.pixelSize: 28
                        color: "#d3d7cf"
                        SequentialAnimation on anchors.topMargin {
                            loops: Animation.Infinite
                            PropertyAnimation { to: 10 }
                            PropertyAnimation { to: 0 }
                        }

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                    }
                }
            }

            onClicked: swipeView.setCurrentIndex(swipeView.currentIndex > 0 ? swipeView.currentIndex-1 : 0)
        }

        Button {
            id: scrollDownButton
            x: 911
            y: 974
            width: root.width * 0.035
            height: width
            text: "^"
            anchors.rightMargin: parent.width * 0.02
            anchors.bottomMargin: parent.height * 0.1
            z: 0
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            opacity: 1
            //                focusPolicy: Qt.NoFocus
            //                display: AbstractButton.IconOnly
            //                spacing: 5

            //                background: Rectangle {
            //                    radius: parent.width/2
            //                    color: parent.down ? "#161616" : "#262626"
            //                }

            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    //                            border.color: "#888"
                    radius: control.width/2
                    color: control.pressed ? "#161616" : "#262626"
                    //                            gradient: Gradient {
                    //                                GradientStop { position: 0 ; color: control.pressed ? "#161616" : "#262626" }
                    //                                GradientStop { position: 1 ; color: control.pressed ? "#262626" : "#aaa" }
                    //                            }
                }

                label: Component {
                    Text {
                        rotation: 180
                        text: control.text
                        font.pixelSize: 22
                        color: "#d3d7cf"
                        SequentialAnimation on anchors.bottomMargin {
                            loops: Animation.Infinite
                            PropertyAnimation { to: 10 }
                            PropertyAnimation { to: 0 }
                        }

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                    }
                }
            }
            onClicked: swipeView.setCurrentIndex(swipeView.currentIndex < 3 ? swipeView.currentIndex+1 : 3)
        }

        DropShadow {
            anchors.fill: scrollUpButton
            horizontalOffset: 0
            verticalOffset: 7
            radius: 8.0
            z: -2
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
            z: -2
            cached: false
            samples: 17
            color: "#80000000"
            source: scrollDownButton
        }

    }
}



















































































































































































/*##^## Designer {
    D{i:3;anchors_height:105.99999999999997;anchors_width:552.9599999999999;anchors_x:320;anchors_y:97}
D{i:4;anchors_height:192;anchors_y:"-213"}D{i:2;anchors_width:900;anchors_x:"-19";anchors_y:"-15"}
D{i:17;anchors_height:529;anchors_width:1014;anchors_x:"-9";anchors_y:"-8"}D{i:16;anchors_width:961;anchors_x:40}
D{i:1;anchors_height:1080}
}
 ##^##*/
