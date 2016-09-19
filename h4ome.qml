import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0

import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import 'services/'
import 'ui/'



ApplicationWindow {
    title: qsTr("H4OME")
    visible: true
    width: (Qt.platform.os == "linux" || Qt.platform.os == "osx" ) ? 640 : undefined
    height: (Qt.platform.os == "linux" || Qt.platform.os == "osx" ) ? 480 : undefined

    header: ToolBar {
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/drawer.png"
                }
                onClicked: drawer.open()
            }

            Label {
                id: titleLabel
                text: title
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: qsTr("Load ~me.larky")
                        onTriggered: holarchy.loadHolon('me.larky')
                    }
                    MenuItem {
                        text: qsTr("Exit")
                        onTriggered: Qt.quit();
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: Math.min(parent.width, parent.height) / 2.5
        height: parent.height

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        holarchy.loadHolon(model.name)
                    }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "/home/nico"; name: "me.lucksus" }
                ListElement { title: "/home/chris"; name: "me.larky" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(holarchy) {
            messageDialog.text = 'Got ' + holarchy.holons.length + ' holons and ' +
                    holarchy.links.length + ' links!';
            messageDialog.open();
        }
    }

    Holarchy {
        id: holarchy
        onLoaded: messageDialog.show(holarchy)
    }

    NoomapInterface {
        id: noomap_interface
        holarchy: holarchy
        anchors.fill: parent
    }

    Component.onCompleted: {
        holarchy.loadHolon('me.lucksus')
    }
}
