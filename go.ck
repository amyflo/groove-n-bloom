//-----------------------------------------------------------------------------
// name: go.ck
// desc: top-level program to run for kb-test and mouse-test
//
// NOTE: this is an example of running a ChuGL project,
//       from a single file and with dependencies
//-----------------------------------------------------------------------------

[
    "/classes/mouse.ck",
    "/classes/pads/pad.ck",
    "/classes/pads/tree.ck",
    "/classes/pads/ground.ck",
    "/classes/pads/water.ck",
    
    "garden.ck"
] @=> string files[];


for (auto file : files)
    Machine.add( me.dir() + file );
