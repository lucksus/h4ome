
/*! Persistence Store
  Everything to access holons in namespaces
*/
pragma Singleton
import QtQuick 2.0
import QuickFlux 1.0
import Qt.labs.settings 1.0
import "../actions"
import '../js/lodash.js' as Lodash
import '../js/Holon.js' as Holon

AppListener {

    signal holonAdded(string path)
    signal holonSaved(string path)


    property var holons: {
        '/home/terence': {
            hash: 'Qm7af8555652ef7bc54b3d25998c3cd6b648948b4a509f5242f58d586a89cf86ef',
            data: {
                _holon_title: "Terence McKenna's example namespace",
                _holon_nodes: {
                    "holon1": "Qm5aaf5c00fe1d97edb67d0e0c30496914ba49df11d2630863c695fa83761c367f"},
                _holon_edges:{}
            }
        }
    }

    //! mapping of strings to meta objects
    //{
    //    "/home/terence": {
    //        writable: true,
    //        type: 'home',
    //        isSyncing: false,
    //        lastSynced: '2389472834', //unix time
    //        hash: "Qmasd3nddn23aefr23ln3wrt"
    //     },
    //
    //    "/home/otherGuy": {
    //        writable: false,
    //        type: 'home',
    //        isSyncing: true,
    //        lastSynced: '...', //unix time
    //        hash: "Qmasd3nddn23aefr23ln3asdfasdfasdfwrt"
    //    }
    //}

    property var namespaces: {
        '/home/terence': 'Qm7af8555652ef7bc54b3d25998c3cd6b648948b4a509f5242f58d586a89cf86ef'
    }


    readonly property var _: Lodash._

    Component.onCompleted: {
        if (settings.namespaces_json == "{}" || settings.namespaces_json == "")
            _private.seed();
        namespaces = JSON.parse(settings.namespaces_json)
    }




    Filter {
        // Filter - Add a filter rule to AppListenr

        // Filter item listens on parent's dispatched signal,
        // if a dispatched signal match with its type, it will
        // emit its own "dispatched" signal. Otherwise, it will
        // simply ignore the signal.

        // It is suggested to use AppListener as the type of a Store item,
        // and use Filter item to process actions.

        // Because you may use AppListener.waitFor property to control
        // the order of message recipient. It is difficult to setup
        // the depedence with nested AppListener.

        type: PersistenceActionTypes.loadHolon
        onDispatched: {
            var namespace = _private.findByPath(message.path)
            var namespace_holon = JSON.parse(HolonStorage.get_sync(namespaces[namespace]))
            var relative_path = message.path.substring(namespace.length + 1)
            var holon_hash = namespace_holon._holon_nodes[relative_path]
            var loaded_holon = JSON.parse(HolonStorage.get_sync(holon_hash))
            holons[message.path] = {
                data: loaded_holon
            }

            holonAdded(message.path)
        }
    }

    Filter {
        type: PersistenceActionTypes.commitHolon
        onDispatched: {
            var hash = HolonStorage.put(JSON.stringify(message.holon))
            var namespace = _private.findByPath(message.path)
            var namespace_holon = JSON.parse(HolonStorage.get_sync(namespaces[namespace]))
            var relative_path = message.path.substring(namespace.length + 1)
            var newNamespace = Holon.setNode(namespace_holon, relative_path, hash)
            var newNamespaceHash = HolonStorage.put(JSON.stringify(newNamespace))
            holons[message.path] = message.holon
            namespaces[namespace] = newNamespaceHash
        }
    }

    Filter {
        type: PersistenceActionTypes.pushNamespace
        onDispatched: {
            // TODO
        }
    }

    Filter {
        type: PersistenceActionTypes.pullNamespace
        onDispatched: {
            // TODO
        }
    }

    Filter {
        type: PersistenceActionTypes.createNamespace
        onDispatched: {
            // TODO
        }
    }

    Settings {
        id: settings
        property string namespaces_json
    }

    QtObject {
        id: _private

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
    }
}
