package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

class LocationManager {	


	public static function startUpdatingLocation(totalTimer:Int = 30, locationUpdateCB:Dynamic, finishedUpdatingCB:Dynamic, errorCB:Dynamic):Void {
		#if cpp
		if (locationUpdateCB == null) locationUpdateCB = onLocationUpdateDefaultCB;
		if (finishedUpdatingCB == null) finishedUpdatingCB = onFinishedUpdatingDefaultCB;
		if (errorCB == null) errorCB = onErrorDefaultCB;
			cpp_call_start_updating_location(totalTimer, locationUpdateCB, finishedUpdatingCB, errorCB);
		//#else
		#end	
	}
	
	public static function stopUpdatingLocation():Void {
		#if cpp
			cpp_call_stop_updating_location();
		//#else
		#end	
	}
	
	public static function onLocationUpdateDefaultCB(latitude:Float, longitude:Float):Void {
		trace("LocationManager Default callback - Location arrived to haxe - latitude reported: " + latitude + ", " + longitude);
	}
	public static function onFinishedUpdatingDefaultCB(status:String):Void {
		trace("LocationManager Default callback - Finished updating location. Status: " + status);
	}	
	public static function onErrorDefaultCB(status:String):Void {
		trace("LocationManager Default callback - Error updating location. Status: " + status);
	}
	#if cpp
	private static var cpp_call_start_updating_location = Lib.load ("locationmanager", "locationmanager_start_updating_location", 4);
	private static var cpp_call_stop_updating_location = Lib.load ("locationmanager", "locationmanager_stop_updating_location", 0);
	#end
	
}