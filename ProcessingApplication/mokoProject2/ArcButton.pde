
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
  public ArcButton(int ButtonId,int rint, int rext, float anglel, float angler){
    id = ButtonId;
    rInt = rint;
    rExt = rext;
    angleL = anglel;
    angleR = angler;
    state = false;
  }
  
    
  public void drawArcButton(){
    int i=0;
    this.setButtonState();
    noFill();
    stroke(0,0,255);
    arc(k*125,0,2*rInt,2*rInt,angleL,angleR);
    arc(k*125,0,2*rExt,2*rExt,angleL,angleR);
    line(rInt*cos(angleL) + k*125, rInt*sin(angleL), rExt*cos(angleL) + k*125, rExt*sin(angleL));
    line(rInt*cos(angleR) + k*125, rInt*sin(angleR), rExt*cos(angleR) + k*125, rExt*sin(angleR));
    
    if (this.state == true){
      for (int r=2*rInt+1;r<2*rExt-1;r++){
        stroke(0,0,255-i,100);
        arc(k*125,0,r,r,angleL, angleR);
        i=i+2;
      }
    }

  }
//
  
// set the state of the Button
  public void setButtonState(){    
    if (isPressed(this.id) == true){
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

  boolean getState(){
    return this.state;
  }
  
  void setState(boolean etat){
    this.state = etat;
  }
 
}



