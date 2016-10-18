Qt.include("../js/three.js")

var camera, scene, renderer;
var root_holon, focussed_holon, current_holarchy;

var sprites = {};

var raycaster;
var mouse;

var currentPosition, targetPosition;
var currentMatrix;

var canvasWidth, canvasHeight;

var mainGroup;

var displacementZ = 0;


var targetObject;
var cameraTargetPosition;


var MedianFilter = function (size) {

    var that = this;
    that.vales = [];
    that.sorted = [];
    that.size = size || 7;
    that.middelIndex = Math.round(that.size / 2);

};

MedianFilter.prototype = {};

MedianFilter.prototype.input = function (val) {

    var that = this;

    //If it's empty fill it up
    if (that.vales.length === 0) {
        that.fill(val);
        return val;
    }

    //Remove last
    that.vales.shift();
    //Add new value
    that.vales.push(val);

    //Sort
    that.sorted = that.vales.slice(0);
    that.sorted = that.sorted.sort(function (a, b) { return a - b; });
    //return medium value
    return that.sorted[that.middelIndex];

};

MedianFilter.prototype.fill = function (val) {

    var that = this;
    if (that.vales.length === 0) {
        for (var i = 0; i < that.size; i++) {
            that.vales.push(val);
        }
    }

};

//Usage

var tiltFix = new MedianFilter(20); //Number is size of array to get median value from, default 7






function getCamera()
{
    return camera;
}

function initializeGL(canvas, eventSource, window) {



    camera = new THREE.PerspectiveCamera(45, canvas.width / canvas.height, 1, 2000);
    //camera.position.y = -250;
    camera.position.z = canvas.cameraPositionX;

    camera.position.y = 800;
    camera.position.x = 0;

    var vFOV = camera.fov * Math.PI / 180;        // convert vertical fov to radians
    var height = 2 * Math.tan( vFOV / 2 ) * camera.position.y; // visible height





    console.log("it is:",height, canvas.width, canvas.height);

    scene = new THREE.Scene();
    scene.fog = new THREE.FogExp2( 0x000000, 0.0005 );

    cameraTargetPosition = new THREE.Vector3(0,0,0);


    currentPosition = scene.position;
    targetPosition = scene.position;
    currentMatrix = null;

    var textureLoader = new THREE.TextureLoader();

    sprites.ball = textureLoader.load( "images/sprites/ball.png" );
    sprites.dna = textureLoader.load( "images/sprites/dna.png" );
    sprites.mp3 = textureLoader.load( "images/sprites/mp3.png" );
    sprites.flake = textureLoader.load( "images/sprites/snowflake1.png" );
    sprites.default = textureLoader.load( "images/sprites/default.png" );
    sprites.redheart = textureLoader.load( "images/sprites/red_heart.png" );

     updateScene();

    renderer = new THREE.Canvas3DRenderer(
                { canvas: canvas, antialias: true, devicePixelRatio: canvas.devicePixelRatio });

    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);


    raycaster = new THREE.Raycaster();
   // raycaster.params.Points.threshold = 5;

    mouse = new THREE.Vector2();


    eventSource.mouseDown.connect(onDocumentMouseDown);


    camera.lookAt( cameraTargetPosition );


   // var light = new THREE.DirectionalLight( 0xffffff );
   // light.position = camera.position;
   // scene.add(light);



}


