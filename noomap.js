Qt.include("../js/three.js")

var camera, scene, renderer;
var root_holon, focussed_holon, current_holarchy;

var sprites = {};

var raycaster;
var mouse;

var currentPosition, targetPosition;
var currentMatrix;

var canvasWidth, canvasHeight;


function initializeGL(canvas, eventSource, window) {

    camera = new THREE.PerspectiveCamera(75, canvas.width / canvas.height, 1, 2000);
    //camera.position.y = -250;
    camera.position.z = 1000;

    camera.position.y = 0;
    camera.position.x = 0;

    scene = new THREE.Scene();
    scene.fog = new THREE.FogExp2( 0x000000, 0.0005 );


    currentPosition = scene.position;
    targetPosition = scene.position;
    currentMatrix = null;

    var textureLoader = new THREE.TextureLoader();

    sprites.ball = textureLoader.load( "images/sprites/ball.png" );
    sprites.dna = textureLoader.load( "images/sprites/dna.png" );
    sprites.mp3 = textureLoader.load( "images/sprites/mp3.png" );
    sprites.flake = textureLoader.load( "images/sprites/snowflake1.png" );
    sprites.default = textureLoader.load( "images/sprites/default.png" );

     updateScene();

    renderer = new THREE.Canvas3DRenderer(
                { canvas: canvas, antialias: true, devicePixelRatio: canvas.devicePixelRatio });

    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);


    raycaster = new THREE.Raycaster();
    raycaster.params.Points.threshold = 5;

    mouse = new THREE.Vector2();


    eventSource.mouseDown.connect(onDocumentMouseDown);


    camera.lookAt( scene.position );


    var light = new THREE.DirectionalLight( 0xffffff );
    light.position = camera.position;
    scene.add(light);
    var ambient = new THREE.AmbientLight( 0x555555 );
    scene.add(ambient);

}


function onDocumentMouseDown(x, y) {


    mouse.x = ( x / renderer.getSize().width ) * 2 - 1;
    mouse.y = - ( y / renderer.getSize().height ) * 2 + 1;


    raycaster.setFromCamera( mouse, camera );

    console.log(scene.children)

    // calculate objects intersecting the picking ray
    var intersects = raycaster.intersectObjects( scene.children );


    console.log("inter", intersects)

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

    console.log("done!")
}

function updateScene()
{
    var parameters = [];

    var sf = 0.4;
    var def_size = 30;

    var holons = [];


    // ACTUAL DATA
    if (current_holarchy)
    {
        holons = current_holarchy.holons;
    }
    // EXAMPLE DATA
    else
    {
        return;

        holons = [];

        for (var i = 0; i < 80; i++)
            holons.push({_t: 'f'})

        for (var i = 0; i < 100; i++)
            holons.push({_t: 'v'})

        for (var i = 0; i < 120; i++)
            holons.push({_t: 'd'})

        for (var i = 0; i < 100; i++)
            holons.push({_t: 'i'})

        for (var i = 0; i < 640; i++)
            holons.push({_t: 'dna'})

        for (var i = 0; i < 300; i++)
            holons.push({_t: 'flake'})

        for (var i = 0; i < 100; i++)
            holons.push({_t: 'mp3'})
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

            default: return new THREE.Color("rgb(128,0,128)");
        }
    }


    if (true )
    {

        var group = new THREE.Group;

/*
        var geometry2 = new THREE.SphereGeometry(0.9,32,24);
        var material2 = new THREE.MeshLambertMaterial({color: 0xff00ff, transparent: true, opacity: 0.8});
        var sphere2 = new THREE.Mesh(geometry2, material2);

        sphere2.renderOrder = 2;
        sphere2.scale.set(100, 100, 100);


        group.add(sphere2);

*/


        var radius = 500;

        var segments = 64,
        cmaterial = new THREE.LineBasicMaterial( { color: 0x61c5e6 } ),
        cgeometry = new THREE.CircleGeometry( radius, segments );

        // Remove center vertex
        cgeometry.vertices.shift();

        var circ1 = new THREE.Line( cgeometry, cmaterial );
        circ1.rotation.x = Math.PI / 2;

        group.add( circ1 );




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

            group.add(sphere)

            // Add children of children


            var grandchildren = current_holarchy.getChildren(h._id);

            if (grandchildren.length > 0)
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

function paintGL(canvas) {

    var time = Date.now() * 0.00005;

    //camera.position.x += ( 1 - camera.position.x ) * 0.05;
   // camera.position.y += ( - 1 - camera.position.y ) * 0.05;

   // var yourVertexWorldPosition = scene.children[lookAtPosition.i].geometry.vertices[lookAtPosition.j];


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



/*
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


    var k = 0;
    for (var i = 0; i < scene.children.length; i ++ )
    {
        var object = scene.children[ i ];

       // var j = i - k;

      //  if ( !( object instanceof THREE.Points) )
       //     k++;

        if (  object instanceof THREE.Points )
            object.rotation.y = time * ( i < 4 ? i + 1 : - ( i + 1 ) );


        //object.rotation.y = time *10;



        object.rotation.x += 0.001;

       // console.log(object.rotation.x)

    }

    renderer.render( scene, camera );

}


function onResizeGL(canvas) {
    if (camera === undefined) return;

    camera.aspect = canvas.width / canvas.height;
    camera.updateProjectionMatrix();
    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);
}
