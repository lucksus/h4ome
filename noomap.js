Qt.include("../js/three.js")

var camera, scene, renderer;
var root_holon, focussed_holon, current_holarchy;

var sprites = {};

function initializeGL(canvas, eventSource, window) {

    camera = new THREE.PerspectiveCamera(75, canvas.width / canvas.height, 1, 2000);
    camera.position.z = 1000;

    scene = new THREE.Scene();
    //scene.fog = new THREE.FogExp2( 0x000000, 0.0008 );

    var textureLoader = new THREE.TextureLoader();

    sprites.ball = textureLoader.load( "images/sprites/ball.png" );
    sprites.dna = textureLoader.load( "images/sprites/dna.png" );
    sprites.mp3 = textureLoader.load( "images/sprites/mp3.png" );
    sprites.flake = textureLoader.load( "images/sprites/snowflake1.png" );

     updateScene();

    renderer = new THREE.Canvas3DRenderer(
                { canvas: canvas, antialias: true, devicePixelRatio: canvas.devicePixelRatio });

    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);

    //eventSource.mouseDown.connect(onDocumentMouseDown);
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
    while (scene.children.length > 0){ scene.remove(scene.children[0]) }
}

function updateScene()
{
    var parameters = [];

    var sf = 0.4;
    var def_size = 30;

    var holons;

    // ACTUAL DATA
    if (current_holarchy)
    {
        holons = current_holarchy.holons;
    }
    // EXAMPLE DATA
    else
    {
        holons = [];

        for (var i = 0; i < 100; i++)
            holons.push({_t: 'v'})

        for (var i = 0; i < 200; i++)
            holons.push({_t: 'd'})

        for (var i = 0; i < 300; i++)
            holons.push({_t: 'i'})

        for (var i = 0; i < 10; i++)
            holons.push({_t: 'p'})

        for (var i = 0; i < 300; i++)
            holons.push({_t: 's'})

        for (var i = 0; i < 1000; i++)
            holons.push({_t: 'dna'})

        for (var i = 0; i < 500; i++)
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
            case 'dna': return sprites.dna;
            case 'mp3': return sprites.mp3;


            default: return new THREE.Color("rgb(128,0,128)");
        }
    }

    clearScene();

    var fIndex = {};
    var sortedFrequencies = [];

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

function paintGL(canvas) {

    var time = Date.now() * 0.00005;

    camera.position.x += ( 1 - camera.position.x ) * 0.05;
    camera.position.y += ( - 1 - camera.position.y ) * 0.05;

    camera.lookAt( scene.position );

    var k = 0;
    for (var i = 0; i < scene.children.length; i ++ )
    {
        var object = scene.children[ i ];

        var j = i - k;

        if ( !( object instanceof THREE.Points) )
            k++;

        object.rotation.y = time * ( j < 4 ? j + 1 : - ( j + 1 ) );

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
