package pr.multimediaprogramming;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class MainView extends Activity implements View.OnClickListener {
	
	Button button_sender;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_view);
        
        button_sender = (Button) findViewById(R.id.button_sender);
        
        button_sender.setOnClickListener(clickListenerSenderButton);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main_view, menu);
        return true;
    }

	public void onClick(View v) {
		
	}
	
	private OnClickListener clickListenerSenderButton = new View.OnClickListener() {
		public void onClick(View v) {
			Intent intent = new Intent(MainView.this, SenderActivity.class);
			startActivity(intent);
		}
	};
    
    
}
