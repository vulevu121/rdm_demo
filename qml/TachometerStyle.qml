

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
import QtQuick 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

DashboardGaugeStyle {
    id: tachometerStyle
    tickmarkStepSize: 100
    labelStepSize: 100
    needleLength: toPixels(0.85)
    needleBaseWidth: toPixels(0.08)
    needleTipWidth: toPixels(0.03)
    labelInset: toPixels(0.3)

    property string gaugeName: ""

    minorTickmark: Rectangle {
        implicitWidth: toPixels(0.01)
        antialiasing: true
        implicitHeight: toPixels(0.1)
//        color: "#c8c8c8"
        gradient: Gradient {
            GradientStop{ position: 0.0; color: "#c8c8c8" }
            GradientStop{ position: 1.0; color: "black" }
        }
    }

    tickmark: Rectangle {
        implicitWidth: toPixels(0.02)
        antialiasing: true
        implicitHeight: toPixels(0.2)
//        color: "#c8c8c8"
        gradient: Gradient {
            GradientStop{ position: 0.0; color: "#83bbde" }
            GradientStop{ position: 1.0; color: "black" }
        }
    }

    tickmarkLabel: Text {
        font.pixelSize: Math.max(6, toPixels(0.12))
        text: styleData.value
        color: "#c8c8c8"
        antialiasing: true
    }



    background: Canvas {
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            paintBackground(ctx)

            // the redline warning strip
            ctx.beginPath()
            ctx.lineWidth = tachometerStyle.toPixels(0.08)
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.3)
            var warningCircumference = maximumValueAngle - minimumValueAngle * 0.1
            var startAngle = maximumValueAngle - 90
            ctx.arc(outerRadius, outerRadius,
                    // Start the line in from the decorations, and account for the width of the line itself.
                    outerRadius - tickmarkInset - ctx.lineWidth / 2, degToRad(
                        startAngle - angleRange / 8 + angleRange * 0.015), degToRad(
                        startAngle - angleRange * 0.015), false)
            ctx.stroke()
        }

        Text {
            text: "RPM"
            color: "white"
            font.pixelSize: tachometerStyle.toPixels(0.1)
            anchors.bottom: gaugeNameText.top
            anchors.bottomMargin: font.pixelSize * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: gaugeNameText
            text: gaugeName
            color: "white"
            font.pixelSize: tachometerStyle.toPixels(0.1)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: font.pixelSize * 0.8
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
