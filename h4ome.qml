import QtQuick 2.6
import QtQuick 2.0

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import QtQuick.Controls.Styles 1.3

import QtQuick.Dialogs 1.2
import 'services/'
import 'ui/'

ApplicationWindow {
    id: window
    title: qsTr("H⁴OME")
    visible: true
    color: "black"

    header: Rectangle {
            color: Qt.rgba(0,0,0,0.75)
            width: parent.width
            height: 50
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
                    color: "white"
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
        width: Math.min(window.width, window.height) / 2
        height: window.height

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

    Popup {
        id: messageDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2

        Column {
            id: messageDialogColumn
            spacing: 20

            Label {
                text: "Holon data received!"
                font.bold: true
            }

            Label {
                id: popupLabel
                width: messageDialog.availableWidth
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }

        function show(holarchy) {
            popupLabel.text = 'Got ' + holarchy.holons.length + ' holons and ' +
                    holarchy.links.length + ' links from Noomap!';
            messageDialog.open();
        }
    }

    Holarchy {
        id: holarchy
        onLoaded: messageDialog.show(holarchy)
    }

    //NoomapInterface {
    Noomap3DInterface {
        id: noomap_interface
        holarchy: holarchy
        anchors.fill: parent
    }

    Component.onCompleted: {
      //  holarchy.loadHolon('me.lucksus');
        var test_holon = {
            _holon_title: 'Test Holon',
            _holon_nodes: {
                'peter': 'asdfasdswe23tASD24tFQ@#$TASDFASFAWETQ@#R'
            }
        }

        var hash = HolonStorage.put(JSON.stringify(test_holon))
        console.log(hash)

        var holon = HolonStorage.get_sync(hash);
        console.log(holon);
    }

}
