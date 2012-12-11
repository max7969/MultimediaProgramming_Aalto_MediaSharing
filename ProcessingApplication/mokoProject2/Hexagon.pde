class Hexagon {
	
	 protected PApplet parent;
	 protected PGraphics buffer;
	 protected float a;
	 protected float b;
	 protected float c;
        
	 private int startX;
	 private int startY;
         protected boolean state;
         protected int id;

	 
	public Hexagon(Object p, int id, int newStartX, int newStartY, int sideLength){
			if (p instanceof PGraphics)
				buffer = (PGraphics) p;
			
			if (p instanceof PApplet)
				parent = (PApplet) p;
			
			setStartX(newStartX);
			setStartY(newStartY);
			c = sideLength;
			a = c/2;
			b = parent.sin(parent.radians(60))*c;
                        state = false;
                        this.id = id;
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

        public void setButtonState(){
          if (isPressed(2+this.id) == true){
            this.state = !state;
            delay(100);
          }
        }
       
        public boolean getState(){
          return this.state;
        }
        
        public void setState(boolean etat){
          this.state = etat;
        }
}
