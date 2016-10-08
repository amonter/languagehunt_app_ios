//
//  MyCustomSearch.m
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 21/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "MyCustomSearch.h"

@implementation MyCustomSearch



- (void)layoutSubviews {

    
    UITextField *searchField;    
      CGRect theFrame = self.frame;
    theFrame.size.width = 275;
    self.frame = theFrame;
    NSUInteger numViews = [self.subviews count];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        //IOS6
        for(int i = 0; i < numViews; i++) {
            if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
                searchField = [self.subviews objectAtIndex:i];
            }
         }
    } else {//IOS 7
        for (id object in [self subviews]) {
            for (id subObject in [object subviews]) {
                if ([subObject isKindOfClass:[UITextField class]]) {
                    searchField = (UITextField*)subObject;
                }
            }
        }
    }
   
    if(!(searchField == nil)) {
        //searchField.background = nil;
        //searchField.clipsToBounds = YES;
        //[searchField setRightViewMode:UITextFieldViewModeUnlessEditing];
        searchField.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"searchbox.png"]];
        searchField.placeholder = @"Search...";
        //searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        //searchField.leftViewMode = UITextFieldViewModeAlways;
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        searchField.font = [UIFont fontWithName:@"FreightSans Medium" size:18.0];
        searchField.returnKeyType = UIReturnKeyDone;
    }
     
    [self setNeedsDisplay];
    
    [super layoutSubviews];
     
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
