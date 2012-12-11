import processing.opengl.*;
import codeanticode.glgraphics.*;
import TUIO.*;
import de.fhpotsdam.simpletouch.*;


File folder = new File("/home/tinmar/info/arduino-processing/processing_sketchbook/mokoProject2/images");

float k = 1;  // Scaling factor
float x_old=-10000, y_old=-10000; // for detecting button activation
int W = round(k*1200); // must be >= 800
int H = round(k*800); // must be >= 600
int MAX_IM = 15; // Max number of images that can be load to the AaltoWindow
PFont myFont;
BufferedReader reader; // read pixels text file for making an array
int[] pixelsArray;
int[] buttonColorMap; // First column id of the button, second color associated
PImage fond;

ReceiverManager imReceiver;
ArrayList<String> imageUrls;
int imInc = 0; 

SimpleTouch simpleTouch;
TuioClient tuioClient;

PhoneObject phone1;
PhoneObject phone2;

// SHARED AREA : 
TouchImage[] SA_imgArray;
boolean[] SA_touchAdded;
int SA_nbImg;
int[] SA_imgListNbr; // Indicates for images from both phones the position in the touchObject List

// TESTS
PImage im1;

void setup(){  
  
  size(W,H, GLConstants.GLGRAPHICS);  
  background(0);

  /* Load the font */
  myFont = loadFont("Candara15.vlw");
  textFont(myFont);

  
  // Create the 2 phones :
  phone1 = new PhoneObject(this,1); 
  phone2 = new PhoneObject(this,2);
  
  // Create the SimpleTouch library
  simpleTouch = new SimpleTouch(this);
  //Get the TuioClient, connected to this SimpleTouch:
  tuioClient = simpleTouch.getTuioClient();
  
  buttonColorMap = new int[100];
 // Odd numbers = phone 1 - Even numbers = phone2
  buttonColorMap[0] = 0xFF000000;  // nothing
  buttonColorMap[1] = 0xFFFF0000;    buttonColorMap[2] = 0xFF800000;  // ArcButton_phone1
  buttonColorMap[3] = 0xFF00FF00;    buttonColorMap[4] = 0xFF008000;// CenterHexagon 
  buttonColorMap[5] = 0xFF0000FF;    buttonColorMap[6] = 0xFF000080;// Image Arrow Right
  buttonColorMap[7] = 0xFFFFFF00;    buttonColorMap[8] = 0xFF808000;// Image Arrow Left
  
  buttonColorMap[9] = 0xFF001000;    buttonColorMap[10] = 0xFF202020;// Image 1
  buttonColorMap[11] = 0xFF200000;   buttonColorMap[12] = 0xFF400040;// Image 2
  buttonColorMap[13] = 0xFF000030;   buttonColorMap[14] = 0xFF006060;// Image 3
  buttonColorMap[15] = 0xFF004000;   buttonColorMap[16] = 0xFFFF0080;// Image 4
  buttonColorMap[17] = 0xFF500000;   buttonColorMap[18] = 0xFF80FF80;// Image 5
 
  
  // color model for the buttons is stored in a txt file
  // Need to read the file and stock it into an int Array
  // Open the file
  createColorButtonModel();
  
  // Shared Area Init : 
  SA_imgArray = new TouchImage[2*MAX_IM]; 
  SA_touchAdded = new boolean[2*MAX_IM];
    for (int i=0; i<2*MAX_IM; i++) SA_touchAdded[i] = false;
  SA_nbImg = 0;
  SA_imgListNbr = new int[2*MAX_IM];
    for (int i=0; i<2*MAX_IM; i++) SA_imgListNbr[i] = -1;
  
  // Test Add Photos:
//  phone1.addImage("1.jpg");    phone2.addImage("21.jpg");
//  phone1.addImage("2.jpg");    phone2.addImage("22.jpg");
//  phone1.addImage("3.jpg");    phone2.addImage("23.jpg");
//  phone1.addImage("4.jpg");   // phone2.addImage("4.jpg");
//  phone1.addImage("5.jpg");   // phone2.addImage("5.jpg");  
//  phone1.addImage("7.jpg");

  fond = loadImage("wall6.jpg");
  
  // for receiving images : 
  imReceiver = new ReceiverManager(this);  
  imReceiver.initJabber();
  
  // TESTS
//im1 = loadImage("images/1.jpg");
//im1.resize(W/4,0);
} 



void draw(){

  image(fond,0,0);
  // background(0);
  
  // We received a list of string which consist in "phoneID;imageURL" 
  imageUrls = imReceiver.getFiles();
  if (imageUrls.size() > imInc){
    println("mokogin");
    String[] info = split(imageUrls.get(imInc),';');
    // info[0] now contains the phone ID, and info[1] the image url   
    
    if (phone1.getPhoneId() == int(info[0])){
      phone1.addImage(info[1]);
      println(info[1]+" added to phone1");
    }
    else if (phone2.getPhoneId() == int(info[0])){
      phone2.addImage(info[1]);
      println(info[1]+" added to phone2");
    }
    else{
      if (phone1.getPhoneId() == -1){
        phone1.setPhoneId(int(info[0]));
        phone1.addImage(info[1]);
        println(info[1]+" added to phone1");
      }
      else if(phone2.getPhoneId() == -1){
        phone2.setPhoneId(int(info[0]));
        phone2.addImage(info[1]);
        println(info[1]+" added to phone2");
      } 
    }
    imInc++;
  }
  
  updateSharedArea();
  simpleTouch.draw();

  pushMatrix();
  translate(W-k*20, H/2);
  phone1.updatePhoneObject();
  phone1.drawInterface();
  popMatrix();
  pushMatrix();
  translate(k*20, H/2);
  rotate(PI);
  phone2.updatePhoneObject();
  phone2.drawInterface();
  popMatrix();
  
  showTuioCursors();

  // TESTS ;
//  image(im1,199,100);
 
  
}


