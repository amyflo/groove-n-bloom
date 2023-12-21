// Initialize Mouse Manager ===================================================
Mouse mouse;
spork ~ mouse.start(0);  // start listening for mouse events
spork ~ mouse.selfUpdate(); // start updating mouse position

1 => int playGround;
1 => int playSky;
1 => int playWater;

// Global Sequencer Params ====================================================

120 => int BPM;  // beats per minute
(1.0/BPM)::minute / 2.0 => dur STEP;  // step duration
12 => int NUM_STEPS;  // steps per sequence

// Scene setup ================================================================
GG.scene() @=> GScene @ scene;
GG.camera() @=> GCamera @ cam;
scene.backgroundColor(@(0.5, 0.75, 1));
cam.orthographic();  // Orthographic camera mode for 2D scene

//  Resize listener -------------------------------------------------------------------
fun void resizeListener() {
    placePads();
    WindowResizeEvent e;  // now listens to the window resize event
    while (true) {
        e => now;  // window has been resized!
        <<< GG.windowWidth(), " , ", GG.windowHeight() >>>;
        placePads();
    }
} spork ~ resizeListener();

//  Groups -------------------------------------------------------------------
GGen skyGroup --> GG.scene();

GGen groundGroup1 --> GG.scene();
GGen groundGroup2 --> GG.scene();
GGen groundGroup3 --> GG.scene();

GGen waterGroup1 --> GG.scene();
GGen waterGroup2 --> GG.scene();

//  Pads -------------------------------------------------------------------
TPad skyPad[NUM_STEPS];

GPad groundPad1[NUM_STEPS];
GPad groundPad2[NUM_STEPS];
GPad groundPad3[NUM_STEPS];

WPad waterPad1[NUM_STEPS];
WPad waterPad2[NUM_STEPS];



BoxGeometry boxGeo;
boxGeo.set(11, 1, 1, 1, 1, 1);
PhongMaterial mat;
FileTexture tex;
tex.path(me.dir() + "/data/grass.png");
mat.diffuseMap(tex);


GMesh mesh;
mesh.set(boxGeo, mat);
mesh.translateZ(-1);
mesh.translateY(-1.5);
mesh --> scene;

GMesh top_mesh;
top_mesh.set(boxGeo, mat);
top_mesh.translateZ(-1);
top_mesh.translateY(1.5);
top_mesh --> scene;


//  Pad Placement ===================================================================
fun void placePads() {
    // recalculate aspect
    (GG.frameWidth() * 1.0) / (GG.frameHeight() * 1.0) => float aspect;
    // calculate ratio between old and new height/width
    cam.viewSize() => float frustrumHeight;  // height of screen in world-space units
    frustrumHeight * aspect => float frustrumWidth;  // width of the screen in world-space units
    frustrumWidth / NUM_STEPS => float padSpacing;

    placeSkyPads(frustrumWidth, frustrumHeight, padSpacing);
    placeWaterPads(frustrumWidth, frustrumHeight, padSpacing);
    placeGroundPads(frustrumWidth, frustrumHeight, padSpacing);    
}

//  Placement by type -------------------------------------------------------------------
fun void placeSkyPads(float frustrumWidth, float frustrumHeight, float padSpacing){
    placeTPadsHorizontal(
        skyPad, skyGroup,
        frustrumWidth,
        - frustrumHeight / 2.0 + 6.5 * padSpacing
    ); 
}


fun void placeGroundPads(float frustrumWidth, float frustrumHeight, float padSpacing){
    // GROUND
    placeGPadsHorizontal(
        groundPad1, groundGroup1,
        frustrumWidth,
        - frustrumHeight / 2.0 + 3 * padSpacing
    ); 
    placeGPadsHorizontal(
        groundPad2, groundGroup2,
        frustrumWidth,
        - frustrumHeight / 2.0 + 4 * padSpacing
    ); 
    placeGPadsHorizontal(
        groundPad3, groundGroup3,
        frustrumWidth,
        - frustrumHeight / 2.0 + 5 * padSpacing
    ); 
}

