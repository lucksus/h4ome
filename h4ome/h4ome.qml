import QtQuick 2.6
import QtQuick 2.0

import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

import QtQuick.Controls.Styles 1.3

import QtQuick.Dialogs 1.2
import 'actions/'
import 'services/'
import 'ui/'
import 'stores/'

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

    NamespacesModel {
        id: namespaces
    }

    NamespaceController {
        id: h4omeFilesystem
        namespaces: namespaces
    }

    Component.onCompleted: {
      //  holarchy.loadHolon('me.lucksus');

        namespaces.init()

        // Initialize namespace holon:
        var namespace_holon = {
            "_holon_title": "Terence McKenna's example namespace",
            "_holon_nodes": {
                "holon1": "Qm5aaf5c00fe1d97edb67d0e0c30496914ba49df11d2630863c695fa83761c367f"},
            "_holon_edges":{}
        }

        // We save the namespace_holon ...
        var hash = HolonStorage.put(JSON.stringify(namespace_holon))
        // ... and display it's hash value.
        console.log(hash)

        // Now we try to get that same holon by providing the hash ...
        var holon = HolonStorage.get_sync(hash);
        // ... and display the result.
        console.log(holon);

        var holon = PersistenceStore.holons["/home/terence"];
        console.log(JSON.stringify(holon));

        var test_holon2 = {
            _holon_title: 'My intention'
        }

        PersistenceActions.commitHolon("/home/terence/intention1", test_holon2)
        holon = PersistenceStore.holons["/home/terence/intention1"]
        console.log(JSON.stringify(holon))


    }

}