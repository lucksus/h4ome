Qt.include("three.js")

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
    var sf_particle_total = 1;
    var def_size = 30;

    if (!current_holarchy)
    {
        console.log("loading example holon visualisation")
        parameters = [
            [ [0.5,0.5,0.5], sprites.ball, 30, 11*sf_particle_total ],
            [ [1, 0, 1], sprites.ball, 30, 54*sf_particle_total ],
            [ [1, 1, 1], sprites.ball, 30, 26*sf_particle_total ],
            [ [0, 0, 1], sprites.ball, 30, 29*sf_particle_total ],

            [ [1, 1, 1], sprites.dna, 30, 64*sf_particle_total ],
            [ [1, 1, 1], sprites.mp3, 10, 1000*sf_particle_total ]

        ];
    }
    else
    {
        console.log("loading holon visualisation for "+current_holarchy.getHolonById(root_holon).t)

        var holons = current_holarchy.holons;

        var color_from_type = function(type)
        {
            switch(type)
            {
                case 'v': return new THREE.Color("rgb(180,29,235)");
                case 'i': return new THREE.Color("rgb(255,255,0)");
                case 's': return new THREE.Color("rgb(255,140,0)");
                case 'p': return new THREE.Color("rgb(0,200,0)");
                case 'd': return new THREE.Color("rgb(255,153,255)");

                default: return new THREE.Color("rgb(128,0,128)");
            }
        }

        clearScene();

        var fIndex = {};

        for (var i=0; i < holons.length; i++)
        {
            var holon = holons[i];

            if (!fIndex[holon._t])
                fIndex[holon._t] = 1;
            else
                fIndex[holon._t]++;
        }

        for (var f in fIndex)
        {
            var col = color_from_type( f );
            parameters.push( [ [col.r,col.g,col.b], sprites.ball, def_size, fIndex[f]*sf_particle_total ] );
        }

    }

    var max_total = 0;

    for ( var i = 0; i < parameters.length; i ++ )
        if (parameters[i][3] > max_total)
            max_total = parameters[i][3];

    // Sort and rank by param 3
    // Set radius and holon size by rank

    // I WANT TO BE ABLE TO SWITCH DYNAMICALLY BETWEEN MANY DIFFERENT GEOMETRIES

    var materials = [];

    for ( i = 0; i < parameters.length; i ++ )
    {
        var color  = parameters[i][0];
        var sprite = parameters[i][1];
        var size   = parameters[i][2];


        var geometry = new THREE.Geometry();
        for ( var j = 0; j < parameters[i][3]; j ++ ) {

            var vertex = new THREE.Vector3();
            vertex.x = Math.random() * 2000*sf - 1000*sf;
            vertex.y = Math.random() * 2000*sf - 1000*sf;
            vertex.z = Math.random() * 2000*sf - 1000*sf;

            vertex.normalize()
            vertex.multiplyScalar(500 * 1 )  //(parameters[i][3]/(max_total))

            geometry.vertices.push( vertex );
        }


        materials[i] = new THREE.PointsMaterial( { size: size, map: sprite, blending: THREE.AdditiveBlending, depthTest: false, transparent : true } );
        materials[i].color.setRGB( color[0], color[1], color[2] );

        var particles = new THREE.Points( geometry, materials[i] );

        particles.rotation.x = Math.random() * 6;
        particles.rotation.y = Math.random() * 6;
        particles.rotation.z = Math.random() * 6;

        scene.add( particles );
    }
}

function paintGL(canvas) {

    var time = Date.now() * 0.00005;

    camera.position.x += ( 1 - camera.position.x ) * 0.05;
    camera.position.y += ( - 1 - camera.position.y ) * 0.05;

    camera.lookAt( scene.position );

    for (var i = 0; i < scene.children.length; i ++ ) {

        var object = scene.children[ i ];

        if ( object instanceof THREE.Points ) {

            object.rotation.y = time * ( i < 4 ? i + 1 : - ( i + 1 ) );

        }

    }


    //if (explode && scene.children[3].scale.x > 0.02)
   //     scene.children[3].scale.multiplyScalar(0.8)


/*
    for ( i = 0; i < materials.length; i ++ ) {

        color = parameters[i][0];

        h = ( 360 * ( color[0] + time ) % 360 ) / 360;
        materials[i].color.setHSL( h, color[1], color[2] );

    }
*/
    renderer.render( scene, camera );

}


function onResizeGL(canvas) {
    if (camera === undefined) return;

    camera.aspect = canvas.width / canvas.height;
    camera.updateProjectionMatrix();
    renderer.setPixelRatio(canvas.devicePixelRatio);
    renderer.setSize(canvas.width, canvas.height);
}
