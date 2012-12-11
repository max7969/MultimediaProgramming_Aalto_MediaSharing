class TouchImage extends TouchObject {

  PImage img;
  String filename;

  public TouchImage(PApplet p, PImage image, String name,  float offsetX, float offsetY) {
    super(p, offsetX, offsetY, image.width, image.height);
    this.img = image;
    this.filename = name;
  }

  public void internalDraw() {
    pg.background(0);
    pg.image(img, 0, 0, width, height);

  }
}

