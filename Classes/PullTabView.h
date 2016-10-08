//
//  PullTabView.h
//  CrowdScannerMindField
//
//  Created by Kenneth Browne on 21/08/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullTabViewDelegate <NSObject>
- (void) pullTabVisable: (BOOL)isPullTabVisable;

@end

@interface PullTabView : UIView <UIScrollViewDelegate> {
    id<PullTabViewDelegate> delegate;

    IBOutlet UIView *pullTabView;
    
    IBOutlet UILabel *pullTabTitle;
    IBOutlet UILabel *pullTabMsg;
    
    IBOutlet UIImageView *pullTabArrow;
    IBOutlet UIImageView *pullTabImage;
    IBOutlet UIImageView *curtainImage;
    
    IBOutlet UIScrollView *myScrollView;
    
    NSTimeInterval delay;
    NSTimeInterval speedAppear;
    NSTimeInterval speedDissapear;
}

@property (retain) id delegate;

- (void) eventTap;
- (void) hidePhoto;
- (void) showPhoto;
- (void) setBackgroundEnabled;
- (void) setBackgroundDisabled;
- (void) setup;
- (void) setDelay:(NSTimeInterval)timeDelay;
- (void) setPhoto:(UIImage*)photo;
- (void) setPullTab:(UIFont*)font;
- (void) setPullTabMessage:(UIFont*)font;
- (void) setSpeedAppear:(NSTimeInterval)speed;
- (void) setSpeedDissapear:(NSTimeInterval)speed;

@end
