#include <LocationManager.h>
#include <LocationManagerDelegate.h>

namespace locationManager {
    
    void setCallBacks(LocationUpdateCallback onLocationUpdateCB, FinishedUpdatingCallback onFinishedUpdatingCB, LocationErrorCallback onErrorCB) {
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan setCallBacks:onLocationUpdateCB finishedUpdatingCB:onFinishedUpdatingCB errorCB:onErrorCB];
    }
    
	void startUpdatingLocation() {
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan startUpdatingLocation];    
    }
    
    void stopUpdatingLocation(const char *status) {
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan stopUpdatingLocation:[NSString stringWithCString:status encoding:NSUTF8StringEncoding]];
    }
}