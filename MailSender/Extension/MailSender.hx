package;


#if cpp
import cpp.Lib;
//#elseif neko
//import neko.Lib;
#else
import nme.Lib;
#end


class MailSender {	
	public static function sendMail(subject:String="", body:String="", isHTML:Bool=true, to:String="", cc:String="", bcc:String=""):Void {
		#if cpp
			if (isHTML == true) cpp_call_send_html_mail(subject, body, to, cc, bcc);
			else cpp_call_send_plain_mail(subject, body, to, cc, bcc);
		#else
			Lib.getURL(new nme.net.URLRequest("mailto:" + to + "?cc=" + cc + "&bcc=" + bcc + "&subject=" + subject + "&body=" + body), "_blank");
		#end
		
		
	}

	#if cpp
	private static var cpp_call_send_html_mail = Lib.load ("mailsender", "mailsender_send_html_mail", 5);
	private static var cpp_call_send_plain_mail = Lib.load ("mailsender", "mailsender_send_plain_mail", 5);
	#end
	
}