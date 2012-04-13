package com.emibap.mailsendersample;


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
class MailSenderSample extends Sprite {
	
	
	private var label:TextField;
	private var btn:Sprite;
	
	public function new () {
		
		super ();
		initialize ();
		
	}
	
	
	private function initialize ():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		
		label = new TextField ();
		label.defaultTextFormat = new TextFormat ("_sans", 24, 0xCCCCCC);
		label.width = 380;
		label.x = 10;
		label.y = 20;
		label.selectable = false;
		label.text = "Open Mail Window";
		
		btn = new Sprite();
		btn.graphics.beginFill(0x000000);
		btn.graphics.drawRoundRect(0, 0, 400, 100, 8, 8);
		btn.graphics.endFill();
		
		btn.addChild (label);
		
		btn.addEventListener(MouseEvent.CLICK, callMailWindow);
		
		addChild(btn);
		
		
	}
	
	private function callMailWindow(e:MouseEvent):Void {
		MailSender.sendMail("MailSender sendMail sample", "Howdy, partner\n", false, "youremail@gmail.com", "youremail@gmail.com", "youremail@gmail.com");
	}
	
	
	// Entry point
	
	public static function main () {
		
		Lib.current.addChild (new MailSenderSample ());
		
	}
	
	
}