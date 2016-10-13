TEMPLATE = app

QT += qml quick quickcontrols2

INSTALLS += target

SOURCES += src/main.cpp \
    src/holonstorage.cpp

OTHER_FILES += h4ome.qml \
                ui/*.qml \
                services/*.qml \
                js/*.js \
                actions/*.qml \
                stores/*.qml


RESOURCES += h4ome.qrc

ios {
    ios_icon.files = $$files($$PWD/ios/AppIcon*.png)
    QMAKE_BUNDLE_DATA += ios_icon
    QMAKE_INFO_PLIST = ios/Info.plist
}

EXAMPLE_FILES += \
    ios

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    noomap.js \
    seeds/*

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
QMAKE_MAC_SDK = macosx10.12

HEADERS += \
    src/holonstorage.h

include(vendor/vendor.pri)
