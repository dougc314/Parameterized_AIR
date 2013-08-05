//projection (cut = true) translate ([0,0,-4]) import_stl ("novalabsicon.stl");

difference (){
  scale ([1.05,1.05,1]) linear_extrude (height = 1,  file="novabase.dxf", center=true ) ;
  linear_extrude (height = 1,  file="novatop.dxf", center=true) ;
}