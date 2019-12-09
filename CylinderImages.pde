import peasy.*;
PVector [][]cylinder;
int total=300;
// the coordinates of the eye and the ellipse
float X=0;
float Y=-1000;
float Z=000;
// the class that contains and calculate everything related to the image 
Image_Projection Ip;

/// this array holds the coordinates of the interscecion of the plane and 
// the vector U that is obtained directly after applying the laws of reflection
// IN short, the array holds the coordinates of the final vector
ArrayList<PVector>IMAGEXYZ= new ArrayList<PVector>();
// this value is the T of the parametrique equation of a line
ArrayList<Float> T= new ArrayList<Float>();
// the vector out
ArrayList<PVector>U= new ArrayList<PVector>();
// the unit normal vector
ArrayList<PVector>N= new ArrayList<PVector>();
// the vector in 
ArrayList<PVector>V= new ArrayList<PVector>();
// this is the position of the eye  
PVector eye= new PVector(X,Y,Z);
// the size of the radius of the cylinder 
float Radius=100;
// the size of the box
float boxSize=total*2;
// this array list will hold the coordinate of where the iamge lands on the 
// surface of the cylinder 
ArrayList<PVector>lie_Cylinder= new ArrayList<PVector>();
// this array will hold the pixel information of the image 
ArrayList<PVector> image_pixel= new ArrayList<PVector>();
PeasyCam cam;
void setup(){
  // the size of the screen 
  size(1500,1500,P3D); 
  Ip= new Image_Projection();
  // this: represent this sketch 
  // the 600 is the distance where I start from the screen
   cam= new PeasyCam(this, 600);
  cylinder= new PVector[total][total];
  Intersection_Cylinder_Image();
  image_pixel= Ip.Pixels();
  Cylinder();
  FindN_U();
  // compute theh coordianate of where the letters of the image
  //will land on the plane 
IMAGEXYZ();
}

void draw(){
  
  background(0);
  noFill();
  stroke(255);
  //box(boxSize);
  Draw_Cylinder();
  EYE();
  //Ip.LetDraw();
  DrawSurface();
  Display_Image();
  
}

// this method  calculates the coordinates of the cylinder to draw it eventually
void Cylinder(){
  for(int i=0;i<total;i++){
    // that is the height of the cylinder
    //float lon=50;
     float lat=map(i, 0,total, 0, 2*PI);
    for(int j=0; j<total; j++){
      //float lat=map(j, 0,total, -PI, PI);
      
      float x=Radius*cos(lat);
      float y=Radius*sin(lat);
      //float z=lon;
      cylinder[i][j]=new PVector(x,y,j);
    }
   
  }
}

// this method finds the intersection of the image within the cylinder
// and the cylinder relative to the eye of the observer 
void Intersection_Cylinder_Image(){
  // this vector arraylist contains the position of the image within the cylinder 
  ArrayList<PVector>Points= Ip.Image_Within_Cylinder();
  // Let find the direction of the vector that connects the eye and the image
  // that will eventually help parametrize the line 
  ArrayList<PVector>Directions= new ArrayList<PVector>();
   for(int i=0; i<Points.size(); i++){
    // find the directions for evevery vector and add it to the arraylist 
      Directions.add(new PVector(Points.get(i).x-eye.x,Points.get(i).y-eye.y,Points.get(i).z-eye.z));
      
  }
  
  // this array list will contain the coordinates of the parameter T
  ArrayList<Float>T1= new ArrayList<Float>();
  for(int i=0; i<Directions.size(); i++){
    
    // these equations are to find the intersection of the image and the cylinder 
    // I already computed them on a piece of paper, and broke them to simplify the computation
    //float C1=pow(Points.get(i).x,2)+pow(Points.get(i).y,2)+pow(Points.get(i).z,2);
    float C1=pow(Directions.get(i).x,2)+pow(Directions.get(i).y,2);
    float C2=2*((Points.get(i).x*Directions.get(i).x)+(Points.get(i).y*Directions.get(i).y));
    float C= pow(Radius,2);
    float C3=pow(Points.get(i).x,2)+pow(Points.get(i).y,2);
    float C4=C3-C;
    // this is the solving a quadratic equation to find T
    float A=sqrt((pow(C2,2)-4*C1*C4));
    float solution=(-1*C2-A)/(2*C1);
    T1.add(solution);
    
  }
  
  for (int i=0; i<Directions.size(); i++){
    // get the coordinates of the x value where the image lies on the surface of the sphere 
    float xc=Points.get(i).x+T1.get(i)*Directions.get(i).x;
    float yc=Points.get(i).y+T1.get(i)*Directions.get(i).y;
    float zc=Points.get(i).z+T1.get(i)*Directions.get(i).z;
    
    lie_Cylinder.add(new PVector(xc,yc,zc));
  }
  
}

