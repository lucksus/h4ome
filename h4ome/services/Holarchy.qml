import QtQuick 2.0
import 'qrc:/js/request.js' as HTTP

Item {
    id: holarchy
    property var holons
    property var links
    property string root_id

    signal loaded()

    function loadHolon(id) {
        var url = 'https://metta.noomap.com/api/getHolarchy/' + id
        HTTP.get(url, parseHolarchy)
    }

    function parseHolarchy(response) {
        var h = JSON.parse(response);
        holarchy.holons = h['holons'];
        holarchy.links = h['links'];
        holarchy.root_id = h['root_holon_id'];
        loaded();
    }

    function getHolonById(id) {
        for(var i=0; i < holons.length; i++){
            if(holons[i]._id === id) return holons[i];
        }
        return undefined;
    }

    function getChildren(id) {
        var children = []
        for(var i=0; i < links.length; i++){
            var link = links[i]
            if(link._ti === id) {
                var holon = getHolonById(link._fi)
                holon.x = link.x
                holon.y = link.y
                holon.s = link.s
                children.push( holon )
            }
        }
        return children;
    }

}