// The Shared Area allows to share photos,
// Every picture in the shared area is accessible to both users

void updateSharedArea(){
  for (int i=0; i<2*MAX_IM; i++){
    // If the image is in the shared area and was not before :
    if (SA_imgArray[i] != null && SA_touchAdded[i] == false){
       println("Image added to the shared area");
       // Add it to the simpleTouch interface
       simpleTouch.addTouchObject(SA_imgArray[i]);
       // Tag it as added to the shared area.
       SA_touchAdded[i] = true;
       // Update the image list number array: 
       SA_imgListNbr[i] = SA_nbImg;
       // Increment the SA_nbImg variable :
       SA_nbImg++;
    }
    // If the image was in the shared Area and is not selected anymore, delete it
    if (SA_imgArray[i] == null && SA_touchAdded[i] == true){
      println("Image removed of the shared area");
      // Tag it as removed from the shared area:
      SA_touchAdded[i] = false;
      // Remove it from the simpleTouch touchObject list:
      simpleTouch.getTouchObjects().remove(SA_imgListNbr[i]);
      // Update the image list number array: 
      // (for each image which are in the list after the removed image, decrement the index nbr)
      for (int k=0; k<2*MAX_IM; k++){
        if (SA_imgListNbr[k] > SA_imgListNbr[i]){
          SA_imgListNbr[k] = SA_imgListNbr[k] - 1;
        }
      }
      // Decrement the SA_nbImg variable :
      SA_nbImg--;     
    }
  }
}





/////////////////////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



// Coordinate conversion functions :
int polar2x(int r, float angle){
  return round(k*125 + k*r*cos(angle));  
}
int polar2y(int r, float angle){
  return round(k*r*sin(angle));
}


// Return true if the button is pressed AND was not pressed before
// Each button is characterized by a different color associated to each button_id 
boolean isPressed(int button_id){
    Vector tuioCursorList = tuioClient.getTuioCursors();
    
    float y=0, x=0;
    float r=0, theta=0;
    TuioCursor tcur = null;
    if (tuioCursorList == null) return false;
    for (int i=0;i<tuioCursorList.size();i++){    
      
      tcur = (TuioCursor) tuioCursorList.elementAt(i);
      Vector pointList = tcur.getPath();
      // The button is pressed only if the first touch contact is on the button:
      TuioPoint startPoint = (TuioPoint) pointList.firstElement();
      
      x = ((float) (startPoint.getScreenX(W))/W)*1200;   //BUTTON
      y = ((float) (startPoint.getScreenY(H))/H)*800;    //BUTTON
//      println("x = "+x+" y = "+y);
//      println("x_old = "+x_old+" y_old = "+y_old);
     
      if (buttonColorMap[button_id] == (pixelsArray[round(1200*y+x)])){// && abs(x_old - x)>0.01 && abs(y_old - y)>0.01){ 
       // x_old = x;  y_old = y;
        delay(100);
        return true;      
      }
    }
    // Interact with the mouse
    x = ( (float) mouseX/W)*1200;    //BUTTON
    y = ( (float) mouseY/H)*800;     //BUTTON

  //  println("x = "+x+" y = "+y);
  //  println(hex(pixelsArray[round(1200*y+x)]));
    if (buttonColorMap[button_id] == (pixelsArray[round(1200*y+x)])){
      delay(100);
      return true;      
    }
    return false;
    
}



void showTuioCursors(){
  Vector tuioCursorList = tuioClient.getTuioCursors();
  for (int i=0;i<tuioCursorList.size();i++) {
      TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
      Vector pointList = tcur.getPath();
      
      if (pointList.size()>0) {
        stroke(0,0,255);
        TuioPoint start_point = (TuioPoint)pointList.firstElement();;
        for (int j=0;j<pointList.size();j++) {
           TuioPoint end_point = (TuioPoint)pointList.elementAt(j);
           line(start_point.getScreenX(width),start_point.getScreenY(height),end_point.getScreenX(width),end_point.getScreenY(height));
           start_point = end_point;
        }
        
        stroke(192,192,192);
        fill(192,192,192);
        ellipse( tcur.getScreenX(width), tcur.getScreenY(height),5,5);
        fill(0);
        text(""+ tcur.getCursorID(),  tcur.getScreenX(width)-5,  tcur.getScreenY(height)+5);
      }
   }
}

void createColorButtonModel(){
  reader = createReader("pixelsArray5.txt");
  String valStr;
  int val=0;
  pixelsArray = new int[960000];
  
  for (int i=0; i<1200*800; i++){
    try {
      valStr = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      valStr = null;
    }
    if (valStr != null){
      pixelsArray[i] = int(valStr);
    }
  }
}

boolean sketchFullScreen() {
  return true;
}
