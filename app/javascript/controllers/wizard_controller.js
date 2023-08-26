import { Controller } from "@hotwired/stimulus";
import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";

const wizardUrl = new URL("./../pointing.glb", import.meta.url);
const dungeonMasterTable = new URL("./../table.glb", import.meta.url);
const renderer = new THREE.WebGLRenderer({ antialias: true });
const scene = new THREE.Scene();
const textureLoader = new THREE.TextureLoader();
const gltflLoader = new GLTFLoader();
const backgroundTexture = textureLoader.load("./../background-image.png");

export default class extends Controller {
  connect() {
    // RENDERING
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.gammaOutput = true;
    renderer.gammaFactor = 2.2;
    renderer.shadowMap.enabled = true;
    const wizardContainer = document.getElementById("wizard-container");
    wizardContainer.appendChild(renderer.domElement);

    // SCENE

    backgroundTexture.encoding = THREE.sRGBEncoding;
    scene.background = backgroundTexture;

    // CAMERA
    const camera = new THREE.PerspectiveCamera(
      10,
      window.innerWidth / window.innerHeight,
      0.3,
      1000
    ); // requires 4 arguments
    camera.position.set(0, 3, 90);

    // DIRECTIONAL LIGHTING
    const directionalLight = new THREE.DirectionalLight(0xffa500, 2); // Moody Orange
    directionalLight.position.set(0, 20, 60);
    directionalLight.castShadow = true;
    scene.add(directionalLight);

    const enchantedBlue = new THREE.DirectionalLight(0x0000ff, 2); // Enchanted Blue
    enchantedBlue.position.set(-20, 10, 20);
    enchantedBlue.castShadow = true;
    scene.add(enchantedBlue);

    // ANIMATIONS & LOADING WIZARD
    let mixer;

    gltflLoader.load(wizardUrl.href, function (gltf) {
      const model = gltf.scene;
      model.traverse(function (child) {
        if (child.isMesh) child.castShadow = true;
      });
      scene.add(model);
      model.position.set(0, -1.2, -10);

      mixer = new THREE.AnimationMixer(model);
      gltf.animations.forEach(function (clip) {
        const action = mixer.clipAction(clip);
        action.play();
      });
    });

    // LOADING TABLE
    gltflLoader.load(dungeonMasterTable.href, function (gltf) {
      const model = gltf.scene;
      model.traverse(function (child) {
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
    window.addEventListener("resize", function () {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
    });
  }
}
