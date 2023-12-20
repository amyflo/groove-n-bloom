// Visuals ====================================================================
// Visually, the entire sequencer is made up of "GPads" which are meant to read 
// as the MIDI pads you'd see on a drum machine. 
// Each pad is a GPlane + mouse listener + state machine for handling input 
// and transitioning between various modes e.g. hovered, active, playing, etc.
// ============================================================================ 
public class WPad extends GGen {

    // load textures
    FileTexture plants[17];
    for (int i; i < 17; i++) {
        plants[i].path(me.dir() + "../../data/water/" + (i) + ".png");
    }

    // initialize mesh
    GMesh mesh --> this;
    BoxGeometry boxGeo;
    PhongMaterial mat;
    mat.diffuseMap(plants[0]);
    mesh.set(boxGeo, mat);
    
    // reference to a mouse
    Mouse @ mouse;

    // events
    Event onHoverEvent, onClickEvent;  // onExit, onRelease
    
    // states
    0 => static int NONE;
    1 => static int HOVER_NONE; 

    2 => static int SEED;
    3 => static int HOVER_SEED;
    4 => static int ACTIVE_SEED;

    5 => static int SPROUT;
    6 => static int HOVER_SPROUT;
    7 => static int ACTIVE_SPROUT;

    8 => static int PLANT;
    9 => static int HOVER_PLANT;
    10 => static int ACTIVE_PLANT;

    11 => static int BUD;
    12 => static int HOVER_BUD;
    13 => static int ACTIVE_BUD;

    14 => static int BLOOM;
    15 => static int HOVER_BLOOM;
    16 => static int ACTIVE_BLOOM;
    

    0 => int state; // current state

    // input types
    0 => static int MOUSE_HOVER;
    1 => static int MOUSE_EXIT;
    2 => static int MOUSE_CLICK;
    3 => static int NOTE_ON;
    4 => static int NOTE_OFF;

    // constructor
    fun void init(Mouse @ m) {
        if (mouse != null) return;
        m @=> this.mouse;
        spork ~ this.clickListener();
    }

    // check if state is active (i.e. should play sound)
    fun int active() {
        return state == SEED 
            || state == SPROUT 
            || state == PLANT 
            || state == BLOOM 
            || state == BUD;
    }

    fun int getState() {
        return state;
    }

    fun int hover(){
        return state == HOVER_NONE 
            || state == HOVER_SEED 
            || state == HOVER_SPROUT
            || state == HOVER_PLANT 
            || state ==  HOVER_BUD 
            || state == HOVER_BLOOM;
    }


    // set color
    fun void texture(FileTexture tex) {
        mat.diffuseMap(tex);
        mesh.set(boxGeo, mat);
    }

    // returns true if mouse is hovering over pad
    fun int isHovered() {
        mesh.scaWorld() => vec3 worldScale;  // get dimensions
        worldScale.x / 2.0 => float halfWidth;
        worldScale.y / 2.0 => float halfHeight;
        mesh.posWorld() => vec3 worldPos;   // get position

        if (mouse.worldPos.x > worldPos.x - halfWidth && mouse.worldPos.x < worldPos.x + halfWidth &&
            mouse.worldPos.y > worldPos.y - halfHeight && mouse.worldPos.y < worldPos.y + halfHeight) {
            return true;
        }
        return false;
    }

    // poll for hover events
    fun void pollHover() {
        if (isHovered()) {
            onHoverEvent.broadcast();
            handleInput(MOUSE_HOVER);
        } else {
            if (hover()) handleInput(MOUSE_EXIT);
        }
    }

    // handle mouse clicks
    fun void clickListener() {
        now => time lastClick;
        while (true) {
            mouse.mouseDownEvents[Mouse.LEFT_CLICK] => now;
            if (isHovered()) {
                onClickEvent.broadcast();
                400::ms => now; // cooldown
                handleInput(MOUSE_CLICK);
            }
            100::ms => now; // cooldown
        }
    }

    // animation when playing
    // set juice = true to animate
    fun void play(int juice) {
        handleInput(NOTE_ON);
        if (juice) {
            mesh.sca(1.4);
            mesh.rotZ(Math.random2f(-.5, .2));
        }
    }

    // stop play animation (called by sequencer on note off)
    fun void stop() {
        handleInput(NOTE_OFF);
    }

