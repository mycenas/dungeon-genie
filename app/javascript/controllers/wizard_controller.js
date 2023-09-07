const wizardUrl = new URL("./../waving.glb", import.meta.url);
const dungeonMasterTable = new URL("./../table.glb", import.meta.url);
const renderer = new THREE.WebGLRenderer({ antialias: true });
const scene = new THREE.Scene();
const textureLoader = new THREE.TextureLoader();
const gltflLoader = new GLTFLoader();
const backgroundTexture = textureLoader.load("./../background-image.png");

import { Controller } from "@hotwired/stimulus";
import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";

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
    );
    camera.position.set(0, 3, 90);

    // DIRECTIONAL LIGHTING
    const directionalLight = new THREE.DirectionalLight(0xffa500, 2);
    directionalLight.position.set(0, 20, 60);
    directionalLight.castShadow = true;
    scene.add(directionalLight);

    const enchantedBlue = new THREE.DirectionalLight(0x0000ff, 2);
    enchantedBlue.position.set(-20, 10, 20);
    enchantedBlue.castShadow = true;
    scene.add(enchantedBlue);

    // ANIMATIONS & LOADING WIZARD
    this.mixer;

    gltflLoader.load(wizardUrl.href, (gltf) => {
      const model = gltf.scene;
      model.traverse((child) => {
        if (child.isMesh) child.castShadow = true;
      });
      scene.add(model);
      model.position.set(0, 0.4, -10);
      model.scale.set(1.4, 1.4, 1.4);

      this.mixer = new THREE.AnimationMixer(model);
      gltf.animations.forEach((clip) => {
        const action = this.mixer.clipAction(clip);
        action.setLoop(THREE.LoopOnce);
        action.clampWhenFinished = true;
        action.play();
      });
    });

    // LOADING TABLE
    gltflLoader.load(dungeonMasterTable.href, (gltf) => {
      const model = gltf.scene;
      model.traverse((child) => {
        if (child.isMesh) child.castShadow = true;
      });
      scene.add(model);
      model.scale.x = 2;
      model.position.set(-0.5, 1, -4);
      model.rotation.x = 65 * (Math.PI / 180);
    });

    this.clock = new THREE.Clock();

    // ANIMATION
    const animate = () => {
      if (this.mixer) this.mixer.update(this.clock.getDelta());
      renderer.render(scene, camera);
      this.animationFrameId = requestAnimationFrame(animate);
    };

    renderer.setAnimationLoop(animate);

    // TRIGGER
    this.resizeListener = () => {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
    };
    window.addEventListener("resize", this.resizeListener);

    this.renderer = renderer;
    this.scene = scene;
  }

  disconnect() {
    cancelAnimationFrame(this.animationFrameId);

    this.scene.traverse(object => {
      if (object.isMesh) {
        object.geometry.dispose();
        object.material.dispose();
      }
    });
    window.removeEventListener("resize", this.resizeListener);
    this.scene.clear();
    this.renderer.dispose();
  }
}
