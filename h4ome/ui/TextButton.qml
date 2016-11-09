import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Button {
    id: textButton
    property string text
    property string color

    style: ButtonStyle{
        label: Text {
            color: textButton.color ? textButton.color : 'white'
            text: textButton.text
            font.underline: true
        }
        background: Item {}
    }
}
