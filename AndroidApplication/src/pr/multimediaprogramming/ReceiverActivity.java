package pr.multimediaprogramming;

import java.util.ArrayList;
import java.util.List;

import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.ChatManager;
import org.jivesoftware.smack.ChatManagerListener;
import org.jivesoftware.smack.ConnectionConfiguration;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.SASLAuthentication;
import org.jivesoftware.smack.XMPPConnection;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;

public class ReceiverActivity extends Activity {
	public static String login = "aaltoreceiver@gmail.com";
	public static String password = "aaltoFinland";
	
	private Handler mHandler = new Handler();
	
	private ImageView imageView;
	private Gallery gallery;
	private int selectedImagePosition = 0;
	private int selectedImage = 0;
	
	private GalleryImageAdapter gImgAdapter;
	
	XMPPConnection connection;
	GetFileManager getFileManager;
	boolean isRunning = true;
	List<Bitmap> receivedImages;
	
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_receiver);
        
        gallery = (Gallery) findViewById(R.id.gallery1);
        imageView = (ImageView) findViewById(R.id.imageView1);
        
        receivedImages = new ArrayList<Bitmap>();
        
        gImgAdapter = new GalleryImageAdapter(this, receivedImages);
        
        gallery.setAdapter(gImgAdapter);
        
        gallery.setOnItemSelectedListener(new OnItemSelectedListener() {
			public void onItemSelected(AdapterView<?> parent, View view,
					int position, long id) {
				selectedImage = position;
				setSelectedImage(selectedImage);
				Log.d("Receiver", "POSITION ON SELECTED:" + selectedImage);
			}

			public void onNothingSelected(AdapterView<?> arg0) {
			}
        });
        
        
        if (receivedImages.size() > 0) {
            gallery.setSelection(selectedImagePosition, false);
        }
        
        getFileManager = new GetFileManager();
		new Thread(new ReceiverRunnable()).start();
    }
    
    public void onClick(View v) {
		selectedImagePosition = 1;
    	
    	gallery.setSelection(selectedImagePosition,false);
    }
    
    private void setSelectedImage(int selectedImagePosition) {
    	
    	if(selectedImagePosition >= 0 && selectedImagePosition <= receivedImages.size() && receivedImages.size() > 0) {
    		Bitmap b = receivedImages.get(selectedImagePosition);
    		imageView.setImageBitmap(b);
    		imageView.setScaleType(ScaleType.FIT_XY);
    	}
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_receiver, menu);
        return true;
    }
    
    public void loginXMPP() throws XMPPException {
    	ConnectionConfiguration config = new ConnectionConfiguration("talk.google.com", 5222, "gmail.com");
    	connection = new XMPPConnection(config);
    	
    	connection.connect();
    	SASLAuthentication.supportSASLMechanism("PLAIN", 0);
    	connection.login(login, password);
    }
    
    public String getImagePath(Message message) {
		String messageString = message.getBody();
		String[] messagePartition = messageString.split(";", 0);
    	
		Log.d("Receiver3",messagePartition.toString());
		
		if (messagePartition.length == 3) {
			return messagePartition[2];
		}
		
    	return null;
    }
    
    class ReceiverRunnable implements Runnable {
		public void run() {
			try {
				Log.d("Receiver2", "Statut : LAUNCHED");
				loginXMPP();
				ChatManager chatManager = connection.getChatManager();
				chatManager.addChatListener(new ChatManagerListener() {
					public void chatCreated(Chat chat, boolean arg1) {
						chat.addMessageListener(new MyMessageListener());
					}
				});
				Chat chat = chatManager.createChat("aaltotable@gmail.com", new MyMessageListener());
				chat.sendMessage("Connected");
			} catch (XMPPException e) {
				Log.d("Receiver2", e.toString());
			}
		}
    }
    
    //Message Listener : Get all messages sent by the Aalto Table
    class MyMessageListener implements MessageListener {
    	public void processMessage(Chat chat, Message message) {
    		Log.d("Receiver2", "Statut : "+message.getBody());
    		
    		//Get the url in the message
    		String pathImage = getImagePath(message);
    		Log.d("Receiver2", pathImage);
    		
    		//Get the image associated with the url
    		final Bitmap bm = getFileManager.getImageBitmapMin(pathImage);
    		
    		//Store the image in the image container
    		mHandler.post(new Runnable() {
				public void run() {
					receivedImages.add(bm);
					gImgAdapter.notifyDataSetChanged();
				}
    		});
    	}
    }
}
