import QtQuick 2.0
Item {
    id: wheelContainer
    width: 100
    height: 300
    property bool forwardDirection: true
    property real duration: 1800
    property real wheelChevronOpacity: 0.7
    property bool running: false

    Column {
        id: chevronColumn
        width: parent.width
        height: parent.height
        visible: wheelContainer.running
        z: 2
        
        SequentialAnimation on opacity { // fading effect for triple chevrons
            loops: Animation.Infinite
            running: wheelContainer.running
            PropertyAnimation {
                to: 0.0
                duration: wheelContainer.duration / 3
            }
            PropertyAnimation {
                to: 0.6
                duration: wheelContainer.duration / 3
            }
            PropertyAnimation {
                to: 0.0
                duration: wheelContainer.duration / 3
            }
        }
        
        Image {
            rotation: wheelContainer.forwardDirection ? 0 : 180
            width: parent.width
            height: parent.height
            source: "../images/chevronuptriple.png"
        }
        


    }

    Row {
        id: wheelRow
        width: parent.width
        height: parent.height
        spacing: 1
        
        
        Repeater {
            id: rowRepeater
            model: 5
            x: 0
            y: 0
         
            Rectangle {
                id: singleTread
                width: wheelContainer.width / 5
                height: wheelContainer.height
                border.width: 1
                radius: width / 4
    
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
                    sourceSize.height: 32
                    sourceSize.width: 32
                    opacity: 0.5
                    source: "../images/chevronup.png"
                    rotation: wheelContainer.forwardDirection ? 0 : 180
                    z: 2
                    visible: wheelContainer.running
                    
                    ParallelAnimation {
                        id: forwardAnimation
                        loops: Animation.Infinite
                        running: wheelContainer.forwardDirection
                        alwaysRunToEnd: true
                        
                        PropertyAnimation {
                            target: wheelStripe
                            property: "y"
                            from: wheelContainer.height - wheelStripe.height
                            to: 0
                            duration: wheelContainer.duration
                            easing.type: Easing.InOutSine
                            
                        }
                        
                        PropertyAnimation {
                            target: wheelStripe
                            property: "opacity"
                            from: wheelContainer.wheelChevronOpacity
                            to: 0
                            duration: wheelContainer.duration
                            easing.type: Easing.InOutSine
                        }
                       
                    }
                    
                    ParallelAnimation {
                        id: reverseAnimation
                        loops: Animation.Infinite
                        running: !wheelContainer.forwardDirection
                        alwaysRunToEnd: true
                        
                        PropertyAnimation {
                            target: wheelStripe
                            property: "y"
                            from: 0
                            to: wheelContainer.height - wheelStripe.height
                            duration: wheelContainer.duration
                            easing.type: Easing.InOutSine
                        }
                        
                        
                        PropertyAnimation {
                            target: wheelStripe
                            property: "opacity"
                            from: wheelContainer.wheelChevronOpacity
                            to: 0
                            duration: wheelContainer.duration
                            easing.type: Easing.InOutSine
                        }
                    }
                }
            }
        }
    }
}














































































