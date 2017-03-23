TEMPLATE = lib
CONFIG += staticlib
QT += network qml

SOURCES += src/holonstorage.cpp \
    src/Promise.cpp



QMAKE_MAC_SDK = macosx10.12

HEADERS += \
    src/holonstorage.h \
    src/api_constants.h \
    src/Promise.h
