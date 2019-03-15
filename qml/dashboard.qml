import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0

Window { //main window
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
    
    
    Item { // left side container for logo, start button, and rdm display
        id: controlContainer
        width: root.width * 0.6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        z: 2
        
        Item { // container for logo, header, and start button
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
            
            
            Item { // container for start button, logo, and circular progress bar
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
                        height: parent.height * 0.7
                        width: height
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: 0
                        z: 1
                        anchors.centerIn: parent
                        property real gaugeValue // property works with negative and positive values
                        x: 100
                        y: 100
                        minimumValue: 0
                        maximumValue: 5

                        style: CircularProgressBarStyle {
                            startColorPos: "black"
                            endColorPos: "red"
                            displayValue: false
                            borderWidth: 10
                        }
                        
                        Behavior on gaugeValue { // smoothing animation for the gauge
                            NumberAnimation {
                                duration: 300
                            }
                        }
                        
                        Connections {
                            target: RDMBench
                            
                            onDemoStageSignal: {
                                stageProgressBar.gaugeValue = RDMBench.demoStage // show current demo stage on circular progress bar
                            }
                        }
                        
                        RoundButton { // start stop button
                            id: startButton
                            height: parent.height * 0.92
                            width: parent.width * 0.92
                            text: "S T A R T"
                            checkable: true
                            font.strikeout: false
                            highlighted: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: startButtonContainer.height * 0.1
                            z: 3
                            
                            background: Rectangle { // background for start stop button
                                radius: startButton.width / 2
                                rotation: -30
//                                border.width: 1
//                                border.color: "#fcff00"
                                gradient: Gradient {
                                    GradientStop { // top part of gradient
                                        position: 0.0
                                        
                                        SequentialAnimation on color { // animation to change colors to stopped state (top)
                                            loops: 1
                                            ColorAnimation {
                                                to: "#262626"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            alwaysRunToEnd: true
                                        }
                                        SequentialAnimation on color { // animation to change colors to started state (top)
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
                                    
                                    GradientStop { // bottom part of gradient
                                        position: 1.0
                                        SequentialAnimation on color { // animation to change colors to stopped state (bottom)
                                            loops: 1
                                            ColorAnimation {
                                                to: "#000000"
                                                duration: 200
                                                easing.type: Easing.InOutQuad
                                            }
                                            alwaysRunToEnd: true
                                        }
                                        SequentialAnimation on color { // animation to change colors to started state (bottom)
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
                            
                            onClicked: { // send start button press signal to python
                                RDMBench.startButtonPressed(true)
                                startButton.checked ? video.play() : video.pause()
                            }
                            
                            Connections { // signal comes back from python to confirm button press
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
        
        Item { // container for instrument cluster
            id: clusterContainer
            height: width * 0.375
            anchors.topMargin: parent.height * 0.02
            anchors.top: karmaContainer.bottom
            anchors.rightMargin: parent.width * 0.02
            anchors.right: parent.right
            anchors.leftMargin: parent.width * 0.02
            anchors.left: parent.left
            
            Image { // geometric cluster background image
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
            
            Item { // container for gauges
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
                
                CircularGauge { // left tachometer
                    id: tachometerLeft
                    width: height
                    height: gaugeContainer.height
                    z: 0
                    
                    minimumValue: 0
                    maximumValue: 500
                    anchors.verticalCenter: parent.verticalCenter
                    
                    style: TachometerStyle {
                        showValue: false
                        gaugeName: langSlider.value == 1 ? "左侧驱动电机" : "LEFT MOTOR"
                    }
                    
                    Behavior on value { // animation to smooth out needle
                        NumberAnimation {
                            duration: 500
                        }
                    }
                    
                    Connections {
                        target: RDMBench
                        
                        onLeftRPMSignal: { // update tachometer value when there is a change in left rpm
                            tachometerLeft.value = Math.abs(RDMBench.leftRPM)
                        }
                    }
                    
                    ProgressBar { // left torque
                        id: leftTorque
                        height: tachometerLeft.height / 2
                        z: 1
                        anchors.centerIn: parent
                        width: height
                        minimumValue: -15
                        maximumValue: 15
                        property real gaugeValue
                        
                        style: CircularProgressBarStyle {
                            borderWidth: 6 // thickness of circular gauge bar
                        }
                        
                        Behavior on gaugeValue { // animation to smooth out circular progress bar
                            NumberAnimation {
                                duration: 500
                            }
                        }
                        
                        Connections {
                            target: RDMBench
                            
                            onLeftTorqueSignal: { // update left torque gauge when there is a change in left torque
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
                        gaugeName: langSlider.value == 1 ? "右侧驱动电机" : "RIGHT MOTOR"
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
            
            Image { // concave background for video
                id: videoBackground
                width: clusterContainer.width * 0.45
                height: width * 700 / 1400
                source: "../images/VideoBackground.png"
                anchors.verticalCenterOffset: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                
                Video { // main energy flow video
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
                    z: 2
                }
                Video { // secondary energy flow video
                    id: video2
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 30
                    anchors.topMargin: 30
                    anchors.fill: parent
                    source: "../videos/IMG_4597.m4v"
                    autoLoad: true
                    loops: Animation.Infinite
                    muted: true
                    z: 1
                }
                
                Timer { // timer to play secondary video when main video is close to finish
                    interval: 2000
                    running: true
                    repeat: true
                    onTriggered: {
                        video.position > 50000 ? video2.play() : video2.pause()
                    }
                        
                }
            }
        }
        
        Item { // container for wheel and rdm display
            id: wheelContainer
            width: parent.width * 0.8
            height: parent.height * 0.35
            anchors.bottomMargin: parent.height * 0.02
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            
            WheelDisplay { // left wheel
                id: wheelLeft
                width: height / 2
                height: rdmFront.height * 0.6
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width * 0.01
                anchors.right: rdmFront.left
            }
            
            WheelDisplay { // right wheel
                id: wheelRight
                width: height / 2
                height: rdmFront.height * 0.6
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width * 0.01
                anchors.left: rdmFront.right

            }
            
            RDMDisplay { // center rdm rdisplay
                id: rdmFront
                width: height * 1280 / 960
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                imageIndex: swipeView.currentIndex
            }
            
            Connections {
                target: RDMBench
                
                onLeftRPMSignal: { // update the left wheel animation based on rpm
                    wheelLeft.forwardDirection = RDMBench.leftRPM > 0
                    wheelLeft.running = Math.abs(RDMBench.leftRPM) > 20
                }
                
                onRightRPMSignal: { // update the right wheel animation based on rpm
                    wheelRight.forwardDirection = RDMBench.rightRPM > 0
                    wheelRight.running = Math.abs(RDMBench.rightRPM) > 20
                }
                
            }
        }
        
        Text {
            id: copyrightText
            x: 1140
            y: 2123
            color: "#777777"
            text: qsTr("© Karma Automotive 2019")
            font.pointSize: 18
            anchors.bottomMargin: 20
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    Item { // right hand side container for information
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
            
            currentIndex: 0
            onCurrentIndexChanged: {
                slideshowTimer.restart()
            }
            
//            MouseArea {
//                width: parent.width
//                height: parent.height
                
//                onClicked: {
//                    slideshowTimer.restart()
//                }
//            }
            
            Item {
                id: page1
                Loader {
                    id: pageLoader1
                    source: langSlider.value == 1 ? "RDM.qml" : "RDM_en.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            Item {
                id: page2
                Loader {
                    id: pageLoader2
                    source: langSlider.value == 1 ? "Inverter.qml" : "Inverter_en.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            Item {
                id: page3
                Loader {
                    id: pageLoader3
                    source: langSlider.value == 1 ? "Motor.qml" : "Motor_en.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            Item {
                id: page4
                Loader {
                    id: pageLoader4
                    source: langSlider.value == 1 ? "Gearbox.qml" : "Gearbox_en.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            
            Item {
                id: page5
                Loader {
                    id: pageLoader5
                    source: langSlider.value == 1 ? "Wheel.qml" : "Wheel_en.qml"
                    width: parent.width
                    height: parent.height
                }
            }
            
            Item {
                id: page6
                Loader {
                    id: pageLoader6
                    source: langSlider.value == 1 ? "Contact.qml" : "Contact_en.qml"
                    width: parent.width
                    height: parent.height
                }
            }
        }
        
        PageIndicator { // dotted indicator for swipeview pages
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
        
        Timer { // timer to cycle through each page
            id: slideshowTimer
            interval: slideshowSlider.value * 1000
            running: true
            repeat: true
            onTriggered: swipeView.setCurrentIndex(
                             swipeView.currentIndex < swipeView.count
                             - 1 ? swipeView.currentIndex + 1 : 0)
        }
        
        Button { // scroll up button for each page
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
                    radius: control.width / 2
                    color: control.pressed ? "#161616" : "#222222"
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
                           swipeView.currentIndex > 0 ? swipeView.currentIndex - 1 : 0) // limit smallest index to 0
        }
        
        Button { // scroll down button for swipeview pages
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
                    radius: control.width / 2
                    color: control.pressed ? "#161616" : "#222222"
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
                           - 1 ? swipeView.currentIndex + 1 : swipeView.count - 1) // limit largest index to number of pages
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
        
        CustomSlider { // slider for slide show timer
            id: slideshowSlider
            height: parent.height * 0.2
            grooveThickness: parent.width * 0.02
            tickmarksEnabled: false
            handleSize: parent.width * 0.04
            updateValueWhileDragging: true
            stepSize: 1
            anchors.topMargin: parent.height * 0.1
            anchors.top: pageIndicator.bottom
            anchors.horizontalCenter: pageIndicator.horizontalCenter
            minimumValue: 3
            value: 20
            maximumValue: 60
            orientation: Qt.Vertical
            z: 2
            
            Text {
                text: qsTr("Page\nTimer")
                anchors.top: parent.bottom
                anchors.topMargin: font.pixelSize * 0.5
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: slideshowSlider.handleSize * 0.5
            }
        }
        
        
        Slider { // language selection slider
            id: langSlider
            stepSize: 1
            minimumValue: 0
            orientation: Qt.Vertical
            anchors.horizontalCenter: pageIndicator.horizontalCenter
            value: 1
            height: parent.height * 0.05
            anchors.bottomMargin: parent.height * 0.2
            anchors.bottom: pageIndicator.top
            property real handleSize: parent.width * 0.04
            property real grooveThickness: parent.width * 0.02
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    langSlider.value = langSlider.value == 1 ? 0 : 1
                }
            }
            
            Text {
                text: qsTr("中文")
                anchors.bottomMargin: font.pixelSize * 0.5
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.pixelSize: langSlider.handleSize / 2
            }
            
            Text {
                text: qsTr("EN")
                anchors.topMargin: font.pixelSize * 0.5
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.pixelSize: langSlider.handleSize / 2
            }
            
            style: SliderStyle {
                handle: Item {
                    width: control.handleSize
                    height: control.handleSize
        
                    Rectangle {
                        id: sliderHandle
                        implicitWidth: control.handleSize
                        implicitHeight: control.handleSize
                        radius: implicitWidth / 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#555"
                    }
                }
                groove: Rectangle {
                    implicitHeight: control.grooveThickness
                    implicitWidth: parent.width
                    radius: implicitHeight / 2
                    border.color: "#333"
                    color: "#111"
//                    Rectangle {
//                        implicitHeight: parent.height
//                        implicitWidth: styleData.handlePosition
//                        radius: implicitHeight / 2
//                        color: "#555"
//                    }
                }
            }
        }
    }
}
















