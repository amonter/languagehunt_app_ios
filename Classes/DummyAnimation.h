//
//  DummyAnimation.h
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 02/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DummyAnimation : UIViewController{

    UIView *boxView;    
    int framePosition;
    float timeInterval;
    
}
@property (nonatomic, retain) UIView *boxView;

-(void) moveRight;
-(void) moveLeft;
-(void) skipEnd;
-(void) showLastPage;
- (void)startAgain;
- (void) showFBButton;
- (void) whyInfoTapRemove;
- (void) whyInfoTap;

@end

