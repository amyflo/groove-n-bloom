// Visuals ====================================================================
// Visually, the entire sequencer is made up of "GPads" which are meant to read 
// as the MIDI pads you'd see on a drum machine. 
// Each pad is a GPlane + mouse listener + state machine for handling input 
// and transitioning between various modes e.g. hovered, active, playing, etc.
// ============================================================================ 
public class GPad extends GGen {
    // initialize mesh
    GPointLight light--> GSphere bulb--> this;
    FlatMaterial mat;
    bulb.mat(mat);
    mat.color(@(0.5, 1, 1));
    light.falloff(0.14, 0.7);
    Math.random2f(0.5, 1.5) => float pulseRate;

    // reference to a mouse
    Mouse @ mouse;

    // events
    Event onHoverEvent, onClickEvent;  // onExit, onRelease
    
    // states
    0 => static int NONE;  // not hovered or active
    1 => static int HOVERED;  // hovered

    2 => static int SEED;
    3 => static int PLAYING_SEED;

    4 => static int SPROUT;
    5 => static int PLAYING_SPROUT;

    6 => static int BUD;
    7 => static int PLAYING_BUD;

    8 => static int BLOOM;
    9 => static int PLAYING_BLOOM;
    

    0 => int state; // current state

    // input types
    0 => static int MOUSE_HOVER;
    1 => static int MOUSE_EXIT;
    2 => static int MOUSE_CLICK;
    3 => static int NOTE_ON;
    4 => static int NOTE_OFF;

    // color map
    [
        Color.BLACK,    // NONE
        Color.BLUE,      // HOVERED

        // SEED
        Color.RED,   // DEFAULT
        Color.WHITE,     // PLAYING

        // SPROUT
        Color.ORANGE,   // DEFAULT
        Color.WHITE,     // PLAYING

        // BUD
        Color.YELLOW,   // DEFAULT
        Color.WHITE,     // PLAYING

        // BLOOM
        Color.GREEN,   // DEFAULT
        Color.WHITE     // PLAYING
    ] @=> vec3 colorMap[];

    // constructor
    fun void init(Mouse @ m) {
        if (mouse != null) return;
        m @=> this.mouse;
        spork ~ this.clickListener();
    }

    // check if state is active (i.e. should play sound)
    fun int active() {
        return state == SEED || state == SPROUT || state == BLOOM || state == BUD;
    }


    // set color
    fun void color(vec3 c) {
        bulb.mat().color(c);
    }

    // returns true if mouse is hovering over pad
    fun int isHovered() {
        bulb.scaWorld() => vec3 worldScale;  // get dimensions
        worldScale.x / 2.0 => float halfWidth;
        worldScale.y / 2.0 => float halfHeight;
        bulb.posWorld() => vec3 worldPos;   // get position

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
            if (state == HOVERED) handleInput(MOUSE_EXIT);
        }
    }

    // handle mouse clicks
    fun void clickListener() {
        now => time lastClick;
        while (true) {
            mouse.mouseDownEvents[Mouse.LEFT_CLICK] => now;
            if (isHovered()) {
                onClickEvent.broadcast();
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
            bulb.sca(1.4);
            bulb.rotZ(Math.random2f(-.5, .2));
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
                enter(PLAYING_SEED);
                return;
            } else if (state == SPROUT) {
                enter (PLAYING_SPROUT);
                return;
            } else if (state == BUD){
                enter (PLAYING_BUD);
                return;
            } else if (state == BLOOM) {
                enter (PLAYING_BLOOM);
                return;
            }
        }
 
        if (input == NOTE_OFF) {
            enter(lastState);
            return;
        }

        // on click & on hover events
        if (state == NONE) {
            if (input == MOUSE_HOVER)      enter(HOVERED);
            else if (input == MOUSE_CLICK) enter(SEED);
            
        } else if (state == HOVERED) {
            if (input == MOUSE_EXIT)       enter(NONE);
            else if (input == MOUSE_CLICK) enter(SEED);

        } else if (state == SEED) {
            if (input == MOUSE_CLICK)      enter(SPROUT);
        } else if (state == SPROUT) {
            if (input == MOUSE_CLICK)      enter(BUD);
        } else if (state == BUD) {
            if (input == MOUSE_CLICK)      enter(BLOOM);
        } else if (state == BLOOM) {
            if (input == MOUSE_CLICK)      enter(NONE); //  flower death
        } 
    
        // changing from playing to original  state
        else if (state == PLAYING_SEED) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(SEED);
        }
        else if (state == PLAYING_SPROUT) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(SPROUT);
        }
        else if (state == PLAYING_BUD) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(BUD);
        }
        else if (state == PLAYING_BLOOM) {
            if (input == MOUSE_CLICK)      enter(NONE);
            else if (input == NOTE_OFF)         enter(BLOOM);
        } 
        <<< state >>>;
    }

    // override ggen update
    fun void update(float dt) {
        // check if hovered
        pollHover();

        // update state
        this.color(colorMap[state]);

        // interpolate back towards uniform scale (handles animation)

        // this is cursed
        // pad.scaX()  - .03 * Math.pow(Math.fabs((1.0 - pad.scaX())), .3) => pad.sca;
        
        // much less cursed
        bulb.scaX()  + .05 * (1.0 - bulb.scaX()) => bulb.sca;
        bulb.rot().z  + .06 * (0.0 - bulb.rot().z) => bulb.rotZ;

    }
}