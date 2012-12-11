/**
 * A library that encapsulates the SMACK library, an "Open Source XMPP (Jabber) client library for instant messaging and presence".
 *
 * (c) 2011
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author		Gerald Kogler 
 * @modified	17/03/2011
 * @version		0.2
 */

package jabberlib;

import java.util.Iterator;
import java.util.Vector;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smackx.packet.DiscoverItems;
import org.jivesoftware.smackx.pubsub.ItemPublishEvent;
import org.jivesoftware.smackx.pubsub.Node;
import org.jivesoftware.smackx.pubsub.PayloadItem;
import org.jivesoftware.smackx.pubsub.PubSubManager;
import org.jivesoftware.smackx.pubsub.listener.ItemEventListener;

/**
 * PubSub gives access to <a href="http://xmpp.org/extensions/xep-0060.html">XMPP pubsub service</a>.
 * 
 * @example jabberlibPubsub
 * @example jabberlibTIK2OSC
 */
public class PubSub {

	private Jabber jabber;	// myParent is a reference to the parent sketch
	private PubSubManager manager;

	/**
	 * Constructor
	 *
	 * @param parent
	 * @param host
	 */
	public PubSub(Jabber parent, String host) {
		jabber = parent;
		// System.out.println("jabberlib "+VERSION+" by Gerald Kogler");

		// Create connection to pubsub service.
		manager = new PubSubManager(jabber.connection, host);
	}
	
	/**
	 * Get list of nodes from pubsub service.
	 * 
	 * @return Object[]
	 */
	public Object[] getNodes(){
		Vector nodes = new Vector();
	  try {
	    DiscoverItems items = manager.discoverNodes(null);
	    Iterator<DiscoverItems.Item> it = items.getItems();

	    while (it.hasNext()) {
	      DiscoverItems.Item item = it.next();
	      //System.out.println("jabberlib: Node found:"+item.getNode());
	      nodes.add(item.getNode());
	    }
	  } 
	  catch(XMPPException e) {
	    System.out.println("jabberlib: retrieving nodes failed:");
	    e.printStackTrace();
	  }
	  return nodes.toArray();
	}
	
	/**
	 * Subscribe to a pubsub service node and listen to published events.
	 * 
	 * @param nodeId
	 */
	public void subscribeToNode(String nodeId)
	{		
	  try {
	    //retrieve nodes
	    Node myNode = manager.getNode(nodeId);
	    ItemEventListener myEventHandler = new ItemEventListener<PayloadItem>(){
				@Override
	      public void handlePublishedItems(ItemPublishEvent<PayloadItem> subNode) 
	      {
				  //System.out.println("jabberlib: new EVENT:"+subNode.getItems().toString());
					jabber.pubsubEvent(subNode.getItems().toString());
	      }
	    }; 
	    myNode.addItemEventListener(myEventHandler);
	    myNode.subscribe(jabber.connection.getUser());
	    //System.out.println("jabberlib: subscribed to "+nodeId);
	  }
	  catch (XMPPException e)
	  {
	    System.out.println("jabberlib: subscribe to node failed");
	    e.printStackTrace();
	  }
	}
}
