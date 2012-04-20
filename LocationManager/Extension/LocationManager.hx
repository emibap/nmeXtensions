package;


#if cpp
import cpp.Lib;
//#elseif neko
//import neko.Lib;
#else
import nme.Lib;
#end
/*
– startUpdatingLocation
– stopUpdatingLocation
  distanceFilter  property
  desiredAccuracy  property
*/
class LocationManager {	

	//public static var locationUpdateCB:Dynamic;

	public static function startUpdatingLocation(totalTimer:Int = 30000, locationUpdateCB:Dynamic, finishedUpdatingCB:Dynamic, errorCB:Dynamic):Void {
		//locationUpdateCB = onLocationUpdate;
		#if cpp
			cpp_call_start_updating_location(totalTimer, locationUpdateCB, finishedUpdatingCB, errorCB);
		//#else
			//Lib.getURL(new nme.net.URLRequest("mailto:" + to + "?cc=" + cc + "&bcc=" + bcc + "&subject=" + subject + "&body=" + body), "_blank");
		#end
		
		
	}
	
	public static function onLocationUpdate(latitude:Float, longitude:Float):Void {
		trace("Location arrived to haxe - latitude reported: " + latitude + ", " + longitude);
	}
	
	#if cpp
	private static var cpp_call_start_updating_location = Lib.load ("locationmanager", "locationmanager_start_updating_location", 4);
	
	#end
	
}