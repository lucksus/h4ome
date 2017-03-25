TEMPLATE = app

QT += qml quick quickcontrols2

INSTALLS += target
LIBS += ../h4ome_core/libh4ome_core.a
INCLUDEPATH += ../h4ome_core/src
SOURCES += src/main.cpp \
    src/controller.cpp

HEADERS += \
    src/controller.h
