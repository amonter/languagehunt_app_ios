//
//  RealOusiastikosAppDelegate.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 19/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)



#import "RealOusiastikosAppDelegate.h"
#import "Reachability.h"
#import "FirstLevelViewController.h"



@implementation RealOusiastikosAppDelegate

@synthesize window;
@synthesize internetReach;
@synthesize wifiReach;
@synthesize locationManager, relanched;

#pragma mark -
#pragma mark Application lifecycle

- (void) checkForNetworkConnection: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
    NSString* statusString = @"";
    switch (netStatus)
    {
        case NotReachable:
        {
			//Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet" 
															message:@"whoops! we can't find an internet connection" delegate:self 
												  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
            connectionRequired= NO;  
            break;
        }
            
        case ReachableViaWWAN:
        {
                   
            break;
        }
        case ReachableViaWiFi:
        {
			           
            break;
		}
    }
    if(connectionRequired)
    {
        statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
    }    
}

- (void) reachabilityChanged: (NSNotification* )note {
	
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	//[self checkForNetworkConnection: curReach];
}


- (void) startGeolocation {

	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self; // send loc updates to myself    
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if(IS_OS_8_OR_LATER){
        //NSUInteger code = [CLLocationManager authorizationStatus];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    [self.locationManager startUpdatingLocation];
   
}




- (void)applicationWillTerminate:(UIApplication *)application {
    self.relanched = false;    
}

- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error {
	NSLog(@"Error: %@", [error description]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"location_fail" object:self];
}



#pragma mark -
#pragma mark Memory management
- (void)dealloc {	
	[locationManager release];
	[window release];
	[super dealloc];
}


@end

