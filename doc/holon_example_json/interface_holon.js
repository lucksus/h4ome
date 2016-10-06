{
  _interface_holon_lang: "qml",

  // Code for the main widget that will be spawned filling the UI area (=tab).
  // Thas can be 2D or 3D - any GL code would go in here.
  _interface_holon_code_ui: |
    import QtQuick 2.4

    Rectangle {
        id: noomap_interface
        color: 'black'

        property var holarchy
        property var root_holon
        property var focussed_holon

        property var current_holons: []

        Component.onCompleted: {
            holarchy.loaded.connect(holarchyUpdate)
        }

        function holarchyUpdate() {
            noomap_interface.root_holon = holarchy.root_id
            noomap_interface.focussed_holon = holarchy.root_id
            createHolonDelegates()
        }

        function createHolonDelegates() {
            var children = holarchy.getChildren( noomap_interface.focussed_holon )


            var color_from_type = function(type) {
                switch(type){
                case 'v': return 'purple';
                case 'i': return 'yellow';
                case 's': return 'orange';
                case 'p': return 'green';
                case 'd': return 'pink';

                }
            }

            var component = Qt.createComponent(_holon.code_ui_delegate);
            while(component.status !== Component.Ready) ;

            clearHolons();

            for(var i=0; i < children.length; i++){
                var holon = children[i];
                var delegate = component.createObject(noomap_interface, {
                  'color': color_from_type( holon._t ),
                  'source': holon
                });
                current_holons.push( delegate );
            }
        }

        function clearHolons() {
            for(var i=0; i < current_holons.length; i++){
                current_holons[i].destroy();
            }
            current_holons = []
        }

      _inteface_holon_code_ui_delegate: |
        import QtQuick 2.4

        Rectangle {
            id: holon
            property double size: parent_size * source.s
            property var source
            property var parent_size: parent.height < parent.width ? parent.height : parent.width
            width: size
            height: size
            radius: size/2
            color: 'red'
            border.color: 'white'
            border.width: 2

            x: calc_screen_coord( source.x )
            y: calc_screen_coord( source.y )

            Text {
                text: holon.source.t
                color: 'white'
                anchors.centerIn: parent
                scale: holon.size / 50
                width: holon.size
                height: holon.size
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                clip: true
            }

            function calc_screen_coord(logical_coord) {
                return (holon.parent_size/2)*logical_coord + holon.parent_size/2 - size/2; // don't need -size/2 if anchor point is center
            }

        }

    }

}
