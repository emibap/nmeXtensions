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
		#end	
	}
	
	public static function stopUpdatingLocation():Void {
		#if cpp
			cpp_call_stop_updating_location();
		//#else
		#end	
	}
	
	public static function authorizationStatus():Int {
		#if cpp
			return cpp_call_authorization_status();
		#else
			return 0;
		#end	

	}
	
	public static function locationServicesEnabled():Bool {
		#if cpp
			return cpp_call_location_services_enabled();
		#else
			return false;
		#end	
	}

	

	
	
	// CallBacks
	public static function onLocationUpdateDefaultCB(newLocation:Dynamic, oldLocation:Dynamic):Void {
		
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
	private static var cpp_call_authorization_status = Lib.load ("locationmanager", "locationmanager_authorization_status", 0);
	private static var cpp_call_location_services_enabled  = Lib.load ("locationmanager", "locationmanager_location_services_enabled", 0);
	#end
	
}