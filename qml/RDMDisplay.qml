import QtQuick 2.0

Item {
    id: container
    property real imageIndex: 0
    
    Image {
        id: rdmDark
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewAllDark.png"
        z: -1
    }
    
    Image {
        id: rdmClear
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewAllClear.png"
        visible: imageIndex == 0
        z: 1
    }
    
    Image {
        id: inverter
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewInverterClear.png"
        visible: imageIndex == 1
        z: 1
    }
    
    Image {
        id: motor
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewMotorClear.png"
        visible: imageIndex == 2
        z: 1
    }
    
    Image {
        id: gearbox
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewGearBoxClear.png"
        visible: imageIndex == 3
        z: 1
    }
    
    
}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
