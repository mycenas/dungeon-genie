import "../_dice.scss";
import THREE, { OrbitControls } from "./three";
import CANNON from "cannon";
import { DiceManager, DiceD20 } from "threejs-dice/lib/dice";
import Stats from "stats.js";

// standard global variables
var container,
    scene,
    camera,
    renderer,
    controls,
    stats,
    world,
    dice = [];

init();

// FUNCTIONS
function init() {
    // SCENE
    scene = new THREE.Scene();

    // CAMERA
    var SCREEN_WIDTH = window.innerWidth,
        SCREEN_HEIGHT = window.innerHeight;
    var VIEW_ANGLE = 60,
        ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT,
        NEAR = 0.01,
        FAR = 20000;
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    scene.add(camera);
    camera.position.set(0, 30, 0);
    // RENDERER
    renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;

    container = document.getElementById("ThreeJS");
    container.appendChild(renderer.domElement);
    // EVENTS
    // CONTROLS
    controls = new OrbitControls(camera, renderer.domElement);
    controls.enabled = false;
    // STATS
    stats = new Stats();
    stats.domElement.style.position = "absolute";
    stats.domElement.style.bottom = "0px";
    stats.domElement.style.zIndex = 100;
    container.appendChild(stats.domElement);

    // Add only one die
    var die = new DiceD20({
        size: 1.5,
        backColor: "#111111",
        fontColor: "#fff"
    });
    scene.add(die.getObject());
    dice.push(die);

    document.querySelector("#ThreeJS").addEventListener(
        "click",
        function () {
            randomDiceThrow();
        },
        false
    );

    requestAnimationFrame(animate);
}

function randomDiceThrow() {
    dice[0].getObject().position.set(-10, 5, -10);
    dice[0].getObject().quaternion.x = ((Math.random() * 90 - 45) * Math.PI) / 180;
    dice[0].getObject().quaternion.z = ((Math.random() * 90 - 45) * Math.PI) / 180;
    dice[0].updateBodyFromMesh();

    let yRand = Math.random() * 20;
    let rand = Math.random() * 5;

    dice[0].getObject().body.velocity.set(25 + rand, 40 + yRand, 15 + rand);
    dice[0].getObject().body.angularVelocity.set(
        20 * Math.random() - 10,
        20 * Math.random() - 10,
        20 * Math.random() - 10
    );

    let v = Math.ceil(Math.random() * 20);
    DiceManager.prepareValues([{ dice: dice[0], value: v }]);
    console.log(v);
}

function animate() {
    updatePhysics();
    render();
    update();

    requestAnimationFrame(animate);
}

function updatePhysics() {
    world.step(1.0 / 60.0);

    for (var i in dice) {
        dice[i].updateMeshFromBody();
    }
}

function update() {
    controls.update();
    stats.update();
}

function render() {
    renderer.render(scene, camera);
}
