// AIR ver 2 parametric only for material thickness and laser kerf 

gaga = 1.2;
material_thk = 5.7;
laser_kerf = 0.2;
correction = 0;

hook_tab (15,20,6,10,2,6,8,1,false);




//airv2 (material_thk,laser_kerf,correction);

module airv2 (mat,kerf,fudge) {
projection(cut = true) { 
     top(mat,kerf,fudge);

  }

}

  






module roundslot (L,W,H) {
  sep = L-W;
  translate ([-sep/2,0,0]) cylinder (r=W/2,h=H,center=true);
  translate ([sep/2,0,0]) cylinder (r=W/2,h=H,center=true);  		
  cube ([sep,W,H],center=true);
}


module top(mat,kerf,fudge) {
  wid = mat-kerf+fudge;
difference () {

  linear_extrude(file = "closed_top-nospline.dxf",  height = mat,center=true);
  union () {
    translate ([-127.95,116,0]) open_slot (wid,-10,2,mat,1,true);
    translate ([127.95,116,0]) open_slot (wid,-10,2,mat,1,true);
  }

  }
}




module hook_tab (tabx,taby,slotx,sloty,bev,thk,cor_rad,r,relieve) {
  cube ([tabx,taby-sloty,thk],center=true);

}
  
module closed_slot (x,y,thk,r,relieve) {
  union ()
{ linear_extrude (height=thk,center=true) polygon ([[-x/2,y/2],[-x/2,-y/2],[x/2,-y/2],[x/2,y/2]]);
 if (relieve==true)
  { translate ([-x/2,y/2]) cylinder (r1=r,r2=r,h=thk,center=true);
     translate ([x/2,y/2]) cylinder (r1=r,r2=r,h=thk,center=true);
     translate ([-x/2,-y/2]) cylinder (r1=r,r2=r,h=thk,center=true);
     translate ([x/2,-y/2]) cylinder (r1=r,r2=r,h=thk,center=true);
  } 
  }

}
module open_slot (x,y,bev,thk,r,relieve) {
  union ()
{ linear_extrude (height=thk,center=true) polygon ([[-x/2-bev,0],[-x/2,bev*sign(y)],[-x/2,y],[x/2,y],[x/2,bev*sign(y)],[x/2+bev,0]]);
 if (relieve==true)
  { translate ([-x/2,y]) cylinder (r1=r,r2=r,h=thk,center=true);
     translate ([x/2,y]) cylinder (r1=r,r2=r,h=thk,center=true);
  } 
  }
}

}