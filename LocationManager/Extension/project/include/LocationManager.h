#ifndef LocationManager
#define LocationManager

namespace locationManager {
	
	typedef void (*LocationUpdateCallback)(float, float);
	typedef void (*LocationFinishedUpdateCallback)(const char *);
	typedef void (*LocationErrorCallback)(const char *);
	
	void startUpdatingLocation(int totalTimer, LocationUpdateCallback onLocationUpdateCB, LocationFinishedUpdateCallback onFinishedUpdateCB, LocationErrorCallback onErrorCB);
	void stopUpdatingLocation(const char *status);
}

#endif
