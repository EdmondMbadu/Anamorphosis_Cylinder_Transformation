class Image_Projection{
 PImage mc=loadImage("RubiksCube.jpg");
 ArrayList<PVector>Points= new ArrayList<PVector>(); 
 ArrayList<PVector>IColors= new ArrayList<PVector>();
  
Image_Projection(){
        
  mc.resize(mc.width/2,0);
   mc.resize(0,mc.height);
  
    for(int i=0; i<mc.width; i++){
      for(int j=0; j<mc.height; j++){
        // since the image appears upside down which
        // this translation is very important for the image to be 
        Points.add(new PVector(i-(mc.width/2),0,j-(mc.height-boxSize/2)));
        }
     }
     mc.loadPixels();
      for(int i=0; i<mc.width; i++){
      for(int j=0; j<mc.height; j++){
        int location = i+j*(mc.width);
        float r=red(mc.pixels[location]);
        float g=green(mc.pixels[location]);
        float b=blue(mc.pixels[location]);
        IColors.add(new PVector(r,g,b));
        }
     }
      
        
  }
  
  // this method returns the coordinates of the image within the cylinder 
 ArrayList<PVector> Image_Within_Cylinder(){
   return Points ;
 }
 // this methods returns the color information of the image 
 ArrayList<PVector> Pixels(){
     return IColors;
}
  void LetDraw(){
    
    for(int i=0; i<Points.size(); i++){
        stroke(IColors.get(i).x,IColors.get(i).y,IColors.get(i).z);
        point(Points.get(i).x,Points.get(i).y,Points.get(i).z);
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
