// AIR ver 2 parametric only for material thickness and laser kerf 


material_thk = 6;
laser_kerf = 0.2;
correction = 0;

//leftside (6,0,0);
airv2(6,0,0);


//bracket (material_thk,laser_kerf,correction);

//hooked_slot (6,10,2,6,1,true);
//closed_slot (6,14,6,1,true);

//airv2 (material_thk,laser_kerf,correction);


module airv2 (mat,kerf,fudge) {
projection(cut = true) { 
   rotate ([0,0,90])  top(mat,kerf,fudge);
   translate ([-350,220,0]) rotate ([0,0,90]) bracket (mat,kerf,fudge);
    translate ([-225,150,0]) leftside (mat,kerf,fudge);
    translate ([-150,20,0])  rotate ([0,0,180]) rightside(mat,kerf,fudge);


  }

}



module leftside (mat,kerf,fudge) {
  wid = mat-kerf+fudge;
  relieve_r=1;
  difference () {
    union () {
      linear_extrude(file = "leftsidens.dxf",  height = mat,center=true);
      // rotate ([180,180,0]) linear_extrude(file = "rightsidens.dxf",  height = mat,center=true);

       translate ([0,10,0])  rotate ([0,0,0]) mirror ([1,0,0]) hooked_slot (wid,10,2,mat,relieve_r,true);      
     }
     union() {
        for (i=[0,1,2]) {
          translate ([21+i*100,113,0]) rotate ([0,0,90]) closed_slot (wid,21-kerf,mat,relive_r,true);
        }
     }
   }
}



module rightside (mat,kerf,fudge) {
  wid = mat-kerf+fudge;
  relieve_r=1;
  difference () {
    union () {
     // linear_extrude(file = "leftsidens.dxf",  height = mat,center=true);
      rotate ([180,180,0]) linear_extrude(file = "rightsidens.dxf",  height = mat,center=true);

       translate ([0,10,0])  rotate ([0,0,0]) mirror ([1,0,0]) hooked_slot (wid,10,2,mat,relieve_r,true);      
     }
     union() {
        for (i=[0,1,2]) {
          translate ([21+i*100,113,0]) rotate ([0,0,90]) closed_slot (wid,21-kerf,mat,relive_r,true);
        }
     }
   }
}




module bracket (mat,kerf,fudge) {
  wid = mat-kerf+fudge;
  relieve_r=1;
  difference () {
    union () {
      linear_extrude(file = "bracket_closed.dxf",  height = mat,center=true);
      for (i = [-2,-1,0]) {
        translate ([125,i*100-10,0])  rotate ([0,0,0]) hooked_slot (wid,10-kerf/2,2,mat,relieve_r,true);
        translate ([-125,i*100-10,0])  rotate ([0,0,0]) mirror ([1,0,0]) hooked_slot (wid,10-kerf/2,2,mat,relieve_r,true);
      }
     }
   union() {
       for (i = [-2,-1,0]) {
      translate ([125,i*100-10,0])  cylinder (r1=1,r2=relieve_r,h=mat,center=true);
      translate ([-125,i*100-10,0])   cylinder (r1=1,r2=relieve_r,h=mat,center=true);
    }
   }
  }
}









module top(mat,kerf,fudge) {
  wid = mat-kerf+fudge;
difference () {

  linear_extrude(file = "closed_top-nospline.dxf",  height = mat,center=true);
  union () {
    translate ([-127.95,116,0]) mirror ([0,1,0]) open_slot (wid,10-kerf/2,2,mat,1,true);
    translate ([127.95,116,0]) mirror ([0,1,0]) open_slot (wid,10-kerf/2,2,mat,1,true);
  }

  }
}


module hooked_slot (x,y,bev,thk,r,relieve) {
  difference () {
     union () {
        linear_extrude (height=thk,center=true) 
          polygon ([[0,0],[x,0],[x,y-bev],[x+bev,y],[15-bev,y],[15,y-bev],[15,-2],[0,-2]]);
        translate ([3.5,-6,0]) cube ([7,8,thk],center=true);    
        intersection () {
          translate ([7.5,-6,0]) cube ([15,8,thk],center=true);
          translate ([7,-2,0]) cylinder (r1=8,r2=8,h=thk,center=true); 
        }
      }
    if (relieve==true) {
      //cylinder (r1=r,r2=r,h=thk,center=true); //can't do tihe here it has do cut the abutting object too
      translate ([x,0,0])  cylinder (r1=r,r2=r,h=thk,center=true);
    }
  }
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


module roundslot (L,W,H) {
  sep = L-W;
  translate ([-sep/2,0,0]) cylinder (r=W/2,h=H,center=true);
  translate ([sep/2,0,0]) cylinder (r=W/2,h=H,center=true);  		
  cube ([sep,W,H],center=true);
}
