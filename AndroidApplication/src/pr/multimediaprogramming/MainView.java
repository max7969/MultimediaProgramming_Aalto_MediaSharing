package pr.multimediaprogramming;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainView extends Activity implements View.OnClickListener {
	
	Button button_sender;
	Button button_receiver;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_view);
        
        button_sender = (Button) findViewById(R.id.button_sender);
        button_receiver = (Button) findViewById(R.id.button_receiver);
        
        button_sender.setOnClickListener(clickListenerSenderButton);
        button_receiver.setOnClickListener(clickListenerReceiverButton);
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
	
	private OnClickListener clickListenerReceiverButton = new View.OnClickListener() {
		public void onClick(View v) {
			Intent intent = new Intent(MainView.this,ReceiverActivity.class);
			startActivity(intent);
		}
	};
    
    
}
