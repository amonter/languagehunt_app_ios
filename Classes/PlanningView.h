//
//  PlanningView.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 23/04/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanningView : UIControl <UITextFieldDelegate, UITextViewDelegate> {
    bool keyDown;
    bool textViewActivated;
}

@property bool keyDown;
@property bool textViewActivated;

- (id)initWithFrame:(CGRect)frame superController:(UIView *) superView navigationController:(UINavigationController*) theNavigationController;
@end
