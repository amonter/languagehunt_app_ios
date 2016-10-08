//
//  MatchViewController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 01/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolCommunication.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>

@interface MatchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ProtocolDelegate, MKMapViewDelegate, UIScrollViewDelegate>  {
    
    IBOutlet UITableView *theTableView;
    NSDictionary *theData;
    NSMutableArray *chatLines;
    IBOutlet UITextField *inputChatField;
    IBOutlet UIToolbar *chatBar;
    
    NSTimer *theTimer;   
    NSString *matchedUsername;
    NSString *theOtherUrl;
    NSDictionary *foundData;
    UIImageView *characterImageAddExperience;
    ProtocolCommunication *protocol;  
    
    CGPoint storedOffset;
    NSString *senderUsername;
    NSDictionary *allData;
    NSString *location;
    
    bool iHaveSharedLocation;
    bool theyHaveSharedLocation;
    bool recycleMatch;
    NSString *theirSharedLocation;    
    
}

@property bool recycleMatch;
@property bool iHaveSharedLocation;
@property bool theyHaveSharedLocation;
@property CGPoint storedOffset;
@property (nonatomic, retain) NSString *theirSharedLocation;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *theOtherUrl;
@property (nonatomic, retain) NSDictionary *allData;
@property (nonatomic, retain) ProtocolCommunication *protocol;
@property (nonatomic, retain) NSDictionary *theData;
@property (nonatomic, retain) NSMutableArray *chatLines;
@property (nonatomic, retain) IBOutlet UITextField *inputChatField;
@property (nonatomic, retain) IBOutlet UIToolbar *chatBar;
@property (nonatomic, retain) NSDictionary *foundData;
@property (nonatomic, retain) NSString *matchedUsername;
@property (nonatomic, retain) UIImageView *characterImageAddExperience;
@property (nonatomic, retain) MKMapView *myMapView;

- (IBAction) sendChatMessage;
- (void) dismissKeyboard;
- (void) cantMeetNow;
- (void)closeViews;
- (void) removeLocationWarning;
- (void) locationWarningPop;
- (void)closeNetwork;

@end
