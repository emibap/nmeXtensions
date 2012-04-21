#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "LocationManager.h"

using namespace locationManager;

AutoGCRoot *sOnLocationUpdateCallback = 0;
AutoGCRoot *sOnFinishedUpdatingCallback = 0;
AutoGCRoot *sOnErrorCallback = 0;
#ifdef IPHONE


static void onLocationUpdate(float latitude, float longitude)
{
   val_call2( sOnLocationUpdateCallback->get(), alloc_float(latitude), alloc_float(longitude));
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

static void locationmanager_start_updating_location (value totalTimer, value locationChangeCB, value finishedUpdatingCB, value errorCB) {
    
    if (sOnLocationUpdateCallback != 0) stopUpdatingLocation("Restarted");//onFinishedUpdating("Restart");
    
	sOnLocationUpdateCallback = new AutoGCRoot(locationChangeCB);
	sOnFinishedUpdatingCallback = new AutoGCRoot(finishedUpdatingCB);
	sOnErrorCallback = new AutoGCRoot(errorCB);
    
	startUpdatingLocation(val_int (totalTimer), onLocationUpdate, onFinishedUpdating, onError);
    
}
DEFINE_PRIM (locationmanager_start_updating_location, 4);

static void locationmanager_stop_updating_location() {
	if (sOnLocationUpdateCallback != 0) stopUpdatingLocation("StopCalled");
}
DEFINE_PRIM (locationmanager_stop_updating_location, 0);
#endif


extern "C" void locationmanager_main () {
	
	// Here you could do some initialization, if needed
	
}
DEFINE_ENTRY_POINT (locationmanager_main);


extern "C" int locationmanager_register_prims () { return 0; }