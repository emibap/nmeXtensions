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
static LocationFinishedUpdateCallback onFinishedUpdatingCB;
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
 * All the magis starts here.
 */
- (void)startUpdatingLocation:(int)timeout locationUpdateCB:(LocationUpdateCallback)onLocUpdate finishedUpdatingCB:(LocationFinishedUpdateCallback)onFinishedUpdating errorCB:(LocationErrorCallback)onError {
	//NSLog(@"LocationManagerDelegate startUpdatingLocation...");
	
	// Setting the callBacks
	onlocationUpdateCB = onLocUpdate;
	onFinishedUpdatingCB = onFinishedUpdating;
	onErrorCB = onError;

    // Create the manager object 
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    //locationManager.desiredAccuracy = [[setupInfo objectForKey:kSetupInfoKeyAccuracy] doubleValue];
    // Setting to best accuracy. (May change in future versions)
    locationManager.desiredAccuracy = [[NSNumber numberWithDouble:kCLLocationAccuracyBest] doubleValue];
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    // Set a timeout for the locationUpdate
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:[[NSNumber numberWithDouble:timeout] doubleValue]];
    self.stateString = NSLocalizedString(@"Updating", @"Updating");
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {    
    //NSLog(@"LocationManagerDelegate didUpdateToLocation...");
 
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        //NSLog(@" newLocation.coordinates: %f , %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);

        onlocationUpdateCB(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
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
   
	// We are cancelling the timeout
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:@"Timed Out"];
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    //NSLog(@"StopUpdatingLocation - Code %s", [state cStringUsingEncoding:NSUTF8StringEncoding]);
    
    onFinishedUpdatingCB([state cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
