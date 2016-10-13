import QtQuick 2.0
import QtQuick.Controls 2.0
import QtCanvas3D 1.0
import "../noomap.js" as GLCode

Canvas3D {
    id: canvas3d
    anchors.fill: parent

    property var holarchy


    property var current_annotations: []

    property var holonAnnotationComponent

    property var exampleAnnotation



    Component.onCompleted: {
        holarchy.loaded.connect(holarchyUpdate)

        holonAnnotationComponent = Qt.createComponent("qrc:/ui/HolonAnnotation.qml");

       // if (holonAnnotationComponent.status == Component.Ready)
        //    finishCreation();
        //else
          //  holonAnnotationComponent.statusChanged.connect(finishCreation);

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

    function holarchyUpdate()
    {
        prepareHolonAnnotations();
        GLCode.holarchyUpdate(holarchy);
    }

    function updateTextAnnotations(index, x, y)
    {

        current_annotations[index].x = x - 50
        current_annotations[index].y = y -  50

        console.log(index)

    }


    //

    function prepareHolonAnnotations()
    {
        current_annotations = []

        if (holonAnnotationComponent.status == Component.Ready)
        {


            var children = holarchy.getChildren(holarchy.root_id);


            for (var i=0; i<children.length; i++)
            {

                var annotation = holonAnnotationComponent.createObject(canvas3d, {text: children[i].t});

                if (annotation == null) {
                    // Error Handling
                    console.log("Error creating object");
                }

                current_annotations.push(annotation);

            }

        }
        else if (holonAnnotationComponent.status == Component.Error)
        {
            // Error Handling
            console.log("Error loading component:", holonAnnotationComponent.errorString());
        }
    }


}
