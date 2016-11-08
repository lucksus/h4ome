import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    property alias text: input.text
    property alias placeholder: input.placeholderText
    property alias echoMode: input.echoMode

    width: Math.round(parent.width / 1.2)

    TextField {
        id: input
        //color: "white"
        width: parent.width
        style: TextFieldStyle {
            textColor: "white"
            placeholderTextColor: "gray"
            background:  Rectangle {
                border.color: "gray"
                border.width: 0
                color: "transparent"
           }
        }
    }

    Rectangle {
        anchors.top: input.bottom
        width: parent.width
        height: 1
        color: "gray"
    }
}
