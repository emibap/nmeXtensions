#include <LocationManager.h>
#include <LocationManagerDelegate.h>

namespace locationManager {
    
	void startUpdatingLocation(int totalTimer, LocationUpdateCallback onLocationUpdateCB, LocationFinishedUpdateCallback onFinishedUpdateCB, LocationErrorCallback onErrorCB) {
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan startUpdatingLocation:totalTimer locationUpdateCB:onLocationUpdateCB finishedUpdatingCB:onFinishedUpdateCB errorCB:onErrorCB];    
    }
    
    void stopUpdatingLocation(const char *status) {
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan stopUpdatingLocation:[NSString stringWithCString:status encoding:NSUTF8StringEncoding]];
    }
}