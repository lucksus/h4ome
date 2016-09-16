import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import '.'
import 'ui/'

ApplicationWindow {
    title: qsTr("Hello World")
    width: 640
    height: 480

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Load")
                onTriggered: holarchy.loadHolon('me.larky')
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
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
