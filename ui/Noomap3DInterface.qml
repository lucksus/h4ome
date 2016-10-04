import QtQuick 2.0
import QtCanvas3D 1.0
import "qrc:/js/noomap.js" as GLCode

Canvas3D {
    id: canvas3d
    anchors.fill: parent

    property var holarchy

    Component.onCompleted: {
        holarchy.loaded.connect(holarchyUpdate)
    }

    onInitializeGL: {
        GLCode.initializeGL(canvas3d, eventSource, window);
    }
    onPaintGL: {
        GLCode.paintGL(canvas3d);
        //fpsDisplay.fps = canvas3d.fps;
    }

    onResizeGL: {
        GLCode.onResizeGL(canvas3d);
    }

    ControlEventSource {
        anchors.fill: parent
        focus: true
        id: eventSource
    }

    function holarchyUpdate() {
        GLCode.holarchyUpdate(holarchy);
    }

}