    // activate pad, meaning it should be played when the sequencer hits it
    fun void activate() {
        enter(SEED);
    }

    0 => int lastState;
    // enter state, remember last state
    fun void enter(int s) {
        state => lastState;
        s => state;
        // uncomment to randomize color when playing
        // if (state == PLAYING) Color.random() => colorMap[PLAYING];
    }

    // basic state machine for handling input
    fun void handleInput(int input) {
        if (input == NOTE_ON) {
            if (state == SEED) {
                enter(ACTIVE_SEED);
                return;
            } else if (state == SPROUT) {
                enter (ACTIVE_SPROUT);
                return;
            }else if (state == PLANT) {
                enter (ACTIVE_PLANT);
                return;
            } else if (state == BUD){
                enter (ACTIVE_BUD);
                return;
            } else if (state == BLOOM) {
                enter (ACTIVE_BLOOM);
                return;
            }
        }
 
        if (input == NOTE_OFF) {
            enter(lastState);
            return;
        }

        // MODE: NONE
        if (state == NONE) {
            if (input == MOUSE_HOVER)      enter(HOVER_NONE);
            else if (input == MOUSE_CLICK) enter(SEED);
        } else if (state == SEED) {
            if (input == MOUSE_HOVER)      enter(HOVER_SEED);
            else if (input == MOUSE_CLICK)      enter(SPROUT);
        } else if (state == SPROUT) {
            if (input == MOUSE_HOVER)      enter(HOVER_SPROUT);
            else if (input == MOUSE_CLICK)      enter(PLANT);
        } else if (state == PLANT) {
            if (input == MOUSE_HOVER)      enter(HOVER_PLANT);
            else if (input == MOUSE_CLICK)      enter(BUD);
        } else if (state == BUD) {
            if (input == MOUSE_HOVER)      enter(HOVER_BUD);
            else if (input == MOUSE_CLICK)      enter(BLOOM);
        } else if (state == BLOOM) {
            if (input == MOUSE_HOVER)      enter(HOVER_BLOOM);
            else if (input == MOUSE_CLICK)      enter(NONE); //  flower death
        } 

        // MODE: HOVER 
        else if (state == HOVER_NONE){
            if (input == MOUSE_EXIT)       enter(NONE);
            else if (input == MOUSE_CLICK)       enter(SEED);
        } else if (state == HOVER_SEED){
            if (input == MOUSE_EXIT)       enter(SEED);
            else if (input == MOUSE_CLICK)       enter(SPROUT);
        } else if (state == HOVER_SPROUT){
            if (input == MOUSE_EXIT)       enter(SPROUT);
            else if (input == MOUSE_CLICK)       enter(PLANT);
        } else if (state == HOVER_PLANT){
            if (input == MOUSE_EXIT)       enter(PLANT);
            else if (input == MOUSE_CLICK)       enter(BUD);
        } else if (state == HOVER_BUD){
            if (input == MOUSE_EXIT)       enter(BUD);
            else if (input == MOUSE_CLICK)       enter(BLOOM);
        } else if (state == HOVER_BLOOM){
            if (input == MOUSE_EXIT)       enter(BLOOM);
            else if (input == MOUSE_CLICK)       enter(NONE);
        }
       
        // MODE: ACTIVE
        else if (state == ACTIVE_SEED) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(SEED);
        }
        else if (state == ACTIVE_SPROUT) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(SPROUT);
        }
        else if (state == ACTIVE_PLANT) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(PLANT);
        }
        else if (state == ACTIVE_BUD) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(BUD);
        }
        else if (state == ACTIVE_BLOOM) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(BLOOM);
        } 
    }

    // override ggen update
    fun void update(float dt) {
        // check if hovered
        pollHover();

        // update state
        this.texture(plants[state]);

        // interpolate back towards uniform scale (handles animation)

        // this is cursed
        // pad.scaX()  - .03 * Math.pow(Math.fabs((1.0 - pad.scaX())), .3) => pad.sca;
        
        //much less cursed
        mesh.scaX()  + .05 * (1.0 - mesh.scaX()) => mesh.sca;
        mesh.rot().z  + .06 * (0.0 - mesh.rot().z) => mesh.rotZ;

    }
}