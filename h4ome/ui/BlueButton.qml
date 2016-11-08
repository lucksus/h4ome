import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Button {
    style: ButtonStyle{
        label: Text{
            color: "white"
            text: loginButton.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
        }
        background: Rectangle{
            id: background
            border.width: 0
            radius: 5
            gradient: Gradient{
                GradientStop {position: loginButton.pressed ? 0.0 : 1.0; color: "#3381b5"}
                GradientStop {position: loginButton.pressed ? 1.0 : 0.0; color: "#398fc8"}
            }
        }
    }

}