fun void placeWaterPads(float frustrumWidth, float frustrumHeight, float padSpacing){
    placeWPadsHorizontal(
        waterPad1, waterGroup1,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0
    ); 
    placeWPadsHorizontal(
        waterPad2, waterGroup2,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0 + padSpacing
    ); 
}


//  Placement Helpers -------------------------------------------------------------------
fun void placeGPadsHorizontal(GPad pads[], GGen @ parent, float width, float y) {
    width / pads.size() => float padSpacing;
    for (0 => int i; i < pads.size(); i++) {
        pads[i] @=> GPad pad;

        // initialize pad
        pad.init(mouse);

        // connect to scene
        pad --> parent;

        // set transform
        pad.sca(padSpacing);
        pad.posX(padSpacing * i - width / 2.0 + padSpacing / 2.0);
    }
    parent.posY(y);  // position the entire row
}

fun void placeTPadsHorizontal(TPad pads[], GGen @ parent, float width, float y) {
    width / pads.size() => float padSpacing;
    for (0 => int i; i < pads.size(); i++) {
        pads[i] @=> TPad pad;

        // initialize pad
        pad.init(mouse);

        // connect to scene
        pad --> parent;

        // set transform
        pad.sca(padSpacing);
        pad.posX(padSpacing * i - width / 2.0 + padSpacing / 2.0);
    }
    parent.posY(y);  // position the entire row
}

fun void placeWPadsHorizontal(WPad pads[], GGen @ parent, float width, float y) {
    width / pads.size() => float padSpacing;
    for (0 => int i; i < pads.size(); i++) {
        pads[i] @=> WPad pad;

        // initialize pad
        pad.init(mouse);

        // connect to scene
        pad --> parent;

        // set transform
        pad.sca(padSpacing);
        pad.posX(padSpacing * i - width / 2.0 + padSpacing / 2.0);
    }
    parent.posY(y);  // position the entire row
}

//  Instruments ===================================================================
class Instrument extends Chugraph {
    [60, 62, 64, 67, 69] @=> int notes[];
    fun void play(float note, float velocity){}

    fun void seed() {
        play(12 + notes[0], Math.random2f( .6, 1 ));
    }

    fun void sprout() {
        play(12 + notes[1], Math.random2f( .6, 1 ));
    }

    fun void plant() {
        play(12 + notes[2], Math.random2f( .6, 1 ));
    }

    fun void bud() {
        play(12 + notes[3], Math.random2f( .6, 1 ));
    }

    fun void bloom() {
        play(12 + notes[4], Math.random2f( .6, 1 ));
    }
}

class Guitar extends Instrument {
    inlet => Wurley voc => JCRev r => ADSR e => outlet;

    [48, 50, 52, 55, 57] @=> notes;
    fun void play(float note, float velocity){
        Std.mtof( note ) => voc.freq;
        velocity => voc.noteOn;
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
}

class waterIns extends Instrument { 
    [72, 74, 76, 79, 81]  @=> notes;
    inlet => Flute flute => PoleZero f => JCRev r => ADSR e => outlet;
    .75 => r.gain;
    .05 => r.mix;
    .99 => f.blockZero;
    e.set(5::ms, 50::ms, 0.1, 100::ms);

    fun void play(float note, float velocity){
        Std.mtof( note ) => flute.freq;
        velocity => flute.noteOn;
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
}

class Ins extends Instrument { 
    inlet => Saxofony ins => JCRev r => ADSR e => outlet;
    .75 => r.gain;
    .1 => r.mix;
    e.set(5::ms, 50::ms, 0.1, 100::ms);

