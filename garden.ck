// Initialize Mouse Manager ===================================================
Mouse mouse;
spork ~ mouse.start(0);  // start listening for mouse events
spork ~ mouse.selfUpdate(); // start updating mouse position

// Global Sequencer Params ====================================================

120 => int BPM;  // beats per minute
(1.0/BPM)::minute / 2.0 => dur STEP;  // step duration
12 => int NUM_STEPS;  // steps per sequence

// Scene setup ================================================================
GG.scene() @=> GScene @ scene;
GG.camera() @=> GCamera @ cam;
scene.backgroundColor(Color.WHITE);
cam.orthographic();  // Orthographic camera mode for 2D scene

// sky
GGen skyGroup --> GG.scene();
SPad sky[NUM_STEPS];

// ground
GGen groundGroups[NUM_STEPS];
for (auto group : groundGroups) group --> GG.scene();
GPad ground[NUM_STEPS][3];

// water
GGen waterGroups[NUM_STEPS];
for (auto group : waterGroups) group --> GG.scene();
WPad water[NUM_STEPS][2];

// place shit into the scene
// make instruments 
// make it change depending on the state

// Game loop ==================================================================
while (true) { GG.nextFrame() => now; }