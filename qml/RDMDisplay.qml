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
        opacity: imageIndex == 0 ? 1.0 : 0.0
        
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
        z: 1
        
        
    }
    
    Image {
        id: inverter
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewInverterClear.png"
        opacity: imageIndex == 1 ? 1.0 : 0.0
        
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
        z: 1
    }
    
    Image {
        id: motor
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewMotorClear.png"
        opacity: imageIndex == 2 ? 1.0 : 0.0
        
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
        z: 1
    }
    
    Image {
        id: gearbox
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/RDMFrontViewGearBoxClear.png"
        opacity: imageIndex == 3 ? 1.0 : 0.0
        
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
        z: 1
    }
    
    
}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
