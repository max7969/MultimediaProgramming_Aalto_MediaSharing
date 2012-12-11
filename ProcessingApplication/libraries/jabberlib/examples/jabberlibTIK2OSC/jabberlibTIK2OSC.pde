/**
 * jabberlibTIK2OSC by Gerald Kogler
 * example shows how to communicate with TIK pubsub server.
 * provides an OSC server to other TIK clients.
 * http://timeinventorskabinet.org/wiki/doku.php/windclocks/tak
 * jabberlib website at http://go.yuri.at/jabberlib/
 */

import jabberlib.*;
import oscP5.*;
import netP5.*;

Jabber jabber;
HashMap<String,ArrayList> clockList = new HashMap<String,ArrayList>();  //keep track of clocks and tiks
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(500, 500);
  background(0);
  fill(255, 100, 100);

  //start listening to OSC messages on port 12000
  oscP5 = new OscP5(this,12000);
  //start OSC service on port 12001
  myRemoteLocation = new NetAddress("127.0.0.1",12001);

  //login to TAK
  String host = "tik.okno.be";
  jabber = new Jabber(this,host,5222);
  jabber.login("tester@"+host,"tester");
  PubSub pubsub = new PubSub(jabber,"pubsub."+host);

  //get all clocks
  Object[] nodes = pubsub.getNodes();
  for (int i=0; i<nodes.length; i++) {
    String clock = nodes[i].toString();
    clockList.put(clock,new ArrayList());

    //subscribe to all clocks
    pubsub.subscribeToNode(clock);
  }
}

void draw() {
  background(0);

  // Get all clocks in a set
  Set clockSet = clockList.entrySet();
  // Create an iterator for the set
  Iterator i = clockSet.iterator();
  int pos = 0;

  while(i.hasNext()) {
    try { 
      Map.Entry me = (Map.Entry)i.next();
      String clockName = me.getKey().toString();
      ArrayList clockMeta = (ArrayList)me.getValue();
      
      if (clockMeta.size() > 0){
        float clockValue = float(clockMeta.get(0).toString());
        text(clockName+": "+clockMeta,10,20+15*pos);
    
        // send Osc messages
        OscMessage clockMessage = new OscMessage("/clockName");
        clockMessage.add(clockName);
        oscP5.send(clockMessage, myRemoteLocation);
        OscMessage valueMessage = new OscMessage("/" + clockName);
        valueMessage.add(clockValue);
        oscP5.send(valueMessage, myRemoteLocation);
      } else {
        text(clockName + ": undefined",10,20+15*pos);
      }
      pos++;
    }
    catch (ConcurrentModificationException e) {
      //exception thrown because of pubsubEvent modifying hashmap
      break;  
    }
  }
}

/* incoming events from subscribed pubsub nodes */
void pubsubEvent(String event) {
  println("received node event: "+event);
  String xml = event.substring(event.indexOf("<item"),event.indexOf("</item>")+7);
  String id = event.substring(event.indexOf("<item id='")+10,event.indexOf("'>"));
  String[] xmllist = {xml};
  saveStrings("clockdata"+id+".xml", xmllist);
  delay(1000);
  XMLElement item = new XMLElement(this, "clockdata"+id+".xml");
  String itemid = item.getString("id");
  XMLElement clock = item.getChild(0);
  //for (int i = 0; i < clock.getChildCount(); i++) {
    XMLElement tik = clock.getChild(0);
    String idTik = tik.getChild(0).getContent();
    //println(itemid+":"+idTik);    
  //}
  ArrayList clockMeta = new ArrayList();
  clockMeta.add(int(idTik));
  //has meta values?
  if (tik.getChildCount() > 1){
    XMLElement values = tik.getChild(1);
    if (values.getName().equals("metaDataValues")){
      for (int i = 0; i < values.getChildCount(); i++) {
        XMLElement meta = values.getChild(i);
        //println(values.getChildCount()+":"+meta.getChildCount());
        String metaString = meta.getChild(2).getContent();
        metaString += ": "+meta.getChild(0).getContent();
        metaString += " ("+meta.getChild(1).getContent()+")";
        clockMeta.add(metaString);
      }
    }
  }
  clockList.put(id, clockMeta);
}
