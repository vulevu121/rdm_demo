
import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Window 2.0


Window {
    id: root
    visible: true
    width: 1500
    height: 800

    Video {
        id: video
        width: 1370*0.5
        height: 430*0.5
        autoPlay: true
        source: "../videos/IMG_4581.mp4" // Point this to a suitable video file
    }



}


