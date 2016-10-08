//
//  DummyIos6.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 15/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolCommunication.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
@class GCDAsyncSocket;

@interface DummyIos6 : UIViewController <UIActionSheetDelegate, MKMapViewDelegate, ProtocolDelegate> {


}



@property (nonatomic, retain) IBOutlet MKMapView *aMapView;


- (IBAction) sendChatMessage:(id) sender;
@end
