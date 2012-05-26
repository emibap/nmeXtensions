 package com.emibap.mailsendersample;


import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;
import nme.display.BitmapData;


/**
 * @author Emiliano Angelini
 */
class MailSenderSample extends Sprite {
	
	
	private var label:TextField;
	private var label2:TextField;
	
	private var btn:Sprite;
	private var btn2:Sprite;
	
	public function new () {
		
		super ();
		initialize ();
		
	}
	
	
	private function initialize ():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		label = createLabel("Open Mail Window");
		btn = createButton(label);
		btn.addEventListener(MouseEvent.CLICK, callMailWindow);
	
		btn.x = 20;
		btn.y = 20;
		addChild(btn);
		
		#if cpp
		label2 = createLabel("Open with image");
		btn2 = createButton(label2);
		btn2.addEventListener(MouseEvent.CLICK, callMailWithImage);
		btn2.x = 20;
		btn2.y = 220;
		
		addChild(btn2);
		#end
		
	}
	
	private function createButton(lbl:TextField):Sprite {
		var butn:Sprite = new Sprite();
		butn.graphics.beginFill(0x000000);
		butn.graphics.drawRoundRect(0, 0, 400, 100, 8, 8);
		butn.graphics.endFill();
		
		butn.addChild (lbl);
		
		return butn;
	}
	
	private function createLabel(v:String):TextField {
		var lbl:TextField = new TextField ();
		lbl.defaultTextFormat = new TextFormat ("_sans", 24, 0xCCCCCC);
		lbl.width = 380;
		lbl.x = 10;
		lbl.y = 20;
		lbl.selectable = false;
		lbl.text = v;
		
		return lbl;
	}
	
	private function callMailWindow(e:MouseEvent):Void {
		MailSender.sendMail("MailSender sendMail sample", "Howdy, partner\n", false, ["youremail@gmail.com"], ["youremail@gmail.com"], ["youremail@gmail.com"]);
	}
	
	#if cpp
	private function callMailWithImage(e:MouseEvent):Void {
		var bmd:BitmapData = new BitmapData(640, 480, false, 0xFFFFFF);
		bmd.draw(this);
		MailSender.sendMail("MailSender sendMail sample", "Howdy, partner\n", false, ["youremail@gmail.com"], ["youremailCC@gmail.com"], ["youremailBCC@gmail.com"], bmd);
	}
	#end
	
	// Entry point
	
	public static function main () {
		
		Lib.current.addChild (new MailSenderSample ());
		
	}
	
	
}