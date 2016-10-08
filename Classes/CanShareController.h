//
//  CanShareController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 19/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanShareController : UIViewController {

    IBOutlet UIView *sharingView;
    IBOutlet UIView *helpView;
    IBOutlet UIButton *feelerBtn;
    IBOutlet UIButton *doneButton;
    IBOutlet UILabel *shareLabel;
    IBOutlet UISegmentedControl *knowControl;
    NSString *selectionDone;
    int feelerId;
    bool newFeeler;
    NSSet *providingIds;
}

@property bool newFeeler;
@property bool dissmissVersion;
@property bool cancelMode;
@property int feelerId;
@property (nonatomic, retain) NSSet *providingIds;
@property (nonatomic, retain) NSString *selectionDone;
@property (nonatomic, retain) IBOutlet UIButton *feelerBtn;
@property (nonatomic, retain) IBOutlet UIView *sharingView;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIView *helpView;
@property (nonatomic, retain) IBOutlet UILabel *shareLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *knowControl;


- (IBAction)doneAdding;
- (IBAction)selectFeeler;
- (void)setFeeler;
- (void) addTheNewFeeler;
- (void) backButtonTapped;
- (void)createSharingView;

@end