function onDocumentMouseDown(x, y) {


    mouse.x = ( x / renderer.getSize().width ) * 2 - 1;
    mouse.y = - ( y / renderer.getSize().height ) * 2 + 1;



    if (mainGroup)
    {
        raycaster.setFromCamera( mouse, camera );

        // calculate objects intersecting the picking ray
        var intersects = raycaster.intersectObjects( mainGroup.children );

        console.log("All intersects:", intersects)


        for (var i = 0; i < intersects.length; i++)
        {
            console.log("Intersect: ", i, Object.keys(intersects[i]))

            if (intersects[i].object instanceof THREE.Mesh)
            {
                console.log("it's a mesh!")

                targetObject = intersects[i].object;

                //cameraTargetPosition = intersects[i].object.position.clone();

                break;
            }
        }
    }


    return;



    /*
    for (var i = 0; i < intersects.length; i++)
    {
        console.log("RAR", i, intersects[i].index, intersects[i].point.x, intersects[i].point.y)

        console.log("INTER", Object.keys(intersects[i]))
        console.log("POINT", JSON.stringify(intersects[i].object.geometry.vertices[intersects[i].index] ) )

       // intersects[i].object.material.opacity = 0.5;


    }
*/


    if (intersects.length > 0)
    {
        camera.position.z = 500;

        //lookAtPosition.i = scene.children.indexOf(intersects[0].object);
        //lookAtPosition.j = intersects[0].index;


       // currentPosition = new THREE.Vector3()
        //currentPosition.x = wTarget.x;
       // currentPosition.y = wTarget.y;
        //currentPosition.z = wTarget.z;


        targetPosition  = new THREE.Vector3();
        targetPosition.x = intersects[0].object.geometry.vertices[intersects[0].index].x;
        targetPosition.y = intersects[0].object.geometry.vertices[intersects[0].index].y;
        targetPosition.z = intersects[0].object.geometry.vertices[intersects[0].index].z;
        //targetPosition.applyMatrix4(scene.children[scene.children.indexOf(intersects[0].object)].matrixWorld)
        currentMatrix = scene.children[scene.children.indexOf(intersects[0].object)].matrixWorld


        console.log("currentPosition", JSON.stringify(currentPosition))

        console.log("targetPosition", JSON.stringify(targetPosition))

        //v.x = intersects[0].object.geometry.vertices[intersects[0].index].x
       // v.y = intersects[0].object.geometry.vertices[intersects[0].index].y
        //v.z = intersects[0].object.geometry.vertices[intersects[0].index].z

       // v.applyMatrix4(scene.children[lookAtPosition.i].matrixWorld)

       // camera.lookAt(v);



        //lookAtPosition = intersects[0].object.geometry.vertices[intersects[0].index];


    }


}

function holarchyUpdate(holarchy)
{
    current_holarchy = holarchy;
    root_holon = holarchy.root_id
    focussed_holon = holarchy.root_id

    updateScene();
}

function clearScene()
{
    scene.children.forEach(function(object){
        scene.remove(object);
    });
    scene.children.forEach(function(object){
        scene.remove(object);
    });
    scene.children.forEach(function(object){
        scene.remove(object);
    });
    console.log("done!", scene.children.length)
}

function updateScene()
{
    clearScene();

    var ambient = new THREE.AmbientLight( 0x555555 );
    scene.add(ambient);


    var parameters = [];

    var sf = 0.4;
    var def_size = 30;

    var holons = [];

    var group = new THREE.Group;

    mainGroup = group;

    var radius = 300;


    // ACTUAL DATA
    if (current_holarchy)
    {
        holons = current_holarchy.holons;
    }
    // EXAMPLE DATA
    else
    {


        holons = [];

    }


    var style_from_type = function(type)
    {
        switch(type)
        {
            case 'v': return new THREE.Color("rgb(180,29,235)");
            case 'i': return new THREE.Color("rgb(255,255,0)");
            case 's': return new THREE.Color("rgb(255,140,0)");
            case 'p': return new THREE.Color("rgb(0,200,0)");
            case 'd': return new THREE.Color("rgb(255,153,255)");
            case 'f': return new THREE.Color("rgb(0,0,200)");

            case 'dna': return sprites.dna;
            case 'mp3': return sprites.mp3;
            case 'flake': return sprites.flake;
            case 'love': return sprites.redheart;

            default: return new THREE.Color("rgb(128,0,128)");
        }
    }


    if (current_holarchy )
    {


/*
        var geometry2 = new THREE.SphereGeometry(0.9,32,24);
        var material2 = new THREE.MeshLambertMaterial({color: 0xff00ff, transparent: true, opacity: 0.8});
        var sphere2 = new THREE.Mesh(geometry2, material2);

        sphere2.renderOrder = 2;
        sphere2.scale.set(100, 100, 100);


        group.add(sphere2);

*/



        var segments = 64,
        cmaterial = new THREE.LineBasicMaterial( { color: 0x61c5e6 } ),
        cgeometry = new THREE.CircleGeometry( radius, segments );

        // Remove center vertex
        cgeometry.vertices.shift();

        var circ1 = new THREE.Line( cgeometry, cmaterial );
        circ1.rotation.x = Math.PI / 2;

        group.add( circ1 );



         var light = new THREE.DirectionalLight( 0xffffff );
         light.position.y = 800;
         group.add(light);





        if (holons.length > 0)
        {

            var rootHolon = current_holarchy.getHolonById(current_holarchy.root_id);
            var hchildren = current_holarchy.getChildren(rootHolon._id);



            var geometry = new THREE.SphereGeometry(0.9,32,24);

            for (var k=0; k<hchildren.length; k++)
            {
                var h = hchildren[k];


                var material = new THREE.MeshLambertMaterial({color: style_from_type(h._t), transparent: true, opacity: 0.8});
                var sphere = new THREE.Mesh(geometry, material);
                sphere.renderOrder = 2;
                sphere.scale.set(radius*h.s, radius*h.s, radius*h.s);
                sphere.position.x = (radius) * h.x;
                sphere.position.z = (radius) * h.y;

                sphere.holon = h;

                group.add(sphere)

                // Add children of children


                var grandchildren = current_holarchy.getChildren(h._id);

                if (false && grandchildren.length > 0)
                {
                    var holonGroup = new THREE.Group;


                    holonGroup.position.x = (radius) * h.x;
                    holonGroup.position.z = (radius) * h.y;
                    holonGroup.scale.set(radius*h.s,radius*h.s,radius*h.s);


                    for (var j=0; j<grandchildren.length; j++)
                    {
                        var h2 = grandchildren[j];

                        var material2 = new THREE.MeshLambertMaterial({color: style_from_type(h2._t), transparent: true, opacity: 0.8});
                        var sphere2 = new THREE.Mesh(geometry, material2);
                        //sphere2.renderOrder = 1;

                        sphere2.scale.set(h2.s, h2.s, h2.s);
                        sphere2.position.x = h2.x;
                        sphere2.position.z = h2.y;

                        holonGroup.add(sphere2)

                    }

                    group.add(holonGroup);
                }


                // Extra bit (particles)


                var sortedFrequencies = ['i','love'];
                var fIndex = {'i': Math.random() * 5, 'love': Math.random() * 10};


                for (var fi = 0; fi < sortedFrequencies.length; fi++)
                {
                    var f = sortedFrequencies[fi];

                    var pgeometry = new THREE.Geometry();

                    for ( var j = 0; j < fIndex[f]; j ++ ) {


                        var vertex = new THREE.Vector3();
                        vertex.x = Math.random() * 2000*sf - 1000*sf;
                        vertex.y = Math.random() * 2000*sf - 1000*sf;
                        vertex.z = Math.random() * 2000*sf - 1000*sf;

                        vertex.normalize()
                        vertex.multiplyScalar(radius) // * ((fi+1) / (sortedFrequencies.length+1)) )  //(parameters[i][3]/(max_total))

                        pgeometry.vertices.push( vertex );

                        //holonVertices[holons[fIndex[f][j]]._id] = vertex;

                    }


                    var pmaterial = new THREE.PointsMaterial( { size: def_size, blending: THREE.AdditiveBlending, depthTest: false, transparent : true } );

                    var style = style_from_type( f );

                    if (style instanceof THREE.Color)
                    {
                        pmaterial.color = style; //.setRGB( color[0], color[1], color[2] );
                        pmaterial.map = sprites.ball;
                    }
                    else
                    {
                        pmaterial.map = style;
                    }


                    var particles = new THREE.Points( pgeometry, pmaterial );

                    particles.scale.set(1.1*h.s, 1.1*h.s, 1.1*h.s);
                    particles.position.x = (radius) * h.x;
                    particles.position.z = (radius) * h.y;


                    particles.rotationSpeed = Math.random() - 0.5;

                    if (particles.rotationSpeed > 0)
                        particles.rotationSpeed += 0.5;
                    else
                        particles.rotationSpeed -= 0.5;



                    group.add( particles );

                    console.log("particle group",f, particles, h.t)

                }





            }

        }


        scene.add(group);

       // group.rotation.x = Math.PI / 2;






    }
    else
    {



    var fIndex = {};
    var sortedFrequencies = [];

    if (holons.length > 0)
    {

        for (var i=0; i < holons.length; i++)
        {
            var holon = holons[i];

            if (!fIndex[holon._t])
                fIndex[holon._t] = [i];
            else
                fIndex[holon._t].push(i);

            if (sortedFrequencies.indexOf(holon._t) === -1)
                sortedFrequencies.push(holon._t);
        }


        sortedFrequencies = sortedFrequencies.sort(function (a, b) {
            var c = fIndex[a].length;
            var d = fIndex[b].length;
            return c - d;
        });

        var holonVertices = {};


        var lineMaterial = new THREE.LineDashedMaterial({
            color: 0x0000ff
        });


        for (var fi = 0; fi < sortedFrequencies.length; fi++)
        {
            var f = sortedFrequencies[fi];

            var geometry = new THREE.Geometry();

            for ( var j = 0; j < fIndex[f].length; j ++ ) {

                // CREATE HOLON

                var vertex = new THREE.Vector3();
                vertex.x = Math.random() * 2000*sf - 1000*sf;
                vertex.y = Math.random() * 2000*sf - 1000*sf;
                vertex.z = Math.random() * 2000*sf - 1000*sf;

                vertex.normalize()
                vertex.multiplyScalar(500 * ((fi+1) / (sortedFrequencies.length+1)) )  //(parameters[i][3]/(max_total))

                geometry.vertices.push( vertex );

                holonVertices[holons[fIndex[f][j]]._id] = vertex;


            }


            var material = new THREE.PointsMaterial( { size: def_size, blending: THREE.AdditiveBlending, depthTest: false, transparent : true } );

            var style = style_from_type( f );

            if (style instanceof THREE.Color)
            {
                material.color = style; //.setRGB( color[0], color[1], color[2] );
                material.map = sprites.ball;
            }
            else
            {
                material.map = style;
            }


            var particles = new THREE.Points( geometry, material );

            scene.add( particles );

        }

    }
    }


    // CREATE LINKS

    /*
    // Draw lines from parent to child holons
    if (current_holarchy)
    {

        for (var i=0; i < holons.length; i++)
        {
            var h = holons[i];
            var hchildren = current_holarchy.getChildren(h._id);

            for (var k=0; k<hchildren.length; k++)
            {
                if (holonVertices[hchildren[k]._id])
                {
                    var lineGeometry = new THREE.Geometry();
                    lineGeometry.vertices.push(holonVertices[h._id]);
                    lineGeometry.vertices.push(holonVertices[hchildren[k]._id]);

                    var line = new THREE.Line(lineGeometry, lineMaterial);
                    scene.add(line);
                }
            }
        }
    }
    */


    /*
    // Draw lines from root holon to children of root
    if (current_holarchy)
    {

        var h = current_holarchy.getHolonById(current_holarchy.root_id);
        var hchildren = current_holarchy.getChildren(h._id);

        for (var k=0; k<hchildren.length; k++)
        {
            if (holonVertices[hchildren[k]._id])
            {
                var lineGeometry = new THREE.Geometry();
                lineGeometry.vertices.push(holonVertices[h._id]);
                lineGeometry.vertices.push(holonVertices[hchildren[k]._id]);

                var line = new THREE.Line(lineGeometry, lineMaterial);

                line.material.opacity = 0.2;

                scene.add(line);
            }
        }

    }
    */



}


