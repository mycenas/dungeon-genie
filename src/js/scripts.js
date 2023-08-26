import * as THREE from 'three';
import {GLTFLoader} from 'three/examples/jsm/loaders/GLTFLoader.js';
import backgroundImage from '../img/background-image.png';

// MODEL ASSETS
const wizardUrl = new URL('../assets/pointing.glb', import.meta.url); // change to pointing.glb, throwing.glb or waving.glb
const dungeonMasterTable = new URL('../assets/table.glb', import.meta.url);

// RENDERING
const renderer = new THREE.WebGLRenderer({antialias: true});
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.gammaOutput = true;
renderer.gammaFactor = 2.2;
renderer.shadowMap.enabled = true;
document.body.appendChild(renderer.domElement);

// SCENE.
const scene = new THREE.Scene();
const textureLoader = new THREE.TextureLoader();
const backgroundTexture = textureLoader.load(backgroundImage);
backgroundTexture.encoding = THREE.sRGBEncoding;
scene.background = backgroundTexture;

// CAMERA
const camera = new THREE.PerspectiveCamera(10, window.innerWidth / window.innerHeight, 0.3, 1000); // requires 4 arguments
camera.position.set(0, 3, 90);

// DIRECTIONAL LIGHTING
const directionalLight = new THREE.DirectionalLight(0xFFA500, 2); // Moody Orange
directionalLight.position.set(0, 20, 60);
directionalLight.castShadow = true;
scene.add(directionalLight);

const enchantedBlue = new THREE.DirectionalLight(0x0000FF, 2); // Enchanted Blue
enchantedBlue.position.set(-20, 10, 20);
enchantedBlue.castShadow = true;
scene.add(enchantedBlue);

// ANIMATIONS & LOADING WIZARD
const wizardAsset = new GLTFLoader();
let mixer;

wizardAsset.load(wizardUrl.href, function(gltf) {
  const model = gltf.scene;
  model.traverse(function(child) {
    if (child.isMesh) child.castShadow = true;
  });
  scene.add(model);
  model.position.set(0, -1.2, -10);

  mixer = new THREE.AnimationMixer(model);
  gltf.animations.forEach(function(clip) {
    const action = mixer.clipAction(clip);
    action.play();
  });
});

// LOADING TABLE
const tableAsset = new GLTFLoader();
tableAsset.load(dungeonMasterTable.href, function(gltf) {
  const model = gltf.scene;
  model.traverse(function(child) {
    if (child.isMesh) child.castShadow = true;
  });
  scene.add(model);
  model.position.set(-0.5, -2, -4);
  model.rotation.x = 15 * (Math.PI / 180); // Rotate table 15 degrees
});

const clock = new THREE.Clock(); // https://threejs.org/docs/#api/en/core/Clock

// ANIMATION
function animate() {
  if (mixer) mixer.update(clock.getDelta());
  renderer.render(scene, camera);
}

renderer.setAnimationLoop(animate);

// TRIGGER
window.addEventListener('resize', function() {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
});
