Parameterized_AIR
=================

AIR parameterized for material width and LASER kerf.
The AIR dxf files were imported into Alibre and edited to alter various features (such as splines and blocks) 
that would not import into OpenSCAD so that they would. The final result was a DXF file that would impurt into OpenSCAD. Slots and other features (I forget for certain) were removes so that they could be added back as parameterized OpenSCAD features. The final result was an OpenSCAD file that was parameterized for material thickness and LASER kerf.

The important file is airv2_paramslots.scad. There are DXF files that get imported as well. Run this file in OpenSCAD, and set the laser kerf and material thickness appropriatly. It does take a long time to render. After rendering, export as a dxf. You will then be able to use that DXF with a laser cutter.

As the entire set of AIR parts are in OpenSCAD, they are editable. However if you are trying to alter the physical dimensions, such as printer height I believe you may have to edit the underlying DXF files.  

However you may be able cut the parts up by differencing them with flat cubes and translating the pieces.

For example

// move the top away from the bottom
translate ([as far as you would like it to get bigger])  difference () {
    import ("DXF FILE");  //the dxf file is the piece that you want to cut up and make bigger
    translate ([if necessary]) cube ([dimensioned to cut bottom of dxf file, leaving the top]);
}

([difference () {
    import ("DXF FILE");
    cube ([dimensioned to cut top of dxf file, leaving the bottom);
}    

//now you have the top seperated from the bottom, you just have to figure how to add a piece into the gap
translate ([as neseccary to fit into the gap]) cube ([dimensions of the gap])

Note that the actual thickness of the pieces don't really matter as the final step is a projection to a flat DXF. However it makes sense to use widths similiar to the material that you plan to use.
