import QtQuick 2.0

Row {
    id: wheelRow
    width: 100
    height: parent.height
    spacing: 1
    property bool forwardDirection: true
    property real duration: 400

    Repeater {
        model: 5

        Rectangle {
            width: wheelRow.width / 5
            height: wheelRow.height
            border.width: 1

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
                        easing.type: Easing.InOutQuad
                    }
                }
            }

        }
    }
}
