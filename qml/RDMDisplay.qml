import QtQuick 2.0

Item {
    id: container
    property real imageIndex: 0
    
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewAll.png"
        
    }
    
    
}
