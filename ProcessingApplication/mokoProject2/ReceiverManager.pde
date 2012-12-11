import jabberlib.*;

Jabber jabber;

class ReceiverManager {
  ArrayList<String> receivedImage = null;
  public PApplet parent;
  
  ReceiverManager(PApplet window) {
    receivedImage = new ArrayList<String>();
    parent = window;
  }
  
  void initJabber(){
    //noLoop();
    jabber = new Jabber(parent,"talk.google.com",5222,"gmail.com");
    jabber.login("aaltotable@gmail.com", "aaltoFinland");
    //println(users);
    jabber.createChat("aaltosender@gmail.com");
  }
  
  void addFile(String url) {
    receivedImage.add(url);
  }
  
  ArrayList<String> getFiles() {
    return receivedImage;
  }
}


/* incoming chat message are forwarded to the chatEvent method */
void chatEvent(String message) {
  println(message);
  
  imReceiver.addFile(message);

}


