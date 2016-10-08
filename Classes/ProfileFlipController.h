//
//  ProfileFlipController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 24/04/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarImageView.h"

@interface ProfileFlipController : UIView 


@property (nonatomic, retain) IBOutlet AvatarImageView *avatarView;
@property (nonatomic, retain) IBOutlet UITextView *bioField;
@property (nonatomic, retain) IBOutlet UILabel *currentLocation;
@property (nonatomic, retain) IBOutlet UILabel *meetingLocation;

- (void)loadData:(int) profileId;

@end