var wTarget = new THREE.Vector3()

var projector = new THREE.Projector();


var lastReading = {};
lastReading.xRotation = 0;
lastReading.yRotation = 0;


function paintGL(canvas) {

    var time = Date.now() * 0.00005;

    //camera.position.x += ( 1 - camera.position.x ) * 0.05;
   // camera.position.y += ( - 1 - camera.position.y ) * 0.05;

   // var yourVertexWorldPosition = scene.children[lookAtPosition.i].geometry.vertices[lookAtPosition.j];

    /*

    if (currentMatrix)
    {
        wTarget.x = targetPosition.x
        wTarget.y = targetPosition.y
        wTarget.z = targetPosition.z
        wTarget.applyMatrix4(currentMatrix);

        currentPosition.x = ( wTarget.x - currentPosition.x ) * 0.05;
        currentPosition.y = ( wTarget.y - currentPosition.y ) * 0.05;
        currentPosition.z = ( wTarget.z - currentPosition.z ) * 0.05;

        camera.lookAt(currentPosition);
    }



    if (scene.children[lookAtPosition.i].geometry.vertices[lookAtPosition.j])
    {

        v.x = scene.children[lookAtPosition.i].geometry.vertices[lookAtPosition.j].x
        v.y = scene.children[lookAtPosition.i].geometry.vertices[lookAtPosition.j].y
        v.z = scene.children[lookAtPosition.i].geometry.vertices[lookAtPosition.j].z



        v.applyMatrix4(scene.children[lookAtPosition.i].matrixWorld)

        camera.lookAt(v);

    }
    else
    {

        camera.lookAt(scene.position);
    }
*/



    if (mainGroup)
    {

        for (var i = 0; i < mainGroup.children.length; i ++ )
        {
            var object = mainGroup.children[ i ];

            if (  object instanceof THREE.Points )
                object.rotation.y += object.rotationSpeed / 100;
        }

    }


    camera.position.z = canvas.cameraPositionX;

    if(targetObject)
    {
        cameraTargetPosition.x += (targetObject.position.x - cameraTargetPosition.x) * 0.05;
        cameraTargetPosition.y += (targetObject.position.y - cameraTargetPosition.y) * 0.05;
        cameraTargetPosition.z += (targetObject.position.z - cameraTargetPosition.z) * 0.05;
    }

    camera.lookAt( cameraTargetPosition );





    if (mainGroup)
    {

         //mainGroup.rotation.x += 0.01;


        if (tiltSensor.reading)
        {

            //displacementZ += (Math.round(tiltSensor.reading.xRotation) * 13 - displacementZ) * 0.5;
            //camera.position.z += displacementZ;
            //camera.lookAt( scene.position );


            // Pi/4 = 90



            // mainGroup.rotation.x = (tiltSensor.reading.xRotation / 90) * (Math.PI/4) * 1.5;

           // mainGroup.rotation.x = ((tiltFix.input(tiltSensor.reading.xRotation)) / 90) * (Math.PI/4) * 1.5  ; //NEARLY



            mainGroup.rotation.x -= ( mainGroup.rotation.x - ((tiltSensor.reading.xRotation / 90) * (Math.PI/4) * 1.5) ) * 0.05;

            mainGroup.rotation.z -= ( mainGroup.rotation.z - ((-tiltSensor.reading.yRotation / 90) * (Math.PI/4) * 1.5) ) * 0.05;




           // mainGroup.rotation.z = ((tiltSensor.reading.yRotation) / 90) * (Math.PI/4) * 1.5;



            //console.log("tilt", tiltSensor.reading.xRotation,  tiltSensor.reading.yRotation)

            //console.log("rotation",mainGroup.rotation.x  )


            //mainGroup.rotation.x *= 0.99;


            //lastReading.xRotation = tiltSensor.reading.xRotation;
            //lastReading.yRotation = tiltSensor.reading.yRotation;


        }





            //    var vector = new THREE.Vector3( mainGroup.children[6].position.x, mainGroup.children[6].position.y, mainGroup.children[6].position.z);
          //      vector.applyMatrix4(mainGroup.children[6].matrixWorld);
        //        vector.applyMatrix4(mainGroup.matrixWorld);
                // projector.projectVector( mainGroup.children[6].position.x  , camera );

        var width = renderer.getSize().width , height = renderer.getSize().height;
        var widthHalf = width / 2, heightHalf = height / 2;
        var j = 0;

        for (var i = 0; i < mainGroup.children.length; i++)
        {
            if (mainGroup.children[i] instanceof THREE.Mesh)
            {
                var vector = new THREE.Vector3();
                vector.setFromMatrixPosition( mainGroup.children[i].matrixWorld);

                vector.project(camera );

                vector.x = ( vector.x * widthHalf ) + widthHalf;
                vector.y = - ( vector.y * heightHalf ) + heightHalf;

                updateTextAnnotations(j, vector.x, vector.y);

                j++;
            }
        }


    }





    //console.log("it is", updateTextAnnotations)

    renderer.render( scene, camera );

}


function onResizeGL(canvas) {
    if (camera === undefined) return;

    camera.aspect = canvas.width / canvas.height;
    camera.updateProjectionMatrix();
    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);
}

//


