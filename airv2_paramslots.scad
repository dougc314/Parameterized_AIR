// AIR ver 2 parametric only for material thickness and laser kerf 

//added holes for a handle

$fn=32;
// build group 3 settings
material_thk = 5.8;
laser_kerf = 0.25;
correction = 0;

   
%translate ([-24*25.4,0,0]) cube ([24*25.4,24*25.4,.01],center=false); //test plate size
//bounds () ;  //id the 4 corners 
plate ();

module plate () {

  translate ([-120,-75+304.8,0]) rotate ([0,0,90]) {

    airv2 (material_thk,laser_kerf,correction);  //comment this line out to just cut a test coupon
    test2 (material_thk,laser_kerf,correction,4); //0 is off, 1,2,3,4  or 5 are various unused spaces 4 is lower right

  }
}



module bounds () {
  projection (cut = true) {
  for (i=[-1,1])
  for (k=[-1,1])
    translate ([(12*25.4-1)*i,(12*25.1-1)*k,0]) cube ([1,1,1],center=true);
  
  }
}

module test2 (mat,kerf,fudge,area) {
  projection (cut = true) {
    if (area == 1) {
       translate ([-300,25,0])  testcoupon (mat,kerf,fudge);
       translate ([-240,25,0])  testcoupon (mat,kerf,fudge);
    } else if (area == 2) {
         translate ([-285,250,0])  testcoupon (mat,kerf,fudge);
         translate ([-285,175,0])  testcoupon (mat,kerf,fudge);
    } else if (area == 3) {
         translate ([-436.6,325,0])  rotate ([0,0,90]) testcoupon (mat,kerf,fudge);
         translate ([-436.6,270,0]) rotate ([0,0,90])  testcoupon (mat,kerf,fudge);
    } else if (area == 4) {
         translate ([67,-120,0]) rotate ([0,0,90]) testcoupon (mat,kerf,fudge);
         translate ([67,-175,0]) rotate ([0,0,90]) testcoupon (mat,kerf,fudge); 
      } else if (area == 5) {
         translate ([-155,185,0]) rotate ([0,0,90]) testcoupon (mat,kerf,fudge);
         translate ([-155,130,0]) rotate ([0,0,90]) testcoupon (mat,kerf,fudge); 
      } else {}
 }  
}



module airv2 (mat,kerf,fudge) {
projection(cut = true) { 
   translate ([10,0,0]) rotate ([0,0,90])  top(mat,kerf,fudge);
   translate ([-375,210,0]) rotate ([0,0,90]) bracket (mat,kerf,fudge);
    translate ([-240,130,0]) leftside (mat,kerf,fudge);
    translate ([-125,65,0])  rotate ([0,0,180]) rightside(mat,kerf,fudge);
    //translate ([-125,65,0])  rotate ([0,0,180]) leftside(mat,kerf,fudge);


  }

}

module testcoupon (mat,kerf,fudge) {
  wid = mat-kerf+fudge;
  relieve_r=1;
  difference () {
    union () {
      cube ([50,50,mat],center=true);
      translate ([15,25,0])  rotate ([0,0,90]) mirror ([0,0,0]) hooked_slot (wid,10,2,mat,relieve_r,true); 
      translate ([-15,-25,0])  rotate ([0,0,-90]) mirror ([0,0,0]) hooked_slot (wid,10,2,mat,relieve_r,true);   
    }
    union () {
     translate ([0,12,0]) rotate ([0,0,90]) closed_slot (wid,21-kerf/2,mat,1,true);
    translate ([0,-12,0]) rotate ([0,0,90]) closed_slot (wid,21-kerf/2,mat,1,true);
     translate ([-25.01,0,0]) rotate ([0,0,-90]) open_slot (wid,10-kerf/2,2,mat,1,true);
      translate ([25.01,0,0]) rotate ([0,0,90]) open_slot (wid,10-kerf/2,2,mat,1,true);     

     translate ([15,25,0]) cylinder (r1=relieve_r,r2=relieve_r,h=mat,center=true);
     translate ([-15,-25,0]) cylinder (r1=relieve_r,r2=relieve_r,h=mat,center=true);
    }
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
          translate ([21+i*100,113,0]) rotate ([0,0,90]) closed_slot (wid,21-kerf,mat,relieve_r,true);
        }
        translate ([0,10,0]) cylinder (r1=relieve_r,r2=relieve_r,h=mat,center=true);
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
          translate ([21+i*100,113,0]) rotate ([0,0,90]) closed_slot (wid,21-kerf,mat,relieve_r,true);
        }
        translate ([0,10,0]) cylinder (r1=relieve_r,r2=relieve_r,h=mat,center=true);        
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
    union () {
      linear_extrude(file = "closed_top-nospline.dxf",  height = mat,center=true);
        translate ([-64,86,0]) cylinder (r1=4.7,r2=4.7, h=mat+.01, center=true);
        translate ([64,86,0]) cylinder (r1=4.7,r2=4.7, h=mat+.01, center=true);
    }
    union () {
      translate ([-127.95,116,0]) mirror ([0,1,0]) open_slot (wid,10-kerf/2,2,mat,1,true);
      translate ([127.95,116,0]) mirror ([0,1,0]) open_slot (wid,10-kerf/2,2,mat,1,true);
    #translate ([-64,47,0]) cylinder (r1=4.7,r2=4.7, h=mat+.01, center=true);
    translate ([64,47,0]) cylinder (r1=4.7,r2=4.7, h=mat+.01, center=true);


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
