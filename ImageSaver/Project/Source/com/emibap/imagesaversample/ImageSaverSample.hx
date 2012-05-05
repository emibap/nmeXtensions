package com.emibap.imagesaversample;


import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.system.Capabilities;


/**
 * @author Emiliano Angelini
 */
class ImageSaverSample extends Sprite {
	
	private var labelTxt:TextField;
	private var btn:Sprite;
	private var statusTxt:TextField;
	private var bmd:BitmapData;
	
	public function new () {
		super ();
		initialize ();
	}

	private function initialize ():Void {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		var w:Int = Std.int(Capabilities.screenResolutionX);
		var h:Int = Std.int(Capabilities.screenResolutionY);
		
		graphics.beginFill(0xCCCCCC, 1);
		graphics.drawRoundRect(0, 0, w, h, 16, 16);
		graphics.endFill();
		
		statusTxt = new TextField();
		statusTxt.defaultTextFormat = new TextFormat ("_sans", 20, 0x000000);
		statusTxt.width = w;
		statusTxt.height = h;
		statusTxt.x = 0;
		statusTxt.y = 0;
		statusTxt.selectable = false;
		statusTxt.multiline = true;
		statusTxt.text = "Hello-\n\n\n";
		
		labelTxt = new TextField ();
		labelTxt.defaultTextFormat = new TextFormat("_sans", 24, 0xCCCCCC, null, null, null, null, null, nme.text.TextFormatAlign.CENTER);
		labelTxt.width = 260;
		labelTxt.x = 20;
		labelTxt.y = 30;
		labelTxt.selectable = false;
		labelTxt.text = "Save a Snapshot :)";
		
		btn = new Sprite();
		btn.graphics.beginFill(0x000000, .8);
		btn.graphics.drawRoundRect(0, 0, 300, 100, 12, 12);
		btn.graphics.endFill();
		
		btn.x = w - btn.width - 20;
		btn.y = 20;
		
		btn.addChild (labelTxt);
		
		btn.addEventListener(MouseEvent.CLICK, saveSnapshot);
		
		addChild(statusTxt);
		
		addChild(btn);
		
		bmd = new BitmapData(w, h, false, 0xFFFFFFFF);
	}
	
	private function saveSnapshot(e:MouseEvent):Void {
	
		bmd.draw(this);
	
		ImageSaver.saveImage(bmd);
		statusTxt.text += "\n- snapshot taken.";
	}
	
	// Entry point
	
	public static function main () {
		
		Lib.current.addChild (new ImageSaverSample ());
		
	}
	
	
}