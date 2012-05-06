package com.emibap.locationmanagersample;

import haxe.BaseCode;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;
import haxemap.Map;

/**
 * @author Emiliano Angelini
 *
 * **IMPORTANT**
 *	If you use the sample code, dont't expect it to have the same functionality than a commercial GPS or Apple's Maps App.
 *
 *  This code simply returns location updates and marks them in a map. 
 *  For a more accurate usage of the Location API you should read something like this (Objective C code):
 *  http://stackoverflow.com/questions/1081219/optimizing-cllocationmanager-corelocation-to-retrieve-data-points-faster-on-the
 *
 */
 
class LocationManagerSample extends Sprite {
	
	
	private var labelTxt:TextField;
	private var btn:Sprite;
	private var statusTxt:TextField;
	private var map:Map;
	
	public var debug:Bool;
	public var firstLock:Bool;
	
	public function new () {
		
		super ();
		
		//debug = true;
		firstLock = true;
		
		initialize ();
		
		/*
		Authorization status values:
		0: Not Determined
		1: Restricted
		2: Denied
		3: Authorized
		*/
		log("AuthorizationStatus: " + LocationManager.authorizationStatus());
		log("LocationServicesEnabled: " + LocationManager.locationServicesEnabled());
		log("HeadingAvailable: " + LocationManager.headingAvailable());

	}

	
	private function initialize ():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		map = new Map();
		addChild(map);
		map.init();
		
		statusTxt = new TextField();
		statusTxt.defaultTextFormat = new TextFormat ("_sans", 20, 0x000000);
		statusTxt.width = 640;
		statusTxt.height = 960;
		statusTxt.x = 0;
		statusTxt.y = 0;
		statusTxt.selectable = false;
		statusTxt.multiline = true;
		statusTxt.text = "Hello-\n\n\n";
		statusTxt.mouseEnabled = false;

		labelTxt = new TextField ();
		labelTxt.defaultTextFormat = new TextFormat ("_sans", 24, 0xCCCCCC);
		labelTxt.width = 320;
		labelTxt.x = 20;
		labelTxt.y = 34;
		labelTxt.selectable = false;
		labelTxt.text = "start Updating Location";
		
		btn = new Sprite();
		btn.graphics.beginFill(0x000000, .8);
		btn.graphics.drawRoundRect(0, 0, 300, 100, 12, 12);
		btn.graphics.endFill();
		
		btn.x = 320;
		btn.y = 20;
		
		btn.addChild (labelTxt);
		
		btn.addEventListener(MouseEvent.CLICK, toggleUpdatingLocation);
		
		if (debug==true) addChild(statusTxt);
		
		addChild(btn);
		
		
	}
	
	private function toggleUpdatingLocation(e:MouseEvent):Void {
	
		if (labelTxt.text.indexOf("start") != -1) {
			LocationManager.startUpdatingLocation(onLocationUpdate, onFinishedUpdatingLocation, onFLocationError);
			
			log("- StartUpdatingLocation...");
			labelTxt.text = "stop Updating Location";
		} else {
			LocationManager.stopUpdatingLocation();
			
			log("- StopUpdatingLocation...");
			labelTxt.text = "start Updating Location";
		}
	}
	
	private function onLocationUpdate(newLoc:Dynamic, oldLoc:Dynamic):Void {
		log("- Location arrived: " + Std.string(newLoc.latitude) + ", " + Std.string(newLoc.longitude));
		log("- Location timestamp: " + Date.fromTime(newLoc.timestamp).toString());
		
		/**
		* This is a list of all the properties of a Location Object:
		*	altitude:Float;
		*	latitude:Float;
		*	longitude:Float;
		*	course:Float;
		*	horizontalAccuracy:Float;
		*	speed:Float;
		*	timestamp:Float; (ms sin 1970)
		*	verticalAccuracy:Float;
		*/
		
		
		// Center Map to first Lock
		if(firstLock)
		{
			firstLock = false;
			map.canvas.setCenterPoint(newLoc.longitude, newLoc.latitude);
		}
		
		// Add line data to map
		map.layer.addPoint(newLoc.longitude, newLoc.latitude);

	}
	
	private function onFinishedUpdatingLocation(status:String):Void {
		log("- Location finished Updating: " + Std.string(status));
		
		labelTxt.text = "start Updating Location";
	}
	
	private function onFLocationError(status:String):Void {
		log("- Location ERROR: " + Std.string(status));
	}
	
	
	private function log(s:String):Void {
		trace("Log: " + s);
		statusTxt.text += s + "\n";
		statusTxt.scrollV = statusTxt.maxScrollV;
	}
	
	// Entry point
	
	public static function main () {
		
		Lib.current.addChild (new LocationManagerSample ());
		
	}
	
	
}