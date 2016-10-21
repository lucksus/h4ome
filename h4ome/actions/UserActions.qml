pragma Singleton
import QtQuick 2.0
import QuickFlux 1.0
import "../action_types"

QtObject {
    // Add a new message
    function login(email, password) {
        AppDispatcher.dispatch(UserActionTypes.login, {email: email, password: password} );
    }

    // Add a new error message
    function signUp(email, username, password, password_confirmation) {
        AppDispatcher.dispatch(UserActionTypes.signUp, {
            email: email,
            username: username,
            password: password,
            password_confirmation: password_confirmation
        });
    }

    // Add a new debug message
    function logout() {
        AppDispatcher.dispatch(UserActionTypes.logout);
    }
}
