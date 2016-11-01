pragma Singleton
import QtQuick 2.0
import QuickFlux 1.0
import "./"

QtObject {

    // Trigger the loading of this holon
    // either from local disk or from HMS or from IPFS
    // interface code should not care
    function loadHolon(h4ome_path) {
        AppDispatcher.dispatch(PersistenceActionTypes.loadHolon, { path: h4ome_path });
    }

    // Trigger saving of the given holon
    // this will save the holon locally and update
    // the corresponding namespace
    function commitHolon(h4ome_path, holon) {
        AppDispatcher.dispatch(PersistenceActionTypes.commitHolon,
            { path: h4ome_path, holon: holon }
        );
    }

    // Upload the given namespace holon to the blockchain or the HMS
    // i.e. publish that namespace
    function pushNamespace(namespace_name) {
        AppDispatcher.dispatch(PersistenceActionTypes.pushNamespace, { namespace: namespace_name });
    }

    // Get (the latest version) of the given namespace from the
    // blockchain or HMS
    function pullNamespace(namespace_name) {
        AppDispatcher.dispatch(PersistenceActionTypes.pullNamespace, { namespace: namespace_name });
    }

    // Create a new local namespace
    function createNamespace(namespace_name, options) {
        AppDispatcher.dispatch(PersistenceActionTypes.createNamespace,
            { namespace: namespace_name, options: options }
        );
    }


}
