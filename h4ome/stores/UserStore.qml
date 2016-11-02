
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

    signal loggedIn(string email)
    signal signedUp(string email)
    signal loggedOut()
    signal error(string message)


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
            HTTP.post(url, params, _private.handleLogin(message.email), _private.errorLogin(message.email))
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
            HTTP.post(url, params, _private.handleSignUp(message.email), _private.errorSignUp(message.email))
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

        function handleLogin(email) {
            return function(response) {
                jwt = JSON.parse(response)['data']['jwt']
                logging_in = false
                isLoggedIn = true
                loggedIn(email)
            }
        }

        function errorLogin(login){
            return function(response, status) {
                logging_in = false
                isLoggedIn = false
                error('Login failed with "' + login + '"')
            }
        }

        function handleSignUp(email){
            return function(response) {
                signing_up = false
                signedUp(email)
            }
        }

        function errorSignUp(email) {
            return function(response, status) {
                signing_up = false
                error('Sign up failed for "' + email + '" with: ' + response)
            }
        }
    }
}
