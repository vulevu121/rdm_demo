import QtQuick 2.0
Item {
    id: wheelContainer
    width: 100
    height: 300
    property bool forwardDirection: true
    property real duration: 600
    property real wheelChevronOpacity: 0.7
    property bool running: false
    
    function restartAnimation() {
        wheelRow.restartAnimation()
    }
    
    
//    Column {
//        id: chevronColumn
//        width: parent.width
//        spacing: -80
//        z: 2
//        property real opacityMain: 1.0
        
//        SequentialAnimation on opacityMain {
//            loops: Animation.Infinite
//            PropertyAnimation {
//                to: 0.0
//                duration: 200
//                easing.type: Easing.InOutSine
//            }
//            PropertyAnimation {
//                to: 0.8
//                duration: 200
//                easing.type: Easing.InOutSine
//            }
//            PropertyAnimation {
//                to: 0.0
//                duration: 200
//                easing.type: Easing.InOutSine
//            }
            
//        }
        
//        Image {
//            width: parent.width
//            source: "../images/chevronup.png"
//            opacity: chevronColumn.opacityMain
//        }
        
//        Image {
//            width: parent.width
//            source: "../images/chevronup.png"
//            opacity: chevronColumn.opacityMain+0.3
//        }
        
//        Image {
//            width: parent.width
//            source: "../images/chevronup.png"
//            opacity: chevronColumn.opacityMain+0.5
//        }
//    }

    Row {
        id: wheelRow
        width: parent.width
        height: parent.height
        spacing: 1
        
        function restartAnimation() {
            repeater.restartAnimation()
        }
    
        Repeater {
            id: repeater
            model: 5
            x: 0
            y: 0
            
            function restartAnimation() {
                singleTread.restartAnimation()
            }
    
            Rectangle {
                id: singleTread
                width: wheelContainer.width / 5
                height: wheelContainer.height
                border.width: 1
                radius: width / 4
                
                function restartAnimation() {
                    wheelStripe.restartAnimation()
                }
    
                gradient: Gradient {
                    GradientStop {position: 0.0 ; color: "#666666"}
                    GradientStop {position: 0.1 ; color: "black"}
                    GradientStop {position: 0.5 ; color: "#666666"}
                    GradientStop {position: 1.0 ; color: "black"}
                }
                
                Image {
                    id: wheelStripe
                    width: wheelContainer.width / 5
                    height: width / 2
                    opacity: 0.5
                    source: "../images/chevronup.png"
                    rotation: wheelContainer.forwardDirection ? 0 : 180
                    z: 2
                    
                    function restartAnimation() {
                        pAnimation.restart()
                    }
                    
                    ParallelAnimation {
                        id: pAnimation
                        loops: Animation.Infinite
                        running: wheelContainer.running
                        alwaysRunToEnd: true
                        
                        PropertyAnimation {
                            target: wheelStripe
                            property: "y"
                            from: wheelContainer.forwardDirection ? wheelContainer.height - wheelStripe.height : 0
                            to: wheelContainer.forwardDirection ? 0 : wheelContainer.height - wheelStripe.height
                            duration: wheelContainer.duration
                            easing.type: Easing.InOutSine
                        }
                        
                        PropertyAnimation {
                            target: wheelStripe
                            property: "opacity"
                            from: 0
                            to: wheelContainer.wheelChevronOpacity
                            duration: wheelContainer.duration
                            easing.type: Easing.InOutSine
                        }
                        
                    }
                }
            }
        }
    }
}











































































/*##^## Designer {
    D{i:0;height:300;width:100}
}
 ##^##*/
