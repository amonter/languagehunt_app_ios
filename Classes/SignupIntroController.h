//
//  SignupIntroController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 17/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuntProfileHelper.h"


@interface SignupIntroController : UIViewController <UIScrollViewDelegate>


@property (nonatomic, retain) IBOutlet UIScrollView* theScrollView;

- (IBAction)didTapConnectWithLinkedIn:(id)sender;
- (void) addInterests;

@end
