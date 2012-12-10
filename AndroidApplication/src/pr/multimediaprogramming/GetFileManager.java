package pr.multimediaprogramming;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class GetFileManager {
	private final static String TAG = "GetFileManager";
	
	public static final String base_url = "http://www.lapetitemaisondupoitou.fr/dev/upload/";
	
	public GetFileManager() {
		
	}
	
	public Bitmap getImageBitmapMin(String fileName) {
		try {
			URLConnection connection = new URL(base_url + fileName).openConnection();
			InputStream is = connection.getInputStream();
			BufferedInputStream bis = new BufferedInputStream(is);
			BitmapFactory.Options options = new BitmapFactory.Options();
			options.inSampleSize = 20;
			Bitmap bm = BitmapFactory.decodeStream(bis, null, options);
			is.close();
			bis.close();
			return bm;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
