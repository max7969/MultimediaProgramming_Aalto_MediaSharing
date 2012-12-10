package pr.multimediaprogramming;

import java.util.List;

import android.app.Activity;
import android.graphics.Bitmap;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Gallery;
import android.widget.ImageView;

public class GalleryImageAdapter extends BaseAdapter {
	
	private Activity context;
	
	private static ImageView imgView;
	
	private List<Bitmap> plotImages;
	
	private static ViewHolder viewHolder;
	
	public GalleryImageAdapter (Activity context, List<Bitmap> plotImages) {
		this.context = context;
		this.plotImages = plotImages;
	}
	
	public int getCount() {
		return plotImages.size();
	}

	public Object getItem(int arg0) {
		return null;
	}

	public long getItemId(int arg0) {
		return 0;
	}

	public View getView(int position, View convertView, ViewGroup parent) {
		
		if (convertView == null) {
			viewHolder = new ViewHolder();
			imgView = new ImageView(this.context);
			imgView.setPadding(3, 3, 3, 3);
			convertView = imgView;
			viewHolder.imageView = imgView;
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder)convertView.getTag();
		}
		
		viewHolder.imageView.setImageBitmap(plotImages.get(position));

		viewHolder.imageView.setScaleType(ImageView.ScaleType.FIT_XY);
		viewHolder.imageView.setLayoutParams(new Gallery.LayoutParams(150, 90));

        return imgView;
	}
	
	private static class ViewHolder {
		ImageView imageView;
	}

}
