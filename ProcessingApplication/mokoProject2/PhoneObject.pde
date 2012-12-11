

class PhoneObject{
  public PApplet parent;
  protected int id;            // id = 1 or 2
  protected int phoneId;      // real phone id
  protected boolean activated;  // true if phone connected to the Aalto window
  protected ArcButton arcButton1;
  // images :
  protected int nbImages;
  protected PImage[] imgSmallArray;
  protected String[] imgNameArray;
  protected TouchImage[] imgTouchArray;
  protected int indexPrintImages;
  protected boolean[] imgSelArray; // true if image is selected...
  // Shared Area related fields:
  protected boolean[] imgShared; // Indicates if image is shared or not 
  // Central Hexagon:
  protected Hexagon hexagon;
  
  
  // Constructor :
  public PhoneObject(PApplet p, int ID){
    this.parent = p;
    this.id = ID;
    this.phoneId = -1;
    this.activated = false;
    this.arcButton1 = new ArcButton(ID,round(k*260),round(k*290), 2*PI/3, 7*PI/8);
    // images :
    this.nbImages = 0;
    this.imgSmallArray = new PImage[MAX_IM];
    this.imgNameArray = new String[MAX_IM];
    this.imgTouchArray = new TouchImage[MAX_IM];
    this.indexPrintImages = 0;
    this.imgSelArray = new boolean[MAX_IM];
      for (int i=0; i<MAX_IM; i++) imgSelArray[i] = false;
    this.imgShared = new boolean[MAX_IM];
      for (int i=0; i<MAX_IM; i++) imgShared[i] = false;
    /* Hexagon */
    hexagon = new Hexagon(this.parent, ID, 0, 0, round(k*20));
  }
    
