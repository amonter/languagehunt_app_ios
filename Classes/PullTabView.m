//
//  PullTabView.m
//  CrowdScannerMindField
//
//  Created by Kenneth Browne on 21/08/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import "PullTabView.h"
#import <QuartzCore/QuartzCore.h>


#define PULL_TAB_HEADER_HEIGHT 35.0f

@implementation PullTabView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PullTabView" owner:self options:nil];
        NSLog(@"Adding the delegate to the scrollview");
        curtainImage.layer.borderColor = [[UIColor whiteColor]CGColor];
        curtainImage.layer.borderWidth = 4;
        curtainImage.layer.cornerRadius = 4.0;
        curtainImage.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventTap)];
        
        [myScrollView addGestureRecognizer:tapGesture];
        
        //set the default time delay.
        delay = 10.0;
        //set the default speedAppear
        speedAppear = 0.65;
        //set the default speedDissapear
        speedDissapear = 0.65;
        
        myScrollView.contentSize = CGSizeMake(155, 250);
        myScrollView.delegate = self;
        [self addSubview:pullTabView];
        [self setup];
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
    NSLog(@"Calling awake from NIB");
    [[NSBundle mainBundle] loadNibNamed:@"PullTabView" owner:self options:nil];
    myScrollView.delegate = self;
    [self addSubview:pullTabView];
}


#pragma mark Scrolling Methods

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [UIView beginAnimations:@"animation1" context:NULL];    
    [UIView setAnimationDuration:0.25]; 
    if (scrollView.contentOffset.y <= -PULL_TAB_HEADER_HEIGHT) {
        
        pullTabArrow.transform = CGAffineTransformMakeRotation(3.14159265);
        pullTabMsg.text = @"Release to view persona...";
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,-PULL_TAB_HEADER_HEIGHT)];
    }else{
        pullTabArrow.transform = CGAffineTransformMakeRotation(0);
        pullTabMsg.text = @"Pull to view persona...";        
        
        if (scrollView.contentOffset.y >= 0) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,0)];
        }
    }
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y <= -PULL_TAB_HEADER_HEIGHT) {
        [self hidePhoto];
    }
}

//Setup the Pull tab as initially hidden.
- (void) setup{
    //Perform some actions...
    pullTabView.frame  = CGRectMake(0, 0, 155, 0);
    curtainImage.frame = CGRectMake(0, -155, 155, 155);
    myScrollView.frame = CGRectMake(0, -153, 155, 133);
    [self setBackgroundEnabled];
    [self showPhoto];
}

- (void) hidePhoto{
    NSLog(@"Hide the photo...");
    [UIView beginAnimations:@"animation2" context:NULL];    
    [UIView setAnimationDuration:speedDissapear]; 
    
    //Perform some actions...
    pullTabView.frame  = CGRectMake(0, 0, 155, 0);
    curtainImage.frame = CGRectMake(0, -155, 155, 155);
    myScrollView.frame = CGRectMake(0, -153, 155, 133);

    //Tell the delegate that the pull tab is no longer visable.
    [[self delegate] pullTabVisable:NO];

    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    [self performSelector:@selector(setBackgroundEnabled) withObject:nil afterDelay:speedDissapear];
    
    //wait a configurable amount of time to show the photo again...
    [self performSelector:@selector(showPhoto) withObject:nil afterDelay:delay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show_dialogview" object:self];
}

- (void) showPhoto{
    [self setBackgroundDisabled];
    NSLog(@"Show the photo...");
    [UIView beginAnimations:@"animation3" context:NULL];    
    [UIView setAnimationDuration:speedAppear]; 
    
    curtainImage.frame = CGRectMake(0, 0, 155, 155);
    pullTabView.frame = CGRectMake(0, 0, 165, 254);
    myScrollView.frame = CGRectMake(0, 120, 165, 133);

    //Tell the delegate that the pull tab is visable.
    [[self delegate] pullTabVisable:YES];

    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // start animating!
    [UIView commitAnimations];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"close_dialogview" object:self];
    
}

- (void)setBackgroundEnabled{
    [pullTabView superview].hidden = YES;
}

- (void)setBackgroundDisabled{
    [pullTabView superview].hidden = NO;    
}

- (void) setDelay:(NSTimeInterval)timeDelay{
    delay = timeDelay;
}

- (void) setPhoto:(UIImage *)photo{
    [curtainImage setImage:photo];
}

- (void) setPullTab:(UIFont*)font{
    [pullTabTitle setFont:font];
}

- (void) setPullTabMessage:(UIFont *)font{
    [pullTabMsg setFont:font];
}

- (void) setSpeedAppear:(NSTimeInterval)speed{
    speedAppear = speed;
}

- (void) setSpeedDissapear:(NSTimeInterval)speed{
    speedDissapear = speed;
}

- (void) eventTap{
    NSLog(@"Tap detected");
    [myScrollView scrollRectToVisible:CGRectMake(10,10,100,100) animated:YES];
}

@end

