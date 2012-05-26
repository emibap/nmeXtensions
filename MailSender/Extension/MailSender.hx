package;

import nme.utils.ByteArray;
import nme.display.BitmapData;
import nme.geom.Rectangle;

#if cpp
import cpp.Lib;
//#elseif neko
//import neko.Lib;
#else
import nme.Lib;
#end


class MailSender {	
	public static function sendMail(subject:String="", body:String="", isHTML:Bool=true, to:Array<String>=null, cc:Array<String>=null, bcc:Array<String>=null, attImg:BitmapData=null):Void {
		var strTo:String = (to != null && to.length > 0)? to.join(",") : "";
		var strCC:String = (cc != null && cc.length > 0)? cc.join(",") : "";
		var strBCC:String = (bcc != null && bcc.length > 0)? bcc.join(",") : "";
		#if cpp
			if (attImg != null) {
				var ba:ByteArray = attImg.getPixels(new Rectangle(0, 0, attImg.width, attImg.height));
				cpp_call_send_mail(subject, body, isHTML, strTo, strCC, strBCC, ba.getData(), Std.int(attImg.width), Std.int(attImg.height));
			} else {
				cpp_call_send_mail(subject, body, isHTML, strTo, strCC, strBCC, null, 0, 0);
			}
		#else
			Lib.getURL(new nme.net.URLRequest("mailto:" + strTo + "?cc=" + strCC + "&bcc=" + strBCC + "&subject=" + subject + "&body=" + body), "_blank");
		#end
	}

	#if cpp
	private static var cpp_call_send_mail = Lib.load ("mailsender", "mailsender_send_mail", -1);
	#end
	
}