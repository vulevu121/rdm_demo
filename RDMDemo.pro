TEMPLATE = app
TARGET = dashboard
INCLUDEPATH += .
QT += quick

SOURCES += \
    main.cpp \
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
