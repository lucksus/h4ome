TEMPLATE = lib
CONFIG += staticlib
QT += network qml concurrent

SOURCES += src/holonstorage.cpp \
    src/holonruntime.cpp \
    src/environment.cpp \
    src/mutableholon.cpp \
    src/Promise.cpp \
    src/h4mssessionmanager.cpp \
    src/h4mspersistenceprovider.cpp \
    src/holon.cpp \
    src/h4msnamespaceconnector.cpp



QMAKE_MAC_SDK = macosx10.12

HEADERS += \
    src/holonstorage.h \
    src/api_constants.h \
    src/h4omepersistanceprovider.h \
    src/holon.h \
    src/holonruntime.h \
    src/environment.h \
    src/mutableholon.h \
    src/Promise.h \
    src/h4mssessionmanager.h \
    src/h4mspersistenceprovider.h \
    src/h4msnamespaceconnector.h
