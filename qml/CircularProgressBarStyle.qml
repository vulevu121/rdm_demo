import QtQuick 2.3
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

ProgressBarStyle {
    property real gaugePercent: control.gaugeValue / control.maximumValue


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


                gradient: control.gaugeValue >= 0 ? gradPositive : gradNegative

                Gradient {
                    id: gradPositive
                    GradientStop {
                        position: 0.00
                        color: "yellow"
                    }
                    GradientStop {
                        position: gaugePercent
                        color: "green"
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
                        color: "red"
                    }
                    GradientStop {
                        position: 1.00
                        color: "yellow"
                    }
                }
            }
        }

        Text {
            id: progressLabel
            anchors.centerIn: parent
            color: "white"

            text: (control.gaugeValue).toFixed() + " Nm"
        }
    }
}
