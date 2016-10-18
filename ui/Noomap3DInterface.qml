import QtQuick 2.0
import QtQuick.Controls 2.0
import QtCanvas3D 1.0
import QtSensors 5.0

import "../noomap.js" as GLCode

Canvas3D {
    id: canvas3d
    anchors.fill: parent

    property var holarchy


    property var current_annotations: []

    property var holonAnnotationComponent

    property var exampleAnnotation


    property real cameraPositionX: 1234

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




// x: 0 to 90 --- 0 is flat .... 90 us profie
        // -40 to 40  l r



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


        cameraZAnimation.restart();

    }

    function updateTextAnnotations(index, x, y)
    {

        current_annotations[index].x = x - 50
        current_annotations[index].y = y -  50


    }


    //

    function prepareHolonAnnotations()
    {
        // Get rid of any annotations from previous holon
        for (var i=0; i<current_annotations.length; i++)
            current_annotations[i].destroy();
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

    NumberAnimation {
        id: cameraZAnimation
        target: canvas3d
        properties: "cameraPositionX"
        from: 1000
        to: 1
        easing.type: Easing.InOutQuint
        duration: 3500
    }

    TiltSensor {
        id: tiltSensor
        active: true
    }
}
