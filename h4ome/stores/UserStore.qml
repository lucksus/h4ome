
/*! Persistence Store
  Everything to access holons in namespaces
*/
pragma Singleton
import QtQuick 2.0
import QuickFlux 1.0
import Qt.labs.settings 1.0
import "../actions"
import "../action_types"
import '../js/lodash.js' as Lodash
import 'qrc:/js/request.js' as HTTP

AppListener {

    readonly property var _: Lodash._

    property bool isLoggedIn: false
    property string jwt
    property bool logging_in: false
    property bool signing_up: false

    signal loggedIn()
    signal signedUp()
    signal loggedOut()
    signal error()


    Component.onCompleted: {
    }


    Filter {
        type: UserActionTypes.login
        onDispatched: {
            var url = API_BASE_URL + "/sessions";
            var params = JSON.stringify({
                email: message.email,
                password: message.password
            })

            logging_in = true
            HTTP.post(url, params, _private.handleLogin, _private.errorLogin)
        }
    }

    Filter {
        type: UserActionTypes.signUp
        onDispatched: {
            var url = API_BASE_URL + "/users";
            var params = JSON.stringify({
                email: message.email,
                username: message.username,
                password: message.password,
                password_confirmation: message.password_confirmation
            })
            signing_up = true
            HTTP.post(url, params, _private.handleSignUp, _private.errorSignUp)
        }
    }

    Filter {
        type: UserActionTypes.logout
        onDispatched: {
            jwt = ''
            loggedOut()
        }
    }

    Settings {
        id: settings
        category: "User"
        property string jwt
        property string email

    }

    QtObject {
        id: _private

        function handleLogin(response) {
            jwt = JSON.parse(response)['data']['jwt']
            logging_in = false
            isLoggedIn = true
            loggedIn()
        }

        function errorLogin(response, status) {
            logging_in = false
            isLoggedIn = false
            error()
        }

        function handleSignUp(response) {
            signing_up = false
            signedUp()
        }

        function errorSignUp(response, status) {
            signing_up = true
            error()
        }
    }
}
