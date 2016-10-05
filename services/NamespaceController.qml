import QtQuick 2.0
import Qt.labs.settings 1.0
import 'qrc:/seeds/namespaces.js' as NAMESPACE_SEEDS

Item {
    id: namespaceController
    property var namespaces

    Settings {
        id: settings
        property string namespaces_json
    }

    Component.onCompleted: {
        console.log(settings.namespaces_json)
        if (settings.namespaces_json == "{}")
            seed()
        namespaces = JSON.parse(settings.namespaces_json)
    }

    function getHolon(path) {
        var namespace = findNamespace(path)
        var relative_path = path.substring(namespace.length)
        HolonStorage.get_sync(namespace._holon_nodes[relative_path])
    }

    function saveHolon(path, holon) {
        var hash = HolonStorage.put(JSON.stringify(holon))
        var namespace = findNamespace(path)
        var relative_path = path.substring(namespace.length)
        namespace._holon_nodes[relative_path] = hash
        save()
    }

    function findNamespace(path) {
        for (var namespace_name in namespaces) {
          if (namespace_name.startsWith(path)) {
              return HolonStorage.get_sync(namespaces[namespace_name])
          }
        }
        return false
    }

    function save() {
        settings.namespaces_json = JSON.stringify(namespaces)
    }

    function seed() {
        namespaces = {}
        for (var namespace_name in NAMESPACE_SEEDS) {
            var hash = HolonStorage.put(JSON.stringify(NAMESPACE_SEEDS[namespace_name]))
            namespaces[namespace_name] = hash
        }
        save()
    }

    Component.onDestruction: {
        save()
    }
}
