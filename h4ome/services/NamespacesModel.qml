import QtQuick 2.0
import Qt.labs.settings 1.0
import '../js/lodash.js' as Lodash
import '../js/Holon.js' as Holon

Item {
    id: namspacesModel

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
        if (settings.namespaces_json == "{}" || settings.namespaces_json == "")
            seed()
        namespaces = JSON.parse(settings.namespaces_json)
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

    //! Searches for namespace that matches the given path
    //! (i.e. namespace '/home/terence' for path '/home/terence/holon1')
    function findByPath(path) {
        var names = Object.keys(namespaces)
        var namespace_name = _.find(names, function(name) { return path.indexOf(name) == 0})
        return namespace_name
    }

    //! Returns the namespace holon for the given namespace path
    function getHolon(namespace_path) {
        return JSON.parse(HolonStorage.get_sync(namespaces[namespace_path]))
    }


    //!
    function setEntry(namespace, relative_path, hash) {
        var holon = getHolon(namespace)
        var newNamespace = Holon.setNode(holon, relative_path, hash)
        var newNamespaceHash = HolonStorage.put(JSON.stringify(newNamespace))

        namespaces[namespace] = newNamespaceHash
        save()
    }

    Component.onDestruction: {
        save()
    }
}
