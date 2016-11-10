import QtQuick 2.0
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.2

import '../stores/'
import '../actions'

Rectangle {
    color: "#40484f"

    state: ""
    states: [
        State {
            name: "LOG_IN"
            PropertyChanges {
                target: loginInputs
                angle: 0
                opacity: 1
                z: 2
            }
            PropertyChanges {
                target: signupInputs
                angle: 180
                opacity: 0
                z: 1
            }
        },

        State {
            name: 'SIGN_UP'
            PropertyChanges {
                target: loginInputs
                angle: 90
                opacity: 0
                z: 1
            }
            PropertyChanges {
                target: signupInputs
                angle: 0
                opacity: 1
                z: 2
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            target: loginInputs
            properties: "angle"
            duration: 1000
            easing.type: Easing.InSine
        }
        NumberAnimation {
            target: loginInputs
            properties: "opacity"
            duration: 500
            easing.type: Easing.InSine
        }
        NumberAnimation {
            target: signupInputs
            properties: "angle"
            duration: 1000
            easing.type: Easing.InSine
        }
        NumberAnimation {
            target: signupInputs
            properties: "opacity"
            duration: 500
            easing.type: Easing.InSine
        }
    }


    Timer {
         interval: 1; running: true; repeat: false
         onTriggered: {
             splash.opacity = 1
             splash_blur.opacity = 1
             loginView.state = 'LOG_IN'
         }
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


    Item {
        id: loginInputs
        anchors.fill: parent
        property real angle: 0

        transform: Rotation { origin.x: 0; origin.y: loginView.height/2; axis { x: 0; y: 1; z: 0 } angle: angle }
        opacity: 0

        Input {
            id: emailEdit
            placeholder: qsTr("Email or Username")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onChanged: loginFailedLabel.visible = false
        }


        Input {
            id: passwordEdit
            placeholder: qsTr("Password")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: +Math.round(parent.height / 15.0)
            echoMode: TextInput.Password
            onChanged: loginFailedLabel.visible = false
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
                onLoginFailed: loginFailedLabel.visible = true
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
            enabled: ! UserStore.logging_in
        }

        TextButton {
            text: qsTr("Sign up instead")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Math.round(parent.height / 20.0) - height/2
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: loginView.state = 'SIGN_UP'
        }
    }

    Item {
        id: signupInputs
        anchors.fill: parent
        property real angle: 180

        transform: Rotation { origin.x: 0; origin.y: loginView.height/2; axis { x: 0; y: 1; z: 0 } angle: angle }
        opacity: 0

        Input {
            id: signupEmailEdit
            placeholder: qsTr("Email")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            validationMessage: UserStore.emailValiditionMessage
        }


        Input {
            id: signupUsernameEdit
            placeholder: qsTr("Username")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: +Math.round(parent.height / 15.0)
            validationMessage: UserStore.usernameValidationMessage
        }

        Input {
            id: signupPasswordEdit
            placeholder: qsTr("Password")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: +2*Math.round(parent.height / 15.0)
            validationMessage: UserStore.passwordValidationMessage
            echoMode: TextInput.Password
        }

        Input {
            id: signupPasswordConfirmationEdit
            placeholder: qsTr("Password confirmation")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: +3*Math.round(parent.height / 15.0)
            validationMessage: UserStore.passwordConfirmationValidationMessage
            echoMode: TextInput.Password
        }

        BlueButton {
            id: signUpButton
            y: 425
            width: Math.round(parent.width / 1.2)
            height: Math.round(parent.height / 10.0)
            text: qsTr("SIGN UP")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Math.round(parent.height / 10.0)
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: UserActions.signUp(
              signupEmailEdit.text,
              signupUsernameEdit.text,
              signupPasswordEdit.text,
              signupPasswordConfirmationEdit.text
            )
            enabled: ! UserStore.signing_up
        }

        TextButton {
            text: qsTr("Log in instead")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Math.round(parent.height / 20.0) - height/2
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: loginView.state = 'LOG_IN'
        }
    }



    Keys.onReturnPressed: {
        if(loginView.state == "LOG_IN") UserActions.login(emailEdit.text, passwordEdit.text)
        if(loginView.state == "SIGN_UP") UserActions.signUp(
                                             signupEmailEdit.text,
                                             signupUsernameEdit.text,
                                             signupPasswordEdit.text,
                                             signupPasswordConfirmationEdit.text
                                           )
    }

    Connections {
        target: UserStore
        onSignedUp: UserActions.login(signupEmailEdit.text, signupPasswordEdit.text)
    }
}
