TEMPLATE = app

QT += qml quick

INSTALLS += target

SOURCES += src/main.cpp

OTHER_FILES += h4ome.qml \
                ui/*.qml \
                services/*.qml \
                js/*.js

RESOURCES += h4ome.qrc

ios {
    ios_icon.files = $$files($$PWD/ios/AppIcon*.png)
    QMAKE_BUNDLE_DATA += ios_icon
    QMAKE_INFO_PLIST = ios/Info.plist
}

EXAMPLE_FILES += \
    ios
