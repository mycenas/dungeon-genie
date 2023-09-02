import "./styles.css";

import THREE, { OrbitControls } from "./three";
import CANNON from "cannon";
import { DiceManager, DiceD10, DiceD4, DiceD20 } from "threejs-dice/lib/dice";
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

	let ambient = new THREE.AmbientLight("#ffffff", 0.3);
	scene.add(ambient);

	let directionalLight = new THREE.DirectionalLight("#ffffff", 0.5);
	directionalLight.position.x = -1000;
	directionalLight.position.y = 1000;
	directionalLight.position.z = 1000;
	scene.add(directionalLight);

	let light = new THREE.SpotLight(0xefdfd5, 1.3);
	light.position.y = 100;
	light.target.position.set(0, 0, 0);
	light.castShadow = true;
	light.shadow.camera.near = 50;
	light.shadow.camera.far = 110;
	light.shadow.mapSize.width = 1024;
	light.shadow.mapSize.height = 1024;
	scene.add(light);

	// FLOOR
	var floorMaterial = new THREE.MeshPhongMaterial({
		color: "#003300",
		side: THREE.DoubleSide
	});
	var floorGeometry = new THREE.PlaneGeometry(30, 30, 10, 10);
	var floor = new THREE.Mesh(floorGeometry, floorMaterial);
	floor.receiveShadow = true;
	floor.rotation.x = Math.PI / 2;
	scene.add(floor);

	// SKYBOX/FOG
	var skyBoxGeometry = new THREE.CubeGeometry(10000, 10000, 10000);
	var skyBoxMaterial = new THREE.MeshPhongMaterial({
		color: 0x0,
		side: THREE.BackSide
	});
	var skyBox = new THREE.Mesh(skyBoxGeometry, skyBoxMaterial);
	scene.add(skyBox);
	scene.fog = new THREE.FogExp2(0x0, 0.00025);

	////////////
	// CUSTOM //
	////////////
	world = new CANNON.World();

	world.gravity.set(0, -9.82 * 20, 0);
	world.broadphase = new CANNON.NaiveBroadphase();
	world.solver.iterations = 16;

	DiceManager.setWorld(world);

	//Floor
	let floorBody = new CANNON.Body({
		mass: 0,
		shape: new CANNON.Plane(),
		material: DiceManager.floorBodyMaterial
	});
	floorBody.quaternion.setFromAxisAngle(
		new CANNON.Vec3(1, 0, 0),
		-Math.PI / 2
	);
	world.add(floorBody);

	//Walls
	let barrier = new CANNON.Body({
		mass: 0,
		shape: new CANNON.Box(new CANNON.Vec3(1, 10, 50))
	});
	barrier.position.set(-12 * ASPECT, 0, 0);
	world.addBody(barrier);

	let wall = new THREE.Mesh(
		new THREE.BoxGeometry(1, 10, 50),
		new THREE.MeshPhongMaterial({
			color: "#0000aa",
			opacity: 0.0,
			transparent: true,
			side: THREE.DoubleSide
		})
	);
	wall.quaternion.set(
		barrier.quaternion.x,
		barrier.quaternion.y,
		barrier.quaternion.z,
		barrier.quaternion.w
	);
	wall.position.set(
		barrier.position.x,
		barrier.position.y,
		barrier.position.z
	);
	scene.add(wall);

	barrier = new CANNON.Body({
		mass: 0,
		shape: new CANNON.Box(new CANNON.Vec3(1, 10, 50))
		// material: (diceManager as any).barrierBodyMaterial,
	});
	barrier.position.set(12 * ASPECT, 0, 0);
	world.addBody(barrier);

	wall = new THREE.Mesh(
		new THREE.BoxGeometry(1, 10, 50),
		new THREE.MeshPhongMaterial({
			color: "#0000aa",
			opacity: 0.0,
			transparent: true,
			side: THREE.DoubleSide
		})
	);
	wall.quaternion.set(
		barrier.quaternion.x,
		barrier.quaternion.y,
		barrier.quaternion.z,
		barrier.quaternion.w
	);
	wall.position.set(
		barrier.position.x,
		barrier.position.y,
		barrier.position.z
	);
	scene.add(wall);

	barrier = new CANNON.Body({
		mass: 0,
		shape: new CANNON.Box(new CANNON.Vec3(75, 50, 1))
		// material: (diceManager as any).barrierBodyMaterial,
	});
	barrier.position.set(0, 0, -15);
	world.addBody(barrier);

	wall = new THREE.Mesh(
		new THREE.BoxGeometry(75, 5, 1),
		new THREE.MeshPhongMaterial({
			color: "#0000aa",
			opacity: 0.0,
			transparent: true,
			side: THREE.DoubleSide
		})
	);
	wall.quaternion.set(
		barrier.quaternion.x,
		barrier.quaternion.y,
		barrier.quaternion.z,
		barrier.quaternion.w
	);
	wall.position.set(
		barrier.position.x,
		barrier.position.y,
		barrier.position.z
	);
	scene.add(wall);

	barrier = new CANNON.Body({
		mass: 0,
		shape: new CANNON.Box(new CANNON.Vec3(75, 50, 1))
		// material: (diceManager as any).barrierBodyMaterial,
	});
	barrier.position.set(0, 0, 15);
	world.addBody(barrier);

	wall = new THREE.Mesh(
		new THREE.BoxGeometry(75, 5, 1),
		new THREE.MeshPhongMaterial({
			color: "#0000aa",
			opacity: 0.0,
			transparent: true,
			side: THREE.DoubleSide
		})
	);
	wall.quaternion.set(
		barrier.quaternion.x,
		barrier.quaternion.y,
		barrier.quaternion.z,
		barrier.quaternion.w
	);
	wall.position.set(
		barrier.position.x,
		barrier.position.y,
		barrier.position.z
	);
	scene.add(wall);

	var colors = ["#111111", "#111111", "#00ff00", "#0000ff", "#ff00ff"];
	for (var i = 0; i < 2; i++) {
		var die = new DiceD20({
			size: 1.5,
			backColor: colors[i],
			fontColor: "#fff"
		});
		scene.add(die.getObject());
		dice.push(die);
	}

	function randomDiceThrow() {
		var diceValues = [];

		for (var i = 0; i < dice.length; i++) {
			dice[i].getObject().position.x = -10 - (i % 3) * 1.5;
			dice[i].getObject().position.y = 5 + Math.floor(i / 3) * 1.5;
			dice[i].getObject().position.z = -10 + (i % 3) * 1.5;
			dice[i].getObject().quaternion.x =
				((Math.random() * 90 - 45) * Math.PI) / 180;
			dice[i].getObject().quaternion.z =
				((Math.random() * 90 - 45) * Math.PI) / 180;
			dice[i].updateBodyFromMesh();

			let yRand = Math.random() * 20;
			let rand = Math.random() * 5;

			dice[i]
				.getObject()
				.body.velocity.set(25 + rand, 40 + yRand, 15 + rand);
			dice[i]
				.getObject()
				.body.angularVelocity.set(
					20 * Math.random() - 10,
					20 * Math.random() - 10,
					20 * Math.random() - 10
				);

			let v = Math.ceil(Math.random() * 20);
			diceValues.push({ dice: dice[i], value: v });
			console.log(v);
		}

		DiceManager.prepareValues(diceValues);
	}

	document.querySelector("#ThreeJS").addEventListener(
		"click",
		function () {
			randomDiceThrow(3, 5);
		},
		false
	);
	// setInterval(randomDiceThrow, 3000);
	// randomDiceThrow();

	requestAnimationFrame(animate);
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
