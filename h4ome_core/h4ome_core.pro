TEMPLATE = lib
CONFIG += staticlib
QT += network qml

SOURCES += src/holonstorage.cpp \
    src/holonruntime.cpp \
    src/environment.cpp \
    src/mutableholon.cpp \
    src/Promise.cpp



QMAKE_MAC_SDK = macosx10.12

HEADERS += \
    src/holonstorage.h \
    src/api_constants.h \
    src/h4omepersistanceprovider.h \
    src/holon.h \
    src/holonruntime.h \
    src/environment.h \
    src/mutableholon.h \
    src/Promise.h
