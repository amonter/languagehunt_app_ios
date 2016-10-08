//
//  EditProfileController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/15/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "MatchDataTableController.h"

@interface EditProfileController : UIViewController <UIScrollViewDelegate, UITextViewDelegate>



@property (nonatomic, retain) NSDictionary* profileData;
@property (nonatomic, retain) IBOutlet UILabel* bio;
@property (nonatomic, retain) IBOutlet UILabel* interests;
@property (nonatomic, retain) IBOutlet UIButton* saveChanges;
@property (nonatomic, retain) IBOutlet UIScrollView* theScroll;
@property (nonatomic, retain) IBOutlet UITextView* interestView;
@property (nonatomic, retain) IBOutlet UITextView* aboutView;
@property (nonatomic, retain) IBOutlet UIImageView* backImageView;
@property (nonatomic, retain) IBOutlet UIImageView* backImageView2;

- (IBAction)saveChanges:(id)sender;
@end
