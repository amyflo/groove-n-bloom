public class TPad extends Pad {
    // load textures
    FileTexture sky[17];
    for (int i; i < 17; i++) {
        sky[i].path(me.dir() + "../../data/sky/" + (i) + ".png");
    }
    mat.diffuseMap(sky[0]);

    // override ggen update
    fun void update(float dt) {
        // check if hovered
        pollHover();

        // update state
        this.texture(sky[state]);

        // interpolate back towards uniform scale (handles animation)

        // this is cursed
        // pad.scaX()  - .03 * Math.pow(Math.fabs((1.0 - pad.scaX())), .3) => pad.sca;
        
        //much less cursed
        mesh.scaX()  + .05 * (1.0 - mesh.scaX()) => mesh.sca;
        mesh.rot().z  + .06 * (0.0 - mesh.rot().z) => mesh.rotZ;

    }
}
