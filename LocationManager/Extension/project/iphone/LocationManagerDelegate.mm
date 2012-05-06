// LocationManagerDelegate: Based on the Locateme sample from Apple
// Modifications for NME extension made by Emiliano Angelini (emibap)

/*
     File: GetLocationViewController.m
 Abstract: Attempts to acquire a location measurement with a specific level of accuracy. A timeout is used to avoid wasting power in the case where a sufficiently accurate measurement cannot be acquired. Presents a SetupViewController instance so the user can configure the desired accuracy and timeout. Uses a LocationDetailViewController instance to drill down into details for a given location measurement.
 
  Version: 2.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "LocationManagerDelegate.h"

@implementation LocationManagerDelegate

@synthesize locationManager;
@synthesize bestEffortAtLocation;
@synthesize stateString;

static LocationManagerDelegate *sharedInstance = nil;

static LocationUpdateCallback onlocationUpdateCB;
static FinishedUpdatingCallback onFinishedUpdatingCB;
static LocationErrorCallback onErrorCB;

// Singleton Methods
+ (LocationManagerDelegate *)sharedInstance
{
	if (sharedInstance == nil)
	{
		sharedInstance = [[LocationManagerDelegate alloc] init];
	}
	return sharedInstance;
}


- (void)dealloc {
    [locationManager release];
    [bestEffortAtLocation release];
    [stateString release];
    [super dealloc];
}

#pragma mark Location Manager Interactions 

/*
 * All the magic starts here.
 */
 
- (int) authorizationStatus {
	return (int) [CLLocationManager authorizationStatus];
}  

- (bool) locationServicesEnabled {
	return [CLLocationManager locationServicesEnabled] == YES;
} 

- (bool) headingAvailable {
	return [CLLocationManager headingAvailable] == YES;
}

- (void)setCallBacks:(LocationUpdateCallback)onLocUpdate finishedUpdatingCB:(FinishedUpdatingCallback)onFinishedUpdating errorCB:(LocationErrorCallback)onError {
	
	// Setting the callBacks
	onlocationUpdateCB = onLocUpdate;
	onFinishedUpdatingCB = onFinishedUpdating;
	onErrorCB = onError;
 }
 
- (void)startUpdatingLocation {
    // Create the manager object 
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    //locationManager.desiredAccuracy = [[setupInfo objectForKey:kSetupInfoKeyAccuracy] doubleValue];
    // Setting to best accuracy. (May change in future versions)
    locationManager.desiredAccuracy = [[NSNumber numberWithDouble:kCLLocationAccuracyBest] doubleValue];
    
    // no te olvides de la distancia
    
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
}

- (Location)CLLocation2Struct:(CLLocation *)clloc {
	
	Location loc = Location();
	loc.altitude = clloc.altitude;
	loc.latitude = clloc.coordinate.latitude;
	loc.longitude = clloc.coordinate.longitude;
	loc.course = clloc.course;
	loc.horizontalAccuracy = clloc.horizontalAccuracy;
	loc.speed = clloc.speed;
	loc.timestamp = [clloc.timestamp timeIntervalSince1970] * 1000;
	loc.verticalAccuracy = clloc.verticalAccuracy;
	
	return loc;
	
}


/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {    
 	
 	Location newLoc = [self CLLocation2Struct:newLocation];
 	Location oldLoc = [self CLLocation2Struct:oldLocation];
 	
 	onlocationUpdateCB(newLoc, oldLoc);
 	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    
    //NSLog(@"LocationManagerDelegate didFailWithError.");
    
    if ([error code] != kCLErrorLocationUnknown) {
    	onErrorCB("Error");
        [self stopUpdatingLocation:@"Error"];
    } else {
	   onErrorCB("LocationUnknown"); 
    }
}

- (void)stopUpdatingLocation:(NSString *)state {
    self.stateString = state;
   
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    onFinishedUpdatingCB([state cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
