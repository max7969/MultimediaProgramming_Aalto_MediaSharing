import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class SimpleHexagon extends PApplet {

Hexagon hexagon;

public void setup(){
  hexagon = new Hexagon(this, 0, 0, 15);
}

public void draw(){
  hexagon.drawHex();
}
class Hexagon {
	
	 protected PApplet parent;
	 protected PGraphics buffer;
	 protected float a;
	 protected float b;
	 protected float c;
	 private int startX;
	 private int startY;
	 
	public Hexagon(Object p, int newStartX, int newStartY, int sideLength){
			if (p instanceof PGraphics)
				buffer = (PGraphics) p;
			
			if (p instanceof PApplet)
				parent = (PApplet) p;
			
			setStartX(newStartX);
			setStartY(newStartY);
			c = sideLength;
			a = c/2;
			b = parent.sin(parent.radians(60))*c;
		}

	public void drawTranslatedHex(){

		parent.pushMatrix();
		parent.translate(getStartX(), getStartY());
		//draw hex shape
		drawHex();
		parent.popMatrix();
	}
	
	public void drawHex(){
		//draw hex shape
		parent.beginShape();
			parent.vertex(0,b);
			parent.vertex(a,0);
			parent.vertex(a+c,0);
			parent.vertex(2*c,b);
			parent.vertex(a+c,2*b);
			parent.vertex(a+c,2*b);
			parent.vertex(a,2*b);
			parent.vertex(0,b);
		parent.endShape();
	}

	public void setStartX(int startX) {
		this.startX = startX;
	}

	public int getStartX() {
		return startX;
	}

	public void setStartY(int startY) {
		this.startY = startY;
	}

	public int getStartY() {
		return startY;
	}
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#dcdcdc", "SimpleHexagon" });
  }
}
