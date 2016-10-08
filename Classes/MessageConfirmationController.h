//
//  MessageConfirmationController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 6/16/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageConfirmationController : UIViewController


@property int checkList;
@property int helpMode;
@property (nonatomic, retain) IBOutlet UIImageView* successMsg;
@property (nonatomic, retain) IBOutlet UIImageView* msgOverlay;
@property (nonatomic, retain) IBOutlet UIImageView* arrow_msg;
@property (nonatomic, retain) IBOutlet UIImageView* iconImage;
@property (nonatomic, retain) IBOutlet UIImageView* anImage;
@property (nonatomic, retain) IBOutlet UIImageView* footerImage;
@property (nonatomic, retain) IBOutlet UILabel* numberCount;
@property (nonatomic, retain) IBOutlet UIButton* shareBtn;
@property (nonatomic, retain) IBOutlet UIButton* inboxBtn;
@property (nonatomic, retain) IBOutlet UILabel* laterLabel;

- (IBAction)doHelp:(id)sender;
- (IBAction)goInbox2:(id)sender;

@end
