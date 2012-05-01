package com.emibap.locationmanagersample;


import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;



/**
 * @author Emiliano Angelini
 */
class LocationManagerSample extends Sprite {
	
	
	private var labelTxt:TextField;
	private var btn:Sprite;
	private var statusTxt:TextField;
	
	public function new () {
		
		super ();
		initialize ();
		
	}
	
	
	private function initialize ():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		statusTxt = new TextField();
		statusTxt.defaultTextFormat = new TextFormat ("_sans", 20, 0x000000);
		statusTxt.width = 640;
		statusTxt.height = 960;
		statusTxt.x = 0;
		statusTxt.y = 0;
		statusTxt.selectable = false;
		statusTxt.multiline = true;
		statusTxt.text = "Hello-\n\n\n";
		
		labelTxt = new TextField ();
		labelTxt.defaultTextFormat = new TextFormat ("_sans", 24, 0xCCCCCC);
		labelTxt.width = 320;
		labelTxt.x = 20;
		labelTxt.y = 18;
		labelTxt.selectable = false;
		labelTxt.text = "start Updating Location";
		
		btn = new Sprite();
		btn.graphics.beginFill(0x000000, .8);
		btn.graphics.drawRoundRect(0, 0, 300, 70, 12, 12);
		btn.graphics.endFill();
		
		btn.x = 320;
		btn.y = 20;
		
		btn.addChild (labelTxt);
		
		btn.addEventListener(MouseEvent.CLICK, toggleUpdatingLocation);
		
		addChild(statusTxt);
		
		addChild(btn);
		
		
	}
	
	private function toggleUpdatingLocation(e:MouseEvent):Void {
	
		if (labelTxt.text.indexOf("start") != -1) {
			LocationManager.startUpdatingLocation(onLocationUpdate, onFinishedUpdatingLocation, onFLocationError);
			trace("- StartUpdatingLocation...");
			statusTxt.text += "\n- StartUpdatingLocation...";
			labelTxt.text = "stop Updating Location";
		} else {
			LocationManager.stopUpdatingLocation();
			trace("- StopUpdatingLocation...");
			statusTxt.text += "\n- StopUpdatingLocation...";
			labelTxt.text = "start Updating Location";
		}
	}
	
	private function onLocationUpdate(newLoc:Dynamic, oldLoc:Dynamic):Void {
		//trace("- Location arrived to haxe - latitude reported: " + newLoc.latitude + ", " + newLoc.longitude);
		statusTxt.text += "\n- Location arrived: " + Std.string(newLoc.latitude) + ", " + Std.string(newLoc.longitude);
		statusTxt.text += "\n- Location timestamp: " + Date.fromTime(newLoc.timestamp).toString();
		statusTxt.text += "\n- vs date: " + Date.now().toString();
	}
	
	private function onFinishedUpdatingLocation(status:String):Void {
		trace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    !!!!!!!!!!!!!!   Location finished Updating: " + status);
		statusTxt.text += "\n- Location finished Updating: " + Std.string(status);
		labelTxt.text = "start Updating Location";
	}
	
	private function onFLocationError(status:String):Void {
		trace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    !!!!!!!!!!!!!!   Location ERROR: " + status);
		statusTxt.text += "\n- Location ERROR: " + Std.string(status);
	}
	
	// Entry point
	
	public static function main () {
		
		Lib.current.addChild (new LocationManagerSample ());
		
	}
	
	
}