void IMAGEXYZ(){
//IMAGES_COORDINATES im= new IMAGES_COORDINATES();
  // this value hold the position of the plane 
  float zPlane=boxSize/2;
// These are where the points of the image lands on the surface of the sphere
  //ArrayList<PVector> data= im.Sphere_Image_Coordinates();
  for(int i=0; i<lie_Cylinder.size(); i++){
    T.add((zPlane-lie_Cylinder.get(i).z)/U.get(i).z);
  }
  
  // find the find coordinate of LOVE and where it lands on the plane
  for(int i=0; i<lie_Cylinder.size();i++){
    float x=lie_Cylinder.get(i).x+(T.get(i)*U.get(i).x);
    float y=lie_Cylinder.get(i).y+(T.get(i)*U.get(i).y);
    float z=lie_Cylinder.get(i).z+(T.get(i)*U.get(i).z);
    IMAGEXYZ.add(new PVector(x,y,z));
  }
  
  
  
  
}
void Display_Image(){
  // this byte array will be used to write to a file so that the coordinates will be access later 
  String[] Xcoordinates=new String[IMAGEXYZ.size()];
  String[] Ycoordinates=new String[IMAGEXYZ.size()];
  String[]red= new String[IMAGEXYZ.size()];
  String[]green= new String[IMAGEXYZ.size()];
  String[]blue= new String[IMAGEXYZ.size()];
  for(int i=0; i<IMAGEXYZ.size(); i++){
     stroke(image_pixel.get(i).x,image_pixel.get(i).y,image_pixel.get(i).z);  
     point(IMAGEXYZ.get(i).x,IMAGEXYZ.get(i).y,IMAGEXYZ.get(i).z);
       // this a beautiful way to convert a float to a string. This is done by converting first the float to an object, 
     //then convert it to a string value since every object has a to string method
     // with that we can store everything infomration into a file, and then we will extract it 
     Float r= new Float(image_pixel.get(i).x);
     Float g= new Float(image_pixel.get(i).y);
     Float b= new Float(image_pixel.get(i).z); 
     Float fx= new Float(IMAGEXYZ.get(i).x);   
     Float fy= new Float(IMAGEXYZ.get(i).y);   
     Xcoordinates[i]=fx.toString();
     Ycoordinates[i]=fy.toString();
     red[i]=r.toString();
     green[i]=g.toString();
     blue[i]=b.toString();
  }
   saveStrings("Xcoordinates.txt",Xcoordinates);
  saveStrings("Ycoordinates.txt",Ycoordinates);
  saveStrings("RedData.txt", red);
  saveStrings("GreenData.txt", green);
  saveStrings("BlueData.txt",blue);
}
// this method finds the vector U and the vector N (normal vector)
void FindN_U(){
 
  // the values in the arraylist data represents the postions of the the letters LOVE on the surface of the sphere 
  //ArrayList<PVector>data= ic.Sphere_Image_Coordinates();
  // fill the arraylist that contains the vector V
  for(int i=0; i<lie_Cylinder.size(); i++){
    V.add(new PVector(eye.x-lie_Cylinder.get(i).x,eye.y-lie_Cylinder.get(i).y,eye.z-lie_Cylinder.get(i).z));
  }
  
  // populate the normal vector 
  for (int i=0; i<lie_Cylinder.size(); i++){
    // we are looking for the normal vector 
    // since it is a sphere the partial derivative is 2x,2y,2x
    
   float Nx=2*lie_Cylinder.get(i).x;
   float Ny=2*lie_Cylinder.get(i).y;
   float Nz=0;
   
   // now normalize those values 
   Nx=Nx/sqrt(pow(Nx,2)+pow(Ny,2)+pow(Nz,2));
   Ny=Ny/sqrt(pow(Nx,2)+pow(Ny,2)+pow(Nz,2));
   Nz=Nz/sqrt(pow(Nx,2)+pow(Ny,2)+pow(Nz,2));
   // add these values in the arraylist of PVector
   N.add(new PVector(Nx,Ny,Nz));
  }
  
  // find the reflection vector 
  
  // We are going to do it step by step
  
   for(int i=0 ; i<lie_Cylinder.size(); i++){
       // the variable A will hold the value of the numerator of the the multiplication of
   // V.N the dot product of V and N
   
     float A= (V.get(i).x*N.get(i).x)+(V.get(i).y*N.get(i).y)+(V.get(i).z*N.get(i).z);
     // the variable B will hold the value of the dot product of N.N
    float B= (N.get(i).x*N.get(i).x)+(N.get(i).y*N.get(i).y)+(N.get(i).z*N.get(i).z);
    // C will hold the quotient of A over B
    float C=A/B;
    //the variable D will hole -V+2Cn
    //float D= (V.get(i).x*-1)+2*(C*N.get(i).x);
    
    // let now find the vector U searched 
    
    U.add(new PVector((V.get(i).x*-1)+2*(C*N.get(i).x),
    (V.get(i).y*-1)+2*(C*N.get(i).y),(V.get(i).z*-1)+2*(C*N.get(i).z)));
   }
}


// this method draws the image at the surface of the cylinder 
void DrawSurface(){
  for(int i=0; i<lie_Cylinder.size();i++){
   stroke(image_pixel.get(i).x,image_pixel.get(i).y,image_pixel.get(i).z); 
    point(lie_Cylinder.get(i).x,lie_Cylinder.get(i).y,lie_Cylinder.get(i).z);
  }
}

void Draw_Cylinder(){
  for(int i=0; i<total; i++){
    for(int j=0; j<total; j++){
      PVector v= cylinder[i][j];
       stroke(255);
      strokeWeight(2);
      point(v.x,v.y,v.z);
    }
  }
}

// this method draws the eye 
void EYE(){
 noFill();
 pushMatrix();

 translate(X,Y,Z);
 rotateX(PI/2);
 strokeWeight(4);
 ellipse(0,0,5,5);
 
 popMatrix();
 point(eye.x,eye.y,eye.z);

}
