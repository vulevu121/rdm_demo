import QtQuick 2.0

Row {
    id: wheelRow
    width: 100
    height: 300
    spacing: 1
    property bool forwardDirection: true
    property real duration: 400

    Repeater {
        model: 5

        Rectangle {
            id: singleTread
            width: wheelRow.width / 5
            height: wheelRow.height
            border.width: 1
            radius: width / 4

            gradient: Gradient {
                GradientStop {position: 0.0 ; color: "#666666"}
                GradientStop {position: 0.1 ; color: "black"}
                GradientStop {position: 0.5 ; color: "#666666"}
                GradientStop {position: 1.0 ; color: "black"}
            }

            Rectangle {
                id: wheelStripe
                width: wheelRow.width / 5
                height: width / 2
                opacity: 0.2
                z: 2

                SequentialAnimation on y {
                    loops: Animation.Infinite
                    PropertyAnimation {
                        from: wheelRow.forwardDirection ? wheelRow.height - wheelStripe.height : 0
                        to: wheelRow.forwardDirection ? 0 : wheelRow.height - wheelStripe.height
                        duration: wheelRow.duration
                        easing.type: Easing.InOutSine
                    }
                }
                
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    PropertyAnimation {
                        to: 0
                        duration: wheelRow.duration / 3
                        easing.type: Easing.InOutSine
                    }
                    PropertyAnimation {
                        to: wheelStripe.opacity
                        duration: wheelRow.duration / 3
                        easing.type: Easing.InOutSine
                    }
                    PropertyAnimation {
                        to: 0
                        duration: wheelRow.duration / 3
                        easing.type: Easing.InOutSine
                    }
                }
            }

        }
    }
}
