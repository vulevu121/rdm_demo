import QtQuick 2.3
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

ProgressBarStyle {
    // if gaugePercent is positive then we ensure the ending position of the gradient do not exceed 1.0, simiarly for negative
    property real gaugePercent: control.gaugeValue >= 0 ? Math.min(control.gaugeValue / control.maximumValue, 0.99) : Math.max(control.gaugeValue / control.maximumValue, -1.00)
    property bool displayValue: true
    property string startColorPos: "yellow"
    property string endColorPos: "green"
    property string startColorNeg: "yellow"
    property string endColorNeg: "red"

    panel: Rectangle {
        color: "transparent"
        implicitWidth: 80
        implicitHeight: implicitWidth

        Rectangle {
            id: outerRing
            z: 0
            anchors.fill: parent
            radius: Math.max(width, height) / 2
            color: "black"
            border.color: "black"
            border.width: 16
        }

        Rectangle {
            id: innerRing
            z: 1
            anchors.fill: parent
            anchors.margins: (outerRing.border.width - border.width) / 2
            radius: outerRing.radius
            color: "transparent"
            border.color: "#101010"
            border.width: 12

            ConicalGradient {
                source: innerRing
                anchors.fill: parent

                Gradient {
                    id: gradPositive
                    GradientStop {
                        position: 0.00
                        color: startColorPos
                    }
                    GradientStop {
                        position: gaugePercent
                        color: endColorPos
                    }
                    GradientStop {
                        position: gaugePercent + 0.01
                        color: "transparent"
                    }
                    GradientStop {
                        position: 1.00
                        color: "transparent"
                    }
                }

                Gradient {
                    id: gradNegative
                    GradientStop {
                        position: 0.00
                        color: "transparent"
                    }
                    GradientStop {
                        position: (1 + gaugePercent)
                        color: "transparent"
                    }
                    GradientStop {
                        position: (1 + gaugePercent + 0.01)
                        color: endColorNeg
                    }
                    GradientStop {
                        position: 1.00
                        color: startColorNeg
                    }
                }

                gradient: control.gaugeValue >= 0 ? gradPositive : gradNegative
            }
        }

        Text {
            id: progressLabel
            visible: displayValue
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 40
            text: (control.gaugeValue).toFixed()
        }


        Text {
            visible: displayValue
            anchors.top: progressLabel.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: 20
            text: "Nm"
        }
    }
}
