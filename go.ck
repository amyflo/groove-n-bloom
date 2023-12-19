//-----------------------------------------------------------------------------
// name: go.ck
// desc: top-level program to run for kb-test and mouse-test
//
// NOTE: this is an example of running a ChuGL project,
//       from a single file and with dependencies
//-----------------------------------------------------------------------------

[
    "mouse.ck",
    "obj-loader.ck",
    "garden-pad.ck",
    "garden.ck"
] @=> string files[];

for (auto file : files)
    Machine.add( me.dir() + file );