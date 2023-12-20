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
SPad skyPad[NUM_STEPS];

GPad groundPad1[NUM_STEPS];
GPad groundPad2[NUM_STEPS];
GPad groundPad3[NUM_STEPS];

WPad waterPad1[NUM_STEPS];
WPad waterPad2[NUM_STEPS];

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
    placeSPadsHorizontal(
        skyPad, skyGroup,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0 + 5 * padSpacing
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

fun void placeGroundPads(float frustrumWidth, float frustrumHeight, float padSpacing){
    // GROUND
    placeGPadsHorizontal(
        groundPad1, groundGroup1,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0 + 2 * padSpacing
    ); 
    placeGPadsHorizontal(
        groundPad2, groundGroup2,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0 + 3 * padSpacing
    ); 
    placeGPadsHorizontal(
        groundPad3, groundGroup3,
        frustrumWidth,
        - frustrumHeight / 2.0 + padSpacing / 2.0 + 4 * padSpacing
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

fun void placeSPadsHorizontal(SPad pads[], GGen @ parent, float width, float y) {
    width / pads.size() => float padSpacing;
    for (0 => int i; i < pads.size(); i++) {
        pads[i] @=> SPad pad;

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
    fun void seed() {}
    fun void sprout() {}
    fun void plant() {}
    fun void bud() {}
    fun void bloom(){}
}

class skyIns extends Instrument { 
    inlet => Noise n => LPF f => ADSR e => outlet;
    110 => f.freq;
    40 => f.gain;
    e.set(5::ms, 50::ms, 0.1, 100::ms);

    fun void seed() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void sprout() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void plant() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void bud() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void bloom(){
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }  
}

class waterIns extends Instrument { 
    inlet => Noise n => LPF f => ADSR e => outlet;
    110 => f.freq;
    40 => f.gain;
    e.set(5::ms, 50::ms, 0.1, 100::ms);

    fun void seed() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void sprout() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void plant() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void bud() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void bloom(){
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }  
}

class groundIns extends Instrument { 
    inlet => Noise n => LPF f => ADSR e => outlet;
    110 => f.freq;
    40 => f.gain;
    e.set(5::ms, 50::ms, 0.1, 100::ms);

    fun void seed() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void sprout() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void plant() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void bud() {
        e.keyOn();
        50::ms => now;
        e.keyOff();
        e.releaseTime() => now;
    }
    fun void bloom(){
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
skyIns skyInstrument => main;
waterIns waterInstrument => main;
groundIns groundInstrument => main;

// Beat Sporking -------------------------------------------------------------------
spork ~ sequenceBeat(skyPad, false, STEP, skyInstrument);

spork ~ sequenceBeat(groundPad1, false, STEP, groundInstrument);
spork ~ sequenceBeat(groundPad2, false, STEP, groundInstrument);
spork ~ sequenceBeat(groundPad3, false, STEP, groundInstrument);

spork ~ sequenceBeat(waterPad1, false, STEP, waterInstrument);
spork ~ sequenceBeat(waterPad2, false, STEP, waterInstrument);

//  Sequence Helpers -------------------------------------------------------------------
fun void sequenceBeat(GPad pads[], int rev, dur step, Instrument @ instrument) {
    0 => int i;
    if (rev) pads.size() - 1 => i;
    while (true) {
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
    while (true) {
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

fun void sequenceBeat(SPad pads[], int rev, dur step, Instrument @ instrument) {
    0 => int i;
    if (rev) pads.size() - 1 => i;
    while (true) {
        false => int juice;    

        pads[i] @=> SPad pad; 
        

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