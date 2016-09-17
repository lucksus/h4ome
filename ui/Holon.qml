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
