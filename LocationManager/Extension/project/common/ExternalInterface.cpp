#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <hxcpp.h>
#include <Dynamic.h>

#include "Location.h"
#include "LocationManager.h"

using namespace locationManager;

AutoGCRoot *sOnLocationUpdateCallback = 0;
AutoGCRoot *sOnFinishedUpdatingCallback = 0;
AutoGCRoot *sOnErrorCallback = 0;
#ifdef IPHONE


static value locationStruct2Value(Location stLoc)
{
	value loc = alloc_empty_object();
	alloc_field(loc, val_id("altitude"), alloc_float(stLoc.altitude));
	alloc_field(loc, val_id("latitude"), alloc_float(stLoc.latitude));
	alloc_field(loc, val_id("longitude"), alloc_float(stLoc.longitude));
	alloc_field(loc, val_id("course"), alloc_float(stLoc.course));
	alloc_field(loc, val_id("horizontalAccuracy"), alloc_float(stLoc.horizontalAccuracy));
	alloc_field(loc, val_id("speed"), alloc_float(stLoc.speed));
	alloc_field(loc, val_id("timestamp"), alloc_float(stLoc.timestamp));
	alloc_field(loc, val_id("verticalAccuracy"), alloc_float(stLoc.verticalAccuracy));
	
	return loc;	
}

static void onLocationUpdate(Location newLoc, Location oldLoc)
{
   val_call2( sOnLocationUpdateCallback->get(), locationStruct2Value(newLoc), locationStruct2Value(oldLoc));
}

static void onFinishedUpdating(const char *status)
{
	val_call1( sOnFinishedUpdatingCallback->get(), alloc_string(status) );
	delete sOnFinishedUpdatingCallback;
	sOnLocationUpdateCallback = 0;
	
	delete sOnLocationUpdateCallback;
	sOnFinishedUpdatingCallback = 0;
	
	delete sOnErrorCallback;
	sOnErrorCallback = 0;
}

static void onError(const char *status)
{
	val_call1( sOnErrorCallback->get(), alloc_string(status) );
}

static void locationmanager_start_updating_location (value locationChangeCB, value finishedUpdatingCB, value errorCB) {
    
    if (sOnLocationUpdateCallback != 0) stopUpdatingLocation("Restarted");//onFinishedUpdating("Restart");
    
	sOnLocationUpdateCallback = new AutoGCRoot(locationChangeCB);
	sOnFinishedUpdatingCallback = new AutoGCRoot(finishedUpdatingCB);
	sOnErrorCallback = new AutoGCRoot(errorCB);
    
    setCallBacks(onLocationUpdate, onFinishedUpdating, onError);
    
	startUpdatingLocation();
    
}
DEFINE_PRIM (locationmanager_start_updating_location, 3);

static void locationmanager_stop_updating_location() {
	if (sOnLocationUpdateCallback != 0) stopUpdatingLocation("StopCalled");
}
DEFINE_PRIM (locationmanager_stop_updating_location, 0);

static value locationmanager_authorization_status() {
	return alloc_int(authorizationStatus());
}
DEFINE_PRIM (locationmanager_authorization_status, 0);

static value locationmanager_location_services_enabled() {
	return alloc_bool(locationServicesEnabled());
}
DEFINE_PRIM (locationmanager_location_services_enabled, 0);

static value locationmanager_heading_available() {
	return alloc_bool(headingAvailable());
}
DEFINE_PRIM (locationmanager_heading_available, 0);

#endif


extern "C" void locationmanager_main () {
	
	// Here you could do some initialization, if needed
	
}
DEFINE_ENTRY_POINT (locationmanager_main);


extern "C" int locationmanager_register_prims () { return 0; }