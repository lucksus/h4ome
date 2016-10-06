import QtQuick 2.0

Item {
    id: namespaceController

    property var namespaces

    //! Interface function to retrieve a holon
    function getHolon(path) {
        var namespace = namespaces.findByPath(path)
        var namespace_holon = namespaces.getHolon(namespace)
        var relative_path = path.substring(namespace.length + 1)
        return HolonStorage.get_sync(namespace_holon._holon_nodes[relative_path])
    }

    //! Interface function to store a holon under a given path
    function saveHolon(path, holon) {
        var hash = HolonStorage.put(JSON.stringify(holon))
        var namespace = namespaces.findByPath(path)
        var relative_path = path.substring(namespace.length + 1)
        namespaces.setEntry(namespace, relative_path, hash)
    }



}
