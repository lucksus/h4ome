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
import 'js/lodash.js' as Lodash

ApplicationWindow {
    id: window
    title: qsTr("H⁴OME")
    visible: true
    color: "black"

    width: (Qt.platform.os == "linux" || Qt.platform.os == "osx" ) ? 334 : ""
    height: (Qt.platform.os == "linux" || Qt.platform.os == "osx" ) ? 560 : ""

    readonly property var _: Lodash._

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
                            id: menuLogout
                            text: qsTr("Logout") + ' ' + UserStore.email
                            onTriggered: UserActions.logout()
                            enabled: UserStore.isLoggedIn
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

    Item {
        id: root_widget
        anchors.fill: parent

        state: UserStore.isLoggedIn ? "MAIN" : "LOGIN"

        states: [
            State {
                name: "LOGIN"
                PropertyChanges {
                    target: loginView
                    visible: true
                }
                PropertyChanges {
                    target: noomap_interface
                    visible: false
                }
            },
            State {
                name: "MAIN"
                PropertyChanges {
                    target: loginView
                    opacity: 0
                }
                PropertyChanges {
                    target: loginView
                    y_shift: 3000
                }
                PropertyChanges {
                    target: noomap_interface
                    visible: true
                }
            }

        ]

        transitions: Transition {
            NumberAnimation {
                target: loginView
                properties: "y_shift"
                duration: 1000
                easing.type: Easing.InSine
            }
            NumberAnimation {
                target: loginView
                properties: "opacity"
                duration: 1500
                easing.type: Easing.InSine
            }
        }

        //NoomapInterface {
        Noomap3DInterface {
            id: noomap_interface
            holarchy: holarchy
            anchors.fill: parent
            visible: false
        }

        LoginView {
            id: loginView
            anchors.fill: parent
            visible: true
            property int angle;
            property int y_shift;
            angle: 0
            y_shift: 0
            transform: Translate {y: loginView.y_shift}
            z: 2
        }

        Label {
            id: downloadingLabel
            text: 'Downloading:'
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: "white"
            visible: HolonStorage.downloading
            z: 10
        }

        ProgressBar {
            id: downloadingProgressBar
            anchors.bottom: parent.bottom
            anchors.left: downloadingLabel.right
            anchors.right: parent.right
            value: HolonStorage.progress_down
            visible: HolonStorage.downloading
            z: 10
        }

        Label {
            id: uploadingLabel
            text: 'Uploading:'
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: HolonStorage.downloading ? downloadingLabel.height : 0
            color: "white"
            visible: HolonStorage.uploading
            z: 10
        }

        ProgressBar {
            anchors.bottom: parent.bottom
            anchors.left: downloadingLabel.right
            anchors.right: parent.right
            anchors.bottomMargin: HolonStorage.downloading ? downloadingLabel.height : 0
            value: HolonStorage.progress_up
            visible: HolonStorage.uploading
            z: 10
        }
    }

    Component.onCompleted: {
        // Initialize namespace holon:
        var namespace_holon = {
            "_holon_title": "Terence McKenna's example namespace",
            "_holon_nodes": {
                "holon1": "Qm5aaf5c00fe1d97edb67d0e0c30496914ba49df11d2630863c695fa83761c367f"},
            "_holon_edges":{}
        }

        var load_hash = HolonStorage.hash(JSON.stringify(namespace_holon))
        var promise = HolonStorage.get(load_hash)
        promise.then(function(string) {
            console.log('got namespace holon via promise: ' + string)
        });

        var holon1 = {"_holon_nodes":{"peter":"asdfasdswe23tASD24tFQ@#$TASDFASFAWETQ@#R"},"_holon_title":"Test Holon"}

        // We save the namespace_holon ...
        var hash_namespace = HolonStorage.put(JSON.stringify(namespace_holon))
        /// and holon1
        var hash_holon1 = HolonStorage.put(JSON.stringify(holon1))
        // and check if the hash is correct
        console.log('check HolonStorage hash: ',
                    hash_holon1 === "Qm5aaf5c00fe1d97edb67d0e0c30496914ba49df11d2630863c695fa83761c367f"
                    )

        // Now we try to get that same holon by providing the hash ...
        HolonStorage.get(hash_holon1).then(function(holon1_string){
            var holon = JSON.parse(holon1_string);
            // and check for equality
            console.log('check HolonStorage.get: ',
                        JSON.stringify(holon) === JSON.stringify(holon1)
                        );
        });

        PersistenceStore.initWithNamespace('/home/terence', hash_namespace)
        console.log('check PersistenceStore.initWithNamespace(): ',
                    PersistenceStore.namespaces['/home/terence'].hash === hash_namespace
                    );
        console.log('check PersistenceStore.holons empty: ',
                    JSON.stringify(PersistenceStore.holons) === JSON.stringify({})
                    );

        PersistenceStore.holonAdded.connect(function(path) {
            if(path == '/home/terence/holon1') {
                var loaded_holon1 = PersistenceStore.holons[path].data
                var loaded_hash = PersistenceStore.holons[path].hash
                console.log('check PersistenceAction.loadHolon: ',
                            JSON.stringify(loaded_holon1) === JSON.stringify(holon1)
                            )
                console.log('check PersistenceAction.loadHolon hash: ',
                            JSON.stringify(loaded_hash) === JSON.stringify(hash_holon1)
                            )
            }
        });
        PersistenceActions.loadHolon('/home/terence/holon1')



        var holon2 = {
            _holon_title: 'My intention'
        }

        PersistenceActions.commitHolon("/home/terence/intention1", holon2)
        PersistenceStore.holonSaved.connect(function(path) {
            if(path == '/home/terence/intention1') {
                var loaded_holon2 = PersistenceStore.holons["/home/terence/intention1"].data
                var loaded_hash2 = PersistenceStore.holons["/home/terence/intention1"].hash
                console.log('check PersistenceAction.commitHolon: ',
                            JSON.stringify(loaded_holon2) === JSON.stringify(holon2)
                            )
            }
        })

        //UserStore.isLoggedIn
        //UserActions.signUp('nicolas@lucksus.eu', 'lucksus', 'blablub123*', 'blablub123*')
        //UserActions.login('nicolas@lucksus.eu', 'blablub123*')

        UserStore.loggedOut.connect(function(){
            console.log('logged out')
            console.log(UserStore.jwt)
        })
        UserStore.loggedIn.connect(function(){
            console.log(UserStore.jwt)
        })
        UserStore.error.connect(function(message){
            console.log('error: ' + message)
        })
    }

}
