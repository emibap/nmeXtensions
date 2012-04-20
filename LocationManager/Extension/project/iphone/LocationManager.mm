#include <LocationManager.h>
//#import <UIKit/UIKit.h>
#include <LocationManagerDelegate.h>

namespace locationManager {
    
	void startUpdatingLocation(int totalTimer, LocationUpdateCallback onLocationUpdateCB, LocationFinishedUpdateCallback onFinishedUpdateCB, LocationErrorCallback onErrorCB) {
	    
	    //MailComposer* mailC = [MailComposer sharedInstance];
	    //[mailC showPicker:[NSString stringWithCString:subject encoding:NSUTF8StringEncoding] msgBody:[NSString stringWithCString:body encoding:NSUTF8StringEncoding] msgIsHTML:YES sndTo:[NSString stringWithCString:to encoding:NSUTF8StringEncoding] sndCC:[NSString stringWithCString:cc encoding:NSUTF8StringEncoding] sndBCC:[NSString stringWithCString:bcc encoding:NSUTF8StringEncoding]];
	    
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan startUpdatingLocation:totalTimer locationUpdateCB:onLocationUpdateCB finishedUpdatingCB:onFinishedUpdateCB errorCB:onErrorCB];
	    
	    //onCB(10.1);
	    
    }
    
    void stopUpdatingLocation(const char *status) {
	    LocationManagerDelegate* locMan = [LocationManagerDelegate sharedInstance];
	    [locMan stopUpdatingLocation:[NSString stringWithCString:status encoding:NSUTF8StringEncoding]];
    }
}