  // Function called in draw loop
  public void updatePhoneObject(){

    if (this.activated == false){  
    }
    this.activated = true; //ACTIVATED;     
    
    // Add photos to the shared area
    // For each image
    for (int i=0; i<this.nbImages; i++){
      // If the image is selected AND the image is not already shared :
      if (this.imgSelArray[i] == true && SA_touchAdded[(this.id - 1)*MAX_IM + i] == false){
        // Add the image to the shared area image array at specific position 
        SA_imgArray[(this.id - 1)*MAX_IM + i] = this.imgTouchArray[i];
      }
      // If the image is not selected and was previously shared :
      if (this.imgSelArray[i] == false && SA_touchAdded[(this.id - 1)*MAX_IM + i] == true){

        SA_imgArray[(this.id - 1)*MAX_IM + i] = null;
      }      
    }
    
    if (this.arcButton1.getState() == true){
      this.takeSharedImages(); 
      this.arcButton1.setState(false);
    }
    
    // Hexagon button:
    hexagon.setButtonState();
    if (hexagon.getState() == true){
      this.removeSelectedImages("moko");
      hexagon.setState(false);
    }
    
  }
  
  
   public void remove(){
   this.id = -1;
   this.activated = false;
 }
 
  
  @Override public String toString(){
    String str;
    if (this.activated == false){
      str = "This phone object is not activated";
    }
    else{
     str = "Phone number = "+this.id+"\n";
    }
    return str;
  }
  
  
  public void drawInterface(){

    
  //CORE SHAPE
  stroke(0,0,255);
  line(0,k*125,0,k*25);
  line(0,k*25,-k*20,k*15);
  line(-k*20,k*15,-k*20,-k*15);
  line(-k*20,-k*15,0,-k*25);
  line(0,-k*25,0,-k*125);
  line(0,-k*125,-k*40,-k*165);
  line(-k*40,k*165,0,k*125);
  noFill();
  arc(k*125,0,k*467,k*467,3*PI/4,5*PI/4);
  noStroke();
  drawGradient(0,0,k*35);
  
  // PHONE NAME
  pushMatrix();
  rotate(-PI/2);
  fill(0, 0, 255, 200);
  text("Phone "+this.id,-k*30,-k*60);  
  popMatrix();
  

  // ARC STATIC
  noFill();
  stroke(0,0,50);
  smooth();
  for (int i=0; i<10; i++){
    arc(k*125,0,k*(500+i),k*(500+i), 2*PI/3, PI - 0.1);
    arc(k*125,0,k*(500+i),k*(500+i), PI + 0.1, 4*PI/3);
  }
  
  // HEXAGON
  pushMatrix(); 
  //stroke(0,0,255);
  fill(0,0,255,70);
  translate(-k*114,-k*20);
  rotate(PI/2);
  hexagon.drawHex();  
  popMatrix();
  
  //NbIMAGES PANEL
  stroke(0,0,255); noFill();
  arc(k*125, 0, k*2*240, k*2*240, 5*PI/4-0.25, 5*PI/4);
  arc(k*125, 0, k*2*350, k*2*350, 5*PI/4-0.3, 5*PI/4);
  line(-k*45, -k*170, -k*123, -k*248);
  line(-k*81, -k*122, -k*133 ,-k*153);
  line(-k*133 ,-k*153, -k*149, -k*145);
  line(-k*149, -k*145, -k*185 , -k*163);  
  pushMatrix();
  // TEXT PHOTOS
  translate(-k*45, -k*170); 
  rotate(5*PI/4);
  fill(0,0,255);
  text("photos", 20,-5);
  translate(k*45,-k*40);
  rotate(PI/2);
  text(this.nbImages, 0,0);
  popMatrix();
  
  
  // PHOTO PRINTING ZONE
  noFill();
  stroke(0,0,50);
  smooth();
  for (int i=0; i<5; i++){
    arc(k*125,0,k*2*310+i,k*2*310+i, 2*PI/3, PI+0.25);
    arc(k*125,0,k*2*370+i,k*2*370+i, 2*PI/3, PI+0.25);
  }
  

  // BUTTON FOR IMAGES
  // Print only if necessary
  if (this.nbImages > 5){  
    noFill();
    stroke(0,0,255);
    // Right button:
    float angl_bir_1 = PI+0.25;
    float angl_bir_2 = PI+0.3;
    int r_bir_1 = 325;
    int r_bir_2 = 360;
    int r_bir_3 = round(r_bir_1 + (r_bir_2 - r_bir_1)/2);
    
    line(polar2x(r_bir_1,angl_bir_1),polar2y(r_bir_1,angl_bir_1),polar2x(r_bir_2,angl_bir_1),polar2y(r_bir_2,angl_bir_1));
    line(polar2x(r_bir_1,angl_bir_1),polar2y(r_bir_1,angl_bir_1),polar2x(r_bir_3,angl_bir_2 ),polar2y(r_bir_3,angl_bir_2 ));
    line(polar2x(r_bir_2,angl_bir_1),polar2y(r_bir_2,angl_bir_1),polar2x(r_bir_3,angl_bir_2 ),polar2y(r_bir_3,angl_bir_2 ));
    
    // Left Button:
    float angl_bil_1 = 2*PI/3;
    float angl_bil_2 = 2*PI/3 - 0.05;
    int r_bil_1 = 325;
    int r_bil_2 = 360;
    int r_bil_3 = round(r_bil_1 + (r_bil_2 - r_bil_1)/2);
    
    line(polar2x(r_bil_1,angl_bil_1),polar2y(r_bil_1,angl_bil_1),polar2x(r_bil_2,angl_bil_1),polar2y(r_bil_2,angl_bil_1));
    line(polar2x(r_bil_1,angl_bil_1),polar2y(r_bil_1,angl_bil_1),polar2x(r_bil_3,angl_bil_2 ),polar2y(r_bil_3,angl_bil_2 ));
    line(polar2x(r_bil_2,angl_bil_1),polar2y(r_bil_2,angl_bil_1),polar2x(r_bil_3,angl_bil_2 ),polar2y(r_bil_3,angl_bil_2 ));
  }
  
  arcButton1.drawArcButton();
  
  this.printImages();
  
 }
 

