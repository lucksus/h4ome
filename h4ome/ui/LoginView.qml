import QtQuick 2.0
import QtGraphicalEffects 1.0
import '../stores/'
import '../actions'

Rectangle {
    color: "#40484f"

    state: "splash"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: emailEdit
                opacity: 1
            }
            PropertyChanges {
                target: passwordEdit
                opacity: 1
            }
            PropertyChanges {
                target: loginButton
                opacity: 1
            }
        }
    ]


    Timer {
         interval: 1; running: true; repeat: false
         onTriggered: {
             splash.opacity = 1
             splash_blur.opacity = 1
         }
    }
    Timer {
         interval: 1000; running: true; repeat: false
         onTriggered: state = "normal"
    }

    Image {
        id: splash
        x: 89
        width: parent.width
        height: width/200*128
        anchors.horizontalCenterOffset: 9
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: "/h4ome-splash.png"
        sourceSize.width: width*3
        sourceSize.height: height*3
        opacity: 0
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.InQuart; duration: 1500 }
        }
    }

    FastBlur {
       id: splash_blur
       anchors.fill: splash
       source: splash
       radius: 64
       transparentBorder: true
       opacity: 0
       Behavior on radius {
           NumberAnimation { easing.type: Easing.OutCubic; duration: 1500 }
       }
    }


    Input {
        id: emailEdit
        placeholder: qsTr("Email or Username")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -Math.round(parent.height / 25.0)
        opacity: 0
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.InOutQuad; duration: 1500 }
        }
    }


    Input {
        id: passwordEdit
        placeholder: qsTr("Password")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: +Math.round(parent.height / 25.0)
        opacity: 0
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.InOutQuad; duration: 1500 }
        }
        echoMode: TextInput.Password
    }

    Text {
        id: loginFailedLabel
        color: "red"
        text: qsTr("Login failed!")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: loginButton.top
        anchors.bottomMargin: Math.round(parent.height / 30.0)
        visible: false

        Connections {
            target: UserStore
            onError: loginFailedLabel.visible = true
        }
    }

    FastBlur {
       id: blur
       anchors.fill: loginFailedLabel
       source: loginFailedLabel
       radius: 64
       transparentBorder: true
       opacity: 0
       Behavior on radius {
           NumberAnimation { easing.type: Easing.OutCubic; duration: 1500 }
       }
    }

    BlueButton {
        id: loginButton
        y: 425
        width: Math.round(parent.width / 1.2)
        height: Math.round(parent.height / 10.0)
        text: qsTr("LOG IN")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.round(parent.height / 10.0)
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: UserActions.login(emailEdit.text, passwordEdit.text)
        opacity: 0
        Behavior on opacity {
            NumberAnimation { easing.type: Easing.InOutQuad; duration: 1500 }
        }
    }

    Keys.onReturnPressed: UserActions.login(emailEdit.text, passwordEdit.text)
}