    fun void play(float note, float velocity)
    {
        Std.mtof( note ) => ins.freq;
        velocity => ins.noteOn;
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
}

// Sequencer ===================================================================
Gain main => JCRev rev => dac;  // main bus
.1 => main.gain;
0.1 => rev.mix;

// initialize instruments
Guitar ins1 => main;
waterIns ins2 => main;
Ins ins3 => main;

// Beat Sporking -------------------------------------------------------------------
spork ~ sequenceBeat(skyPad, false, STEP, ins1);

spork ~ sequenceBeat(waterPad1, false, STEP, ins3);
spork ~ sequenceBeat(waterPad2, false, STEP, ins3);

spork ~ sequenceBeat(groundPad1, false, STEP, ins2);
spork ~ sequenceBeat(groundPad2, false, STEP, ins2);
spork ~ sequenceBeat(groundPad3, false, STEP, ins2);


//  Sequence Helpers -------------------------------------------------------------------
fun void sequenceBeat(GPad pads[], int rev, dur step, Instrument @ instrument) {
    0 => int i;
    if (rev) pads.size() - 1 => i;
    while (playGround) {
        false => int juice;    

        pads[i] @=> GPad pad; 
        

        if (pad.active()) {
            true => juice;
        }
        
        if (pad.activeSeed()){
            spork ~ instrument.seed();  // play sound
        }  else if (pad.activeSprout()){
            spork ~ instrument.sprout();  // play sound
        } else if (pad.activePlant()){
            spork ~ instrument.plant();  // play sound
        } else if (pad.activeBud()){
            spork ~ instrument.bud();  // play sound
        }  else if  (pad.activeBloom()){
            spork ~ instrument.bloom();  // play sound
        }
        
        // start animation
        pad.play(juice);  // must happen after .active() check
        // pass time
        step => now;
        // stop animation
        pad.stop();

        // bump index, wrap around playhead to other end
        if (rev) {
            i--;
            if (i < 0) pads.size() - 1 => i;
        } else {
            i++;
            if (i >= pads.size()) 0 => i;
        }
    }
}

fun void sequenceBeat(WPad pads[], int rev, dur step, Instrument @ instrument) {
    0 => int i;
    if (rev) pads.size() - 1 => i;
    while (playWater) {
        false => int juice;    

        pads[i] @=> WPad pad; 
        

        if (pad.active()) {
            true => juice;
        }
        
        if (pad.activeSeed()){
            spork ~ instrument.seed();  // play sound
        }  else if (pad.activeSprout()){
            spork ~ instrument.sprout();  // play sound
        } else if (pad.activePlant()){
            spork ~ instrument.plant();  // play sound
        } else if (pad.activeBud()){
            spork ~ instrument.bud();  // play sound
        }  else if  (pad.activeBloom()){
            spork ~ instrument.bloom();  // play sound
        }
        
        // start animation
        pad.play(juice);  // must happen after .active() check
        // pass time
        step => now;
        // stop animation
        pad.stop();

        // bump index, wrap around playhead to other end
        if (rev) {
            i--;
            if (i < 0) pads.size() - 1 => i;
        } else {
            i++;
            if (i >= pads.size()) 0 => i;
        }
    }
}

fun void sequenceBeat(TPad pads[], int rev, dur step, Instrument @ instrument) {
    0 => int i;
    if (rev) pads.size() - 1 => i;
    while (playSky) {
        false => int juice;    

        pads[i] @=> TPad pad; 
        

        if (pad.active()) {
            true => juice;
        }
        
        if (pad.activeSeed()){
            spork ~ instrument.seed();  // play sound
        }  else if (pad.activeSprout()){
            spork ~ instrument.sprout();  // play sound
        } else if (pad.activePlant()){
            spork ~ instrument.plant();  // play sound
        } else if (pad.activeBud()){
            spork ~ instrument.bud();  // play sound
        }  else if  (pad.activeBloom()){
            spork ~ instrument.bloom();  // play sound
        }
        
        // start animation
        pad.play(juice);  // must happen after .active() check
        // pass time
        step => now;
        // stop animation
        pad.stop();

        // bump index, wrap around playhead to other end
        if (rev) {
            i--;
            if (i < 0) pads.size() - 1 => i;
        } else {
            i++;
            if (i >= pads.size()) 0 => i;
        }
    }
}

// Game loop ==================================================================
while (true) { GG.nextFrame() => now; }