  public void printImages(){
    
    if (isPressed(4+this.id) == true){ // Image Arrow Right
      if (this.indexPrintImages < ceil(this.nbImages/5)){  //eg: for 7 images, = 1
        this.indexPrintImages++;
      }
    }
    if (isPressed(6+this.id) == true){ // Image Arrow Left
      if (this.indexPrintImages > 0){
        this.indexPrintImages--;
      }
    }

    // Checks if the user selects images :
    for (int i=5*this.indexPrintImages; i<min(this.nbImages, 5*this.indexPrintImages+5); i++){ 
      if (isPressed(8+this.id+2*(i%5)) == true){
        this.imgSelArray[i] = !this.imgSelArray[i];
      }
    }
 
    for (int i=5*this.indexPrintImages; i<min(this.nbImages, 5*this.indexPrintImages+5); i++){
    //  int w = round(imgSmallArray[i].width*k*50/imgSmallArray[i].height);
      int w = round(k*70);
      int h = round(k*50);
      
      float angle = 2*PI/3 + (i%5)*PI/12+0.025;
      pushMatrix();
      translate(polar2x(368,angle), polar2y(368,angle));
      rotate(angle+PI/2+PI/24);
  
      // if the image is selected, add a border:
      smooth();
      if (this.imgSelArray[i] == true){
        stroke(255,255,255);
        line(-1,-1, w+1, -1);
        line(w+1,-1, w+1, h+1);
        line(w+1, h+1, -1, h+1);
        line(-1, h+1, -1, -1);
      }
      image(this.imgSmallArray[i],0,0,w, h);
      popMatrix();      
    }
   
 }
 
 
 // Add image to the phone object, return 1 if OK, 0 else
 public int addImage(String fileName){
   if (nbImages == 0){
         this.imgSmallArray = new PImage[MAX_IM];
         this.imgTouchArray = new TouchImage[MAX_IM];
   }
//   PImage im = loadImage(folder+"/"+fileName); 
   PImage im = loadImage(fileName);
   PImage imT = im;
   if(im==null){
     println("error while loading the image");
     return 0;   
   }
   if (this.nbImages == MAX_IM){
     println("Maximal number of photos reached");
     return 0;
   }
   else{
     imT.resize(W/4,0);
     this.imgTouchArray[nbImages] = new TouchImage(this.parent, imT,fileName, 300+random(k*W/4), random(H-H/5)); // offset in order to make it appear randomly on the sared area
     this.imgTouchArray[nbImages].rotate(-PI/4+random(2*PI/4));
     this.imgSmallArray[nbImages] = im;
     this.imgNameArray[nbImages] = fileName;
     this.nbImages++;    
     return 1;
   }
 }
 
 void removeSelectedImages(String fileName){

  for (int i=0; i<MAX_IM; i++){
    if (imgNameArray[i] == fileName){
           
    }
  }  
}
 
 // Get the images from the other phone which are in the shared area:
 void takeSharedImages(){
   String fileN;
   boolean gotIt = false;
   int start = -1, end = -1;
   
   if (this.id == 1){  // phone 1 access to phone 2 pictures
     start = MAX_IM;  end = 2*MAX_IM;
   }                  
   else{              // phone 2 access to phone 1 pictures
      start = 0; end =MAX_IM;
   }
   
   // For each image of the shared zone from the other phone:
   for (int i=start; i<end; i++){
     if (SA_imgArray[i] != null){
       // Get the filename of the shared image
       fileN = SA_imgArray[i].filename;
       gotIt = false;
       // Check if the phone does not already have a picture with the same filename:
       for (int j=0; j<MAX_IM; j++){
          if (this.getImageNameArray()[j] == fileN){
            gotIt = true;
          }  
       }
       if (gotIt == false){
         this.addImage(SA_imgArray[i].filename);  
       }
       else{
        println("Image " + fileN +" already on phone"+this.id);   
       }  
     }
   }
 }
     

   
   

 // ---------- ACCESSEURS ----------- //
 

 
 String[] getImageNameArray(){
   return this.imgNameArray;
 }
 
 int getPhoneId(){
   return this.phoneId;
 }

// ---------- SET ----------- //
 
 void setPhoneId(int pId){
   this.phoneId = pId;
 }
 
 
} // End of the class

  
void drawGradient(float x, float y, float rf){
  int radius = round(rf);
  float r1 = 0;
  float g1 = 0;
  float b1 = 0;
  float dr = ( 30 - r1) / radius;
  float dg = ( 0 - g1) / radius;
  float db = (200 - b1) / radius;
  
  for (int r = radius; r > 0; --r) {
    fill(r1, g1, b1);
    ellipse(x, y, r, r);
    r1 += dr;
    g1 += dg;
    b1 += db;
  }
}
