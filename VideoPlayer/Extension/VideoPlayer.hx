package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

class VideoPlayer {	

	private static var _locUpdateCB:Dynamic;

	public static function showVideo(url:String):Void {
		#if cpp
			cpp_call_show_video(url);
		#end	
	}
	
	#if cpp
	private static var cpp_call_show_video = Lib.load ("videoplayer", "videoplayer_show_video", 1);
	#end
	
}