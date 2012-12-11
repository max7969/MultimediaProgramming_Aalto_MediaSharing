package de.fhpotsdam.simpletouch;

import processing.core.PApplet;
import TUIO.TuioCursor;

/**
 * Object can be transformed by fingers / TuioCursors.
 * 
 * Enables dragging
 * 
 */
public abstract class TouchObject extends TransformableObject {
	
	
	TuioCursor tuioCursor1 = null;
	TuioCursor tuioCursor2 = null;

	private float oldAngle;
	private float oldDist;

	private float oldX;
	private float oldY;
	
	protected boolean tapped;

	public TouchObject(PApplet p, float offsetX, float offsetY, float width,
			float height) {
		super(p, offsetX, offsetY, width, height);
	}

	protected float getDistance(TuioCursor tuioCursor1, TuioCursor tuioCursor2) {
		return PApplet.dist(tuioCursor1.getScreenX(p.width), tuioCursor1.getScreenY(p.height),
				tuioCursor2.getScreenX(p.width), tuioCursor2.getScreenY(p.height));
	}

	protected float getAngleBetween(TuioCursor tuioCursor1, TuioCursor tuioCursor2) {
		return getAngleBetween(tuioCursor1.getScreenX(p.width), tuioCursor1.getScreenY(p.height),
				tuioCursor2.getScreenX(p.width), tuioCursor2.getScreenY(p.height));
	}

	public void addTuioCursor(TuioCursor tuioCursor) {
		if (tuioCursor1 == null) {
			setTapped(true);

			tuioCursor1 = tuioCursor;

			oldX = tuioCursor1.getScreenX(p.width);
			oldY = tuioCursor1.getScreenY(p.height);

		} else if (tuioCursor2 == null) {
			tuioCursor2 = tuioCursor;

			oldAngle = getAngleBetween(tuioCursor1, tuioCursor2);
			oldDist = getDistance(tuioCursor1, tuioCursor2);
		} else {
			PApplet.println("Already 2 cursors in use for rotation. Omitting further ones.");
		}
	}

	public void removeTuioCursor(TuioCursor tuioCursor) {
		if (tuioCursor2 != null && tuioCursor2.getCursorID() == tuioCursor.getCursorID()) {
			// Remove 2nd cursor
			tuioCursor2 = null;
			oldX = tuioCursor1.getScreenX(p.width);
			oldY = tuioCursor1.getScreenY(p.height);
		}

		if (tuioCursor1 != null && tuioCursor1.getCursorID() == tuioCursor.getCursorID()) {
			// Remove 1st cursor
			tuioCursor1 = null;
			// If 2nd still is on object, switch cursors
			if (tuioCursor2 != null) {
				tuioCursor1 = tuioCursor2;
				tuioCursor2 = null;
				// Shall not jump after switching, so a "new" oldPos is stored for diff calc.
				oldX = tuioCursor1.getScreenX(p.width);
				oldY = tuioCursor1.getScreenY(p.height);
			}
			else {
				setTapped(false);
			}
		}
	}

	public void updateTuioCursor(TuioCursor tcur) {
		if (tuioCursor1 != null && tuioCursor2 != null) {
			// Two fingers: rotate and scale

			if (tuioCursor2.getCursorID() == tcur.getCursorID()) {
				setTransCenter(tuioCursor1.getScreenX(p.width), tuioCursor1.getScreenY(p.height));
			} else {
				setTransCenter(tuioCursor2.getScreenX(p.width), tuioCursor2.getScreenY(p.height));
			}

			float newAngle = getAngleBetween(tuioCursor1, tuioCursor2);
			float angle = newAngle - oldAngle;
			oldAngle = newAngle;
			rotate(angle);

			float newDist = getDistance(tuioCursor1, tuioCursor2);
			float newScale = newDist / oldDist;
			oldDist = newDist;
			scale(newScale);

		} else if (tuioCursor1 != null) {
			// One finger: move
			float x = tuioCursor1.getScreenX(p.width);
			float y = tuioCursor1.getScreenY(p.height);
			float dx = x - oldX;
			float dy = y - oldY;

			addOffset(dx, dy);

			oldX = x;
			oldY = y;
		}
	}
	
	public void tapped() {
	}
	
	protected void setTapped(boolean tapped) {
		this.tapped = tapped;
		if (!tapped) {
			// Send tapped event if release
			tapped();
		}
	}
	
	public boolean isTapped() {
		return tapped;
	}

}
