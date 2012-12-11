/**
 * jabberlibPubsub by Gerald Kogler
 * example shows how to communicate con XMPP pubsub server
 * jabberlib website at http://go.yuri.at/jabberlib/
 */
 
import jabberlib.*;

Jabber jabber;

void setup() {
  noLoop();
  String host = "tik.okno.be";
  jabber = new Jabber(this,host,5222);
  jabber.login("tester@"+host,"tester");
  
  PubSub pubsub = new PubSub(jabber,"pubsub."+host);
  Object[] nodes = pubsub.getNodes();
  for (int i=0; i<nodes.length; i++){
    //subscribe to all nodes
    pubsub.subscribeToNode(nodes[i].toString());
  }
}

/* incoming events from subscribed pubsub nodes */
void pubsubEvent(String event) {
  println("received node event: "+event);
}
