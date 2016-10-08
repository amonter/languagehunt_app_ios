//
//  EditProfileScrollView.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 16/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendProfileInfo.h"

@interface EditProfileScrollView : UITableViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
	
	NSDictionary *profileInfo;
	SendProfileInfo *request;
}
	
@property (nonatomic, retain) NSDictionary *profileInfo;
@property (nonatomic, retain) SendProfileInfo *request;
- (bool) validate;
- (void) saveDetails;

@end
