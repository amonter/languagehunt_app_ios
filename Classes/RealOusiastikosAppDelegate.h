//
//  RealOusiastikosAppDelegate.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 19/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
@class Reachability;
@interface RealOusiastikosAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    
    UIWindow *window; 
	Reachability *internetReach;
    Reachability *wifiReach;
	CLLocationManager *locationManager;
    bool relanched;
    
}
@property bool relanched;
@property (nonatomic, retain) CLLocationManager *locationManager; 
@property (nonatomic, retain) Reachability *internetReach;
@property (nonatomic, retain) Reachability *wifiReach;
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void) checkForNetworkConnection: (Reachability*) curReach;
- (void) startGeolocation;

@end

