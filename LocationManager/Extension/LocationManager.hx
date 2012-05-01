package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

class LocationManager {	

	private static var _locUpdateCB:Dynamic;

	public static function startUpdatingLocation(locationUpdateCB:Dynamic, finishedUpdatingCB:Dynamic, errorCB:Dynamic):Void {
		#if cpp

		_locUpdateCB = locationUpdateCB;
		
		if (finishedUpdatingCB == null) finishedUpdatingCB = onFinishedUpdatingDefaultCB;
		if (errorCB == null) errorCB = onErrorDefaultCB;
		
		cpp_call_start_updating_location(onLocationUpdateDefaultCB, finishedUpdatingCB, errorCB);
		//#else
		#end	
	}
	
	public static function stopUpdatingLocation():Void {
		#if cpp
			cpp_call_stop_updating_location();
		//#else
		#end	
	}
	
	public static function onLocationUpdateDefaultCB(newLocation:Dynamic, oldLocation:Dynamic):Void {
		//trace("LocationManager Default callback - Location arrived to haxe - latitude reported: " + latitude + ", " + longitude);
		
		if (_locUpdateCB != null) _locUpdateCB(newLocation, oldLocation);
		
	}
	public static function onFinishedUpdatingDefaultCB(status:String):Void {
		trace("LocationManager Default callback - Finished updating location. Status: " + status);
	}	
	public static function onErrorDefaultCB(status:String):Void {
		trace("LocationManager Default callback - Error updating location. Status: " + status);
	}
	#if cpp
	private static var cpp_call_start_updating_location = Lib.load ("locationmanager", "locationmanager_start_updating_location", 3);
	private static var cpp_call_stop_updating_location = Lib.load ("locationmanager", "locationmanager_stop_updating_location", 0);
	#end
	
}