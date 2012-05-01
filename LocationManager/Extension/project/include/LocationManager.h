#ifndef LocationManager
#define LocationManager

#include "Location.h"

namespace locationManager {
	
	typedef void (*LocationUpdateCallback)(Location, Location);
	typedef void (*FinishedUpdatingCallback)(const char *);
	typedef void (*LocationErrorCallback)(const char *);
	
	
	void setCallBacks(LocationUpdateCallback onLocationUpdateCB, FinishedUpdatingCallback onFinishedUpdatingCB, LocationErrorCallback onErrorCB);
	void startUpdatingLocation();
	void stopUpdatingLocation(const char *status);
}

#endif
