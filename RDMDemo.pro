TEMPLATE = app
TARGET = dashboard
INCLUDEPATH += .
QT += \
    quick \
    multimedia \

SOURCES += \
    main.cpp

RESOURCES += \
    dashboard.qrc

OTHER_FILES += \
    qml/dashboard.qml \
    qml/DashboardGaugeStyle.qml \
    qml/TachometerStyle.qml \

target.path = $$[QT_INSTALL_EXAMPLES]/quickcontrols/extras/dashboard
INSTALLS += target

DISTFILES += \
    qml/CircularProgressBarStyle.qml \
    qml/Gearbox.qml \
    qml/Inverter.qml \
    qml/Motor.qml \
    qml/RDM.qml \
    videos/IMG_4581.mp4 \
    qml/VideoTest.qml \
    qml/Wheel.qml \
    qml/WheelDisplay.qml \
    qml/CustomSlider.qml \
    qml/Gearbox_en.qml \
    qml/Inverter_en.qml \
    qml/Motor_en.qml \
    qml/RDM_en.qml \
    qml/Wheel_en.qml

