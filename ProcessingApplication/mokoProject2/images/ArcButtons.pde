
class ArcButton{
  
  // Bouton is limited between rInt and rExt and angleL and angleR - In radial coordonates
  protected int id;
  protected int rInt;  // Interior radius 
  protected int rExt;  // Exterior radius
  protected float angleL;
  protected float angleR;  
  // State of the button - ON(true) or OFF(false)
  protected boolean state;
  
  // Constructor:
  public ArcButton(int ButtonId, int rint, int rext, float anglel, float angler){
    id = ButtonId;
    rInt = rint;
    rExt = rext;
    angleL = anglel;
    angleR = angler;
    state = false;
  }
  

    
  public void drawArcButton(){

    this.setButtonState();
    if (this.state == false)  stroke(0,0,100);
    else stroke(0,0,200);
    
    arc(0,0,rInt,rInt,angleL,angleR);
    arc(0,0,rExt,rExt,angleL,angleR);
    line(rInt/2*cos(angleL), rInt/2*sin(angleL), rExt/2*cos(angleL), rExt/2*sin(angleL));
    line(rInt/2*cos(angleR), rInt/2*sin(angleR), rExt/2*cos(angleR), rExt/2*sin(angleR));  

  }
    
    
  // Check if the button is pressed
  public boolean isPressed(Vector tuioCursorList){
    
    float y=0, x=0;
    float r=0, theta=0;
    TuioCursor tcur = null;
    if (tuioCursorList == null) return false;
    for (int i=0;i<tuioCursorList.size();i++){    
      
      
      tcur = (TuioCursor) tuioCursorList.elementAt(i);
      Vector pointList = tcur.getPath();
      // The button is pressed only if the first touch contact is on the button:
      TuioPoint startPoint = (TuioPoint) pointList.firstElement();
      
      x = (startPoint.getScreenX(W) - phone1.getCenterX());
      y = (startPoint.getScreenY(H) - phone1.getCenterY());
     
      r = sqrt(sq(x)+sq(y));
      
      if (x==0){
        return false;
      }
      if (x > 0){
        theta = atan(y/x) ;
        if (theta < 0)  theta = theta + 2*PI;
      }
      else{
          theta = PI + atan(y/x);
         
      }
      println("r = "+r + " -- theta = "+theta);  
   
      if (r > this.rInt && r < this.rExt && theta > angleL+phone1.getAngle() && theta < angleR+phone1.getAngle() ){
        return true;
      }
      else{
        return false;
      } 
    }
    return false;
  }
  

  // set the state of the Button
  public void setButtonState(){
    
    if (this.isPressed(phone1.getTuioCursorList()) == true){
      this.state = !state;
      delay(100);
    }

  }
  
  @Override public String toString(){
    String str;
    if (this.state == true){
      str = "Button "+this.id+" is ON";
    }
    else{
      str = "Button "+this.id+" is OFF";
    }
    return str;
  }
 
 
 
 
 
 
}


