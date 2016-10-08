//
//  LanguageModeController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 5/13/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageConfirmationController.h"

@protocol LanguageModeDelegate <NSObject>
- (void)helpSelected:(int) x_value scrollValue:(int) scroll_x;
- (void)learnSelected;
- (void)goInbox;
@end


@interface LanguageModeController : UIViewController {
     id<LanguageModeDelegate> delegate;
}

@property int helpMode;
@property int checkList;
@property (nonatomic, retain) IBOutlet UIView* overView;
@property (nonatomic, retain) MessageConfirmationController* theMessage;
@property int mode;
@property (retain) id delegate;
@end
