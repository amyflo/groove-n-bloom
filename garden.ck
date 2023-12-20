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

// update pad positions on window resize
fun void resizeListener() {
    placePads();
    WindowResizeEvent e;  // now listens to the window resize event
    while (true) {
        e => now;  // window has been resized!
        <<< GG.windowWidth(), " , ", GG.windowHeight() >>>;
        placePads();
    }
} spork ~ resizeListener();

// place pads based on window size
fun void placePads() {
    // recalculate aspect
    (GG.frameWidth() * 1.0) / (GG.frameHeight() * 1.0) => float aspect;
    // calculate ratio between old and new height/width
    cam.viewSize() => float frustrumHeight;  // height of screen in world-space units
    frustrumHeight * aspect => float frustrumWidth;  // width of the screen in world-space units
    frustrumWidth / NUM_STEPS => float padSpacing;

    // resize pads
    placeSPadsHorizontal(
        sky, skyGroup,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0
    );
}


// fun void placeGPadsHorizontal(GPad pads[], GGen @ parent, float width, float y) {
//     width / pads.size() => float padSpacing;
//     for (0 => int i; i < pads.size(); i++) {
//         pads[i] @=> GPad pad;

//         // initialize pad
//         pad.init(mouse);

//         // connect to scene
//         pad --> parent;

//         // set transform
//         pad.sca(padSpacing * .7);
//         pad.posX(padSpacing * i - width / 2.0 + padSpacing / 2.0);
//     }
//     parent.posY(y);  // position the entire row
// }

fun void placeSPadsHorizontal(SPad pads[], GGen @ parent, float width, float y) {
    width / pads.size() => float padSpacing;
    for (0 => int i; i < pads.size(); i++) {
        pads[i] @=> SPad pad;

        // initialize pad
        pad.init(mouse);

        // connect to scene
        pad --> parent;

        // set transform
        pad.sca(padSpacing * .7);
        pad.posX(padSpacing * i - width / 2.0 + padSpacing / 2.0);
    }
    parent.posY(y);  // position the entire row
}

// fun void placeWPadsHorizontal(WPad pads[], GGen @ parent, float width, float y) {
//     width / pads.size() => float padSpacing;
//     for (0 => int i; i < pads.size(); i++) {
//         pads[i] @=> WPad pad;

//         // initialize pad
//         pad.init(mouse);

//         // connect to scene
//         pad --> parent;

//         // set transform
//         pad.sca(padSpacing * .7);
//         pad.posX(padSpacing * i - width / 2.0 + padSpacing / 2.0);
//     }
//     parent.posY(y);  // position the entire row
// }


// Game loop ==================================================================
while (true) { GG.nextFrame() => now; }