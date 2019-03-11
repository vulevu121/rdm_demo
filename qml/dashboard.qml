import QtQuick 2.0
import QtQuick.Window 2.2
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
    visibility: Window.FullScreen
    color: "#262626"
    title: "RDM Demo"
    width: 3840
    height: 2160
    
    
    //    Text {
    //        id: name
    //        width: 33
    //        height: 25
    //        color: "#ffffff"
    //        text: "Pixel Ratio: " + Screen.devicePixelRatio + "\nPixel Density: " + Screen.pixelDensity
    //    }
    
    Item {
        id: controlContainer
        width: root.width * 0.6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        z: 2
        
        Item {
            id: karmaContainer
            width: parent.width * 0.7
            height: parent.height * 0.18
            anchors.topMargin: parent.height * 0.03
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            
            Image {
                id: karmaHeader
                height: logoImage.height * 0.3
                anchors.leftMargin: parent.width * 0.08
                anchors.right: parent.right
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                sourceSize.height: 109
                sourceSize.width: 695
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.left: startButtonContainer.right
                source: "../images/karma-logo-header.png"
                fillMode: Image.PreserveAspectFit
            }
            
            DropShadow {
                anchors.fill: karmaHeader
                horizontalOffset: 0
                verticalOffset: 7
                radius: 8.0
                cached: true
                samples: 17
                color: "#80000000"
                source: karmaHeader
            }
            
            
            Item {
                id: startButtonContainer
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
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
                            startColorPos: "black"
                            endColorPos: "red"
                            displayValue: false
                            borderWidth: 10
                        }
                        
                        Behavior on gaugeValue {
                            NumberAnimation {
                                duration: 300
                            }
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
                            highlighted: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: startButtonContainer.height * 0.1
                            z: 3
                            
                            background: Rectangle {
                                radius: startButton.width / 2
                                rotation: -30
                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        
                                        SequentialAnimation on color {
                                            loops: 1
                                            ColorAnimation {
                                                to: "#262626"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            alwaysRunToEnd: true
                                        }
                                        SequentialAnimation on color {
                                            running: startButton.pressed
                                            loops: 1
                                            ColorAnimation {
                                                to: "#0504a9"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            ColorAnimation {
                                                to: startButton.checked ? "#262626" : "#0504a9"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            alwaysRunToEnd: true
                                        }
                                    }
                                    
                                    GradientStop {
                                        position: 1.0
                                        SequentialAnimation on color {
                                            loops: 1
                                            ColorAnimation {
                                                to: "#000000"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            alwaysRunToEnd: true
                                        }
                                        SequentialAnimation on color {
                                            running: startButton.pressed
                                            loops: 1
                                            ColorAnimation {
                                                to: "black"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            ColorAnimation {
                                                to: startButton.checked ? "#000000" : "#black"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            alwaysRunToEnd: true
                                        }
                                    }
                                }
                            }
                            
                            onClicked: {
                                RDMBench.startButtonPressed(true)
                                startButton.checked ? video.play() : video.pause()
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
            height: width * 0.375
            anchors.topMargin: parent.height * 0.02
            anchors.top: karmaContainer.bottom
            anchors.rightMargin: parent.width * 0.02
            anchors.right: parent.right
            anchors.leftMargin: parent.width * 0.02
            anchors.left: parent.left
            
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
                z: -2
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
                height: clusterContainer.height * 0.75
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
                        gaugeName: "LEFT MOTOR"
                    }
                    
                    Behavior on value {
                        NumberAnimation {
                            duration: 500
                        }
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
                            NumberAnimation {
                                duration: 500
                            }
                        }
                        
                        Connections {
                            target: RDMBench
                            
                            onLeftTorqueSignal: {
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
                    z: -2
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
                        gaugeName: "RIGHT MOTOR"
                    }
                    
                    Behavior on value {
                        NumberAnimation {
                            duration: 300
                        }
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
                            NumberAnimation {
                                duration: 300
                            }
                        }
                        
                        Connections {
                            target: RDMBench
                            
                            onRightTorqueSignal: {
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
                    z: -2
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
                    source: "../videos/IMG_4597.m4v"
                    autoLoad: true
                    loops: Animation.Infinite
                    muted: true
                }
            }
        }
        
        Item {
            id: wheelContainer
            width: parent.width * 0.8
            height: parent.height * 0.35
            anchors.bottomMargin: parent.height * 0.02
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            
            WheelDisplay {
                id: wheelLeft
                width: height / 2
                height: Screen.height * 0.2
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width * 0.01
                anchors.right: rdmFront.left
                duration: slider1.value
            }
            
            WheelDisplay {
                id: wheelRight
                width: height / 2
                height: Screen.height * 0.2
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width * 0.01
                anchors.left: rdmFront.right
                duration: slider2.value
            }
            
            RDMDisplay {
                id: rdmFront
                width: height * 1280 / 960
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                imageIndex: swipeView.currentIndex
                
                Slider {
                    id: slider1
                    visible: false
                    stepSize: 100
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.left: parent.left
                    value: 500
                    minimumValue: 500
                    maximumValue: 2000
                }
                
                Slider {
                    id: slider2
                    y: 0
                    visible: false
                    stepSize: 100
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    value: 500
                    minimumValue: 500
                    maximumValue: 2000

                }
            }
            
            Connections {
                target: RDMBench
                
                onLeftRPMSignal: {
                    wheelLeft.forwardDirection = RDMBench.leftRPM > 0
                    wheelLeft.running = Math.abs(RDMBench.leftRPM) > 10
                    wheelLeft.duration = 2000 - Math.abs(RDMBench.leftRPM)*3
                }
                
                onRightRPMSignal: {
                    wheelRight.forwardDirection = RDMBench.rightRPM > 0
                    wheelRight.running = Math.abs(RDMBench.rightRPM) > 10
                    wheelRight.duration = 2000 - Math.abs(RDMBench.rightRPM)*3
                }
                
                
            }
        }
    }
    
    Item {
        id: infoContainer
        x: 974
        y: 0
        width: root.width * 0.4
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
            
            currentIndex: 3
            
            Item {
                id: page1
                Loader {
                    id: pageLoader1
                    source: "RDM.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            Item {
                id: page2
                Loader {
                    id: pageLoader2
                    source: "Inverter.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            Item {
                id: page3
                Loader {
                    id: pageLoader3
                    source: "Motor.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            Item {
                id: page4
                Loader {
                    id: pageLoader4
                    source: "Gearbox.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            
            Item {
                id: page5
                Loader {
                    id: pageLoader5
                    source: "Wheel.qml"
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
        
        Timer {
            interval: slider.value * 1000
            running: true
            repeat: true
            onTriggered: swipeView.setCurrentIndex(
                             swipeView.currentIndex < swipeView.count
                             - 1 ? swipeView.currentIndex + 1 : 0)
        }
        
        Button {
            id: scrollUpButton
            x: 905
            width: root.width * 0.035
            height: width
            text: "^"
            anchors.horizontalCenter: pageIndicator.horizontalCenter
            anchors.topMargin: parent.height * 0.05
            anchors.top: parent.top
            visible: true
            
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    //                            border.color: "#888"
                    radius: control.width / 2
                    color: control.pressed ? "#161616" : "#262626"
                }
                
                label: Component {
                    id: component
                    Text {
                        text: control.text
                        font.pointSize: 28
                        color: "#d3d7cf"
                        SequentialAnimation on anchors.topMargin {
                            loops: Animation.Infinite
                            PropertyAnimation {
                                to: 0
                            }
                            PropertyAnimation {
                                to: 10
                            }
                        }
                        
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                    }
                }
            }
            
            onClicked: swipeView.setCurrentIndex(
                           swipeView.currentIndex > 0 ? swipeView.currentIndex - 1 : 0)
        }
        
        Button {
            id: scrollDownButton
            x: 911
            y: 974
            width: root.width * 0.035
            height: width
            text: "^"
            anchors.horizontalCenter: pageIndicator.horizontalCenter
            anchors.bottomMargin: parent.height * 0.05
            z: 0
            anchors.bottom: parent.bottom
            opacity: 1
            
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    //                            border.color: "#888"
                    radius: control.width / 2
                    color: control.pressed ? "#161616" : "#262626"
                }
                
                label: Component {
                    Text {
                        rotation: 180
                        text: control.text
                        font.pointSize: 28
                        color: "#d3d7cf"
                        SequentialAnimation on anchors.bottomMargin {
                            loops: Animation.Infinite
                            PropertyAnimation {
                                to: 10
                            }
                            PropertyAnimation {
                                to: 0
                            }
                        }
                        
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                    }
                }
            }
            onClicked: swipeView.setCurrentIndex(
                           swipeView.currentIndex < swipeView.count
                           - 1 ? swipeView.currentIndex + 1 : swipeView.count - 1)
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
        
        CustomSlider {
            id: slider
            height: parent.height * 0.2
            grooveThickness: 10
            tickmarksEnabled: false
            handleSize: parent.width * 0.05
            updateValueWhileDragging: true
            stepSize: 1
            anchors.topMargin: parent.height * 0.15
            anchors.top: pageIndicator.bottom
            anchors.horizontalCenter: pageIndicator.horizontalCenter
            minimumValue: 3
            value: 5
            maximumValue: 60
            orientation: Qt.Vertical
            z: 2
        }
    }
}
























































































































































/*##^## Designer {
    D{i:42;anchors_x:411}
}
 ##^##*/
