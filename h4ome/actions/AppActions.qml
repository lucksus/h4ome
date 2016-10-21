pragma Singleton
import QtQuick 2.0
import QuickFlux 1.0
import "../action_types"

QtObject {

    // Add a new message
    function message(content) {
        AppDispatcher.dispatch(AppActionTypes.addMessage,__message(content));
    }

    // Add a new error message
    function error(content) {
        AppDispatcher.dispatch(AppActionTypes.addError,__message(content));
    }

    // Add a new debug message
    function debug(content) {
        AppDispatcher.dispatch(AppActionTypes.addDebugMessage,__message(content));
    }

    function __message(content) {
        return {
            content: content,
            date: new Date()
        }
    }


}
