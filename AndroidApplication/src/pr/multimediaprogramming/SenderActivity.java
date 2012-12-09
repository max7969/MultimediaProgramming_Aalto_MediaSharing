package pr.multimediaprogramming;

import java.io.*;
import java.net.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Vector;

import android.util.Log;



import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.content.*;
import android.provider.Settings.Secure;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

public class SenderActivity extends Activity {
	
	TextView mySelection;
	GridView myGallery;
	Button sendButton;
	Vector<Integer> listImages;
	private static final String TAG = "MyActivity";
	public int cpt = 0;
	public int statut = 0;
	public int lenght = 0;
	private Handler mHandler = new Handler();
	private static final String SECURITY_KEY = "Lolilol*!^^JeSuiSLaKLE";
	private String uiid;
	private PostFileManager fileManager;
	
	
	public class ImageAdapter extends BaseAdapter {
		/** The parent context */
		private Context myContext;
		// Put some images to project-folder: /res/drawable/
		// format: jpg, gif, png, bmp, ...
		
		File directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
		
		private ArrayList<File> myImageIds = getPictures(directory);
		
		/** Simple Constructor saving the 'parent' context. */
		public ImageAdapter(Context c) {
			this.myContext = c;
		}

		// inherited abstract methods - must be implemented
		// Returns count of images, and individual IDs
		public int getCount() {
			return this.myImageIds.size();
		}

		public Object getItem(int position) {
			return this.myImageIds.get(position).getPath();
		}

		public long getItemId(int position) {
			return position;
		}
		// Returns a new ImageView to be displayed,
		public View getView(int position, View convertView, 
				ViewGroup parent) {
			
			// Get a View to display image data 					
			ImageView iv = null;
					
					
			if (convertView == null) {
				iv = new ImageView(this.myContext);
				
				BitmapFactory.Options options=new BitmapFactory.Options();
				options.inSampleSize = 4;
				
				Bitmap bitmap = BitmapFactory.decodeFile(this.myImageIds.get(position).getPath(),options);
				iv.setImageBitmap(bitmap);
				
				// Image should be scaled somehow
				//iv.setScaleType(ImageView.ScaleType.CENTER);
				//iv.setScaleType(ImageView.ScaleType.CENTER_CROP);			
				//iv.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
				//iv.setScaleType(ImageView.ScaleType.FIT_CENTER);
				//iv.setScaleType(ImageView.ScaleType.FIT_XY);
				iv.setScaleType(ImageView.ScaleType.CENTER_CROP);
				iv.setPadding(2, 2, 2, 2);
				// Set the Width & Height of the individual images
				iv.setLayoutParams(new GridView.LayoutParams(90,90));
			} else {
				iv = (ImageView) convertView;
			}
			

			return iv;
		}
	}// ImageAdapter
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_sender);
		
		uiid = Secure.getString(getApplicationContext().getContentResolver(), Secure.ANDROID_ID);
		
		fileManager = new PostFileManager(uiid, SECURITY_KEY);
		
		mySelection = (TextView) findViewById(R.id.mySelection);		
		listImages = new Vector<Integer>();
		sendButton = (Button) findViewById(R.id.sendButton);
		
		// Bind the gallery defined in the main.xml
		// Apply a new (customized) ImageAdapter to it.

		myGallery = (GridView) findViewById(R.id.myGallery);

		myGallery.setAdapter(new ImageAdapter(this));
		int count = myGallery.getAdapter().getCount();
		mySelection.setText(count + " images are available");

		myGallery.setOnItemClickListener(new OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position,
					long id) {
				
				if(!listImages.contains(position)) {
					view.setBackgroundColor(Color.RED);
					listImages.add(position);
				} else {
					view.setBackgroundColor(Color.TRANSPARENT);
					listImages.remove(listImages.indexOf(position));
				}
			}
		});
		
		
		
		sendButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
					try {
						final Vector<String> listPaths = new Vector<String>();
						for(int i : listImages) {
							listPaths.add((String) myGallery.getAdapter().getItem(i));
						}
						new Thread(new Runnable() {
					        public void run() {
					        	statut = 0;
					        	lenght = listPaths.size();
					        	for(String path : listPaths) {
					        		boolean test = fileManager.postFile(path);
					        		if(test) {
					        			statut++;
					        			mHandler.post(new Runnable() {
					        				public void run() {
					        					mySelection.setText("Sending image :  " + statut + "/" + lenght);
					        				}
					        			});
					        			Log.d(TAG, "Statut : " + statut);
					        		} else {
					        			Log.d(TAG, "Sending fail");
					        		}
					        	}
					        }
					    }).start();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				
			}
		});
		
	}

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_sender, menu);
        return true;
    }
    
    public ArrayList<File> getPictures(File directory) {
    	ArrayList<File> listFiles = new ArrayList<File>();
    	for(File f : directory.listFiles()) {
    		if(f.isDirectory()) {
    			listFiles.addAll(getPictures(f));
    		} else {
    			int posPoint = f.getName().lastIndexOf('.');
    			String ext = f.getName().substring(posPoint + 1);
    			
    			if(ext.equals("jpg") || ext.equals("jpeg")) {
    				if(cpt < 10) {
    					listFiles.add(f);
    					cpt++;
    				}
    			}
    		}
    	}
    		
		return listFiles;
    }
}
