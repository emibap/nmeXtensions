package com.emibap.videoplayersample;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;


/**
 * @author Emiliano Angelini
 *
 */
 
class VideoPlayerSample extends Sprite {
	
	
	private var labelTxt:TextField;
	private var btn:Sprite;
	private var statusTxt:TextField;
	
	public var debug:Bool;
	
	public function new () {
		
		super ();
		
		//debug = true;
		
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
		statusTxt.mouseEnabled = false;

		labelTxt = new TextField ();
		labelTxt.defaultTextFormat = new TextFormat ("_sans", 24, 0xCCCCCC);
		labelTxt.width = 320;
		labelTxt.x = 20;
		labelTxt.y = 34;
		labelTxt.selectable = false;
		labelTxt.text = "play video";
		
		btn = new Sprite();
		btn.graphics.beginFill(0x000000, .8);
		btn.graphics.drawRoundRect(0, 0, 300, 100, 12, 12);
		btn.graphics.endFill();
		
		btn.x = 320;
		btn.y = 20;
		
		btn.addChild (labelTxt);
		
		btn.addEventListener(MouseEvent.CLICK, showVideo);
		
		if (debug==true) addChild(statusTxt);
		
		addChild(btn);
		
		
	}
	
	private function showVideo(e:MouseEvent):Void {
		VideoPlayer.showVideo("http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8");
		//VideoPlayer.showVideo("assets/sample_mpeg4.mp4");
	}

	
	
	private function log(s:String):Void {
		trace("Log: " + s);
		statusTxt.text += s + "\n";
		statusTxt.scrollV = statusTxt.maxScrollV;
	}
	
	// Entry point
	
	public static function main () {
		
		Lib.current.addChild (new VideoPlayerSample ());
		
	}
	
	
}