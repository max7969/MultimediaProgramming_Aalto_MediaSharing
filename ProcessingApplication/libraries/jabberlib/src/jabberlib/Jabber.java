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

import processing.core.*;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.lang.reflect.Method;
import java.util.Collection;
import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.ChatManager;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.Roster;
import org.jivesoftware.smack.RosterEntry;
import org.jivesoftware.smack.XMPPConnection;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;

/**
 * A library that encapsulates the SMACK library, an "Open Source XMPP (Jabber) client library for instant messaging and presence".
 *
 * @example jabberlibIM
 * @example jabberlibGtalk
 */
public class Jabber {

	public final static String VERSION = "0.1.0";
	private PApplet myParent;	// myParent is a reference to the parent sketch
	public XMPPConnection connection;
	private Chat myChat;
	private Method chatEventMethod, pubsubEventMethod;

	/**
	 * Constructor
	 *
	 * @param parent
	 * @param host
	 * @param port
	 */
	public Jabber(PApplet parent, String host, int port) {
		this(parent,host,port,host);
	}
	
	/**
	 * Constructor
	 * 
	 * @param parent
	 * @param host
	 * @param port
	 */
	public Jabber(PApplet parent, String host, int port, String servicename) {
		myParent = parent;
		// System.out.println("jabberlib "+VERSION+" by Gerald Kogler");

		// check to see if the host applet implements event
		// void chatEvent()
		try {
			chatEventMethod = parent.getClass().getMethod("chatEvent", new Class[] { String.class });
		} catch (Exception e) {
			// no such method, or an error.. which is fine, just ignore
		}
		// void pubsubEvent()
		try {
			pubsubEventMethod = parent.getClass().getMethod("pubsubEvent", new Class[] { String.class });
		} catch (Exception e) {
			// no such method, or an error.. which is fine, just ignore
		}
		
		//connect
		this.connect(host,port,servicename);
	}
	
	/**
	 * Connect to XMPP server
	 * 
	 * @param host
	 * @param port
	 * @param servicename
	 */
	public void connect(String host, int port, String servicename) {
		ConnectionConfiguration config = new ConnectionConfiguration(host, port, servicename);
		connection = new XMPPConnection(config);
		try {
			connection.connect();
			System.out.println("jabberlib: connected to " + host + ":" + port);
		} catch (XMPPException e) {
			System.out.println("jabberlib: connecting to " + host + " on port " + port + " failed");
			// e.printStackTrace();
		}
	}

	/**
	 * Login to service XMPP service
	 * 
	 * @param user
	 * @param password
	 */
	public void login(String user, String password) {
		try {
			connection.login(user, password);
			//System.out.println("jabberlib: login successfull as " + user);
		} catch (XMPPException e) {
			System.out.println("jabberlib: login failed, check user and password");
			// e.printStackTrace();
		}
	}

	/********************* CHAT ***********************/
	/**
	 * Get list of chat contacts
	 * 
	 * @return Object[]
	 */
	public Object[] getUsers() {
		Roster roster = connection.getRoster();
	
	  Collection<RosterEntry> entries = roster.getEntries();
	  //System.out.print("jabberlib: " + entries.size() + " buddies: ");
	
	  for (RosterEntry r : entries) {
      //System.out.print(r.getUser()+", ");
	  }
    //System.out.println();
		return entries.toArray();
}

	/**
	 * Create chat with specified user
	 * 
	 * @param user
	 */
	public void createChat(String user) {
		if (connection.isConnected()) {
			ChatManager chatmanager = connection.getChatManager();

			// Eventhandler, to catch incoming chat events
			myChat = chatmanager.createChat(user, new MessageListener() {
				@Override
				public void processMessage(Chat chat, Message message) {
					// invoke received message event
					chatEvent(message.getBody());
				}
			});
			//System.out.println("jabberlib: waiting for messages from " + user);
		}
	}

	/**
	 * Message sent to chat user
	 * 
	 * @param message
	 */
	public void sendMessage(String message) {
		try {
			myChat.sendMessage(message);
			//System.out.println("jabberlib: message sent: " + message);
		} catch (XMPPException e) {
			System.out.println("jabberlib: failed sending message");
			// e.printStackTrace();
		}
	}

	/**
	 * Event invoked when receiving a chat message
	 * 
	 * @param message
	 */
	public void chatEvent(String message) {
		if (chatEventMethod != null) {
			try {
				chatEventMethod.invoke(myParent, new Object[] { message });
			} catch (Exception e) {
				System.err.println("jabberlib: Disabling chatEvent() because of an error.");
				e.printStackTrace();
				chatEventMethod = null;
			}
		}
	}

	/**
	 * Event invoked when pubsub event happens.
	 * 
	 * @param message
	 */
	public void pubsubEvent(String message) {
		if (pubsubEventMethod != null) {
			try {
				pubsubEventMethod.invoke(myParent, new Object[] { message });
			} 
			catch (Exception e) {
				System.err.println("jabberlib: Disabling pubsubEvent() because of an error.");
				e.printStackTrace();
				pubsubEventMethod = null;
			}
		}
	}

	/**
	 * return the version of the library.
	 * 
	 * @return String
	 */
	public static String version() {
		return VERSION;
	}

	public void pre() {
		// Method that's called just after beginDraw(), meaning that it can affect
		// drawing.
	}

	public void draw() {
		// Method that's called at the end of draw(), but before endDraw().
	}

	public void post() {
		// Method called after draw has completed and the frame is done. No drawing
		// allowed.
	}

	public void mouseEvent(MouseEvent e) {
		// Called when a mouse event occurs in the parent applet. Drawing is allowed
		// because mouse events are queued.
	}

	public void keyEvent(KeyEvent e) {
		// Called when a key event occurs in the parent applet. Drawing is allowed
		// because key events are queued.
	}

	public void size(int width, int height) {
		// This will be called the first time an applet sets its size, but also any
		// time that it's called while the PApplet is running. No drawing should
		// occur inside of this method, because it may not be the case that the new
		// renderer is yet valid and ready. use this only to flag the new size and
		// prepare for the next frame.
	}

	public void stop() {
		// Called to halt execution. Can be called by users, for instance
		// movie.stop() will shut down a movie that's being played, or camera.stop()
		// stops capturing video. server.stop() will shut down the server and shut
		// it down completely. May be called multiple times.
	}

	public void dispose() {
		if (connection.isConnected())
			connection.disconnect();
		// Called to free resources before shutting down. This should only be called
		// by PApplet. The dispose() method is what gets called when the host applet
		// is being shut down, so this should stop any threads, disconnect from the
		// net, unload memory, etc.
	}
}
