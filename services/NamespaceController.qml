import QtQuick 2.0
import Qt.labs.settings 1.0
import '../js/lodash.js' as Lodash

Item {
    id: namespaceController

    //! mapping of strings to IPFS hashes
    //! {
    //!   "/home/terence": "Qmasd3nddn23aefr23ln3wrt"
    //!   ...
    //! }
    property var namespaces
    property var _: Lodash._

    Settings {
        id: settings
        property string namespaces_json
    }

    function init() {
        if (settings.namespaces_json == "{}")
            seed()
        namespaces = JSON.parse(settings.namespaces_json)
    }


    //! Interface function to retrieve a holon
    function getHolon(path) {
        var namespace = findNamespace(path)
        var relative_path = path.substring(namespace.name.length+1)
        return HolonStorage.get_sync(namespace.holon._holon_nodes[relative_path])
    }

    //! Interface function to store a holon under a given path
    function saveHolon(path, holon) {
        var hash = HolonStorage.put(JSON.stringify(holon))
        var namespace = findNamespace(path)
        var relative_path = path.substring(namespace.name.length+1)
        var newNamespace = holonSetNode(namespace.holon, relative_path, hash)
        var newNamespaceHash = HolonStorage.put(JSON.stringify(newNamespace))
        namespaces[namespace.name] = newNamespaceHash
        save()
    }


    // vvvvv private vvvvvv

    function holonSetNode(holon, name, value) {
        var newHolon = holon//_.cloneDeep(holon)
        newHolon._holon_nodes[name] = value
        return newHolon
    }

    function findNamespace(path) {
        var names = Object.keys(namespaces)
        var namespace_name = _.find(names, function(name) { return path.indexOf(name) == 0})
        var holon = JSON.parse(HolonStorage.get_sync(namespaces[namespace_name]))
        return {
            name: namespace_name,
            holon: holon
        }
    }

    function save() {
        settings.namespaces_json = JSON.stringify(namespaces)
    }

    function seed() {
        namespaces = {}
        var seeds = JSON.parse(NAMESPACE_SEEDS)
        for (var namespace_name in seeds) {
            var hash = HolonStorage.put(JSON.stringify(seeds[namespace_name]))
            namespaces[namespace_name] = hash
        }
        save()
    }

    Component.onDestruction: {
        save()
    }
}
