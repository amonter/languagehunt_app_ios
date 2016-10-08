//
//  MetaMatcher.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 14/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "MetaMatcher.h"

@implementation MetaMatcher
//@synthesize matcherRequest, theMatch;



- (void) startHunting {
    
    NSLog(@"ALOHA HUNTING");
    //do the hunt now
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"match_found" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"no_match" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hunt_activated"];
        int profileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
        if (self.matcherRequest == nil){
            self.matcherRequest = [[TheMatcher alloc] init:profileId];
        }
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayMatch:)
                                                     name:@"match_found" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startHunting)
                                                     name:@"no_match" object:nil];
  
        [self.matcherRequest findMatch];
    }
}



- (void) displayMatch:(NSNotification *) data {
    
    [self.matcherRequest.huntRequest cancelConnectionForHunt];
    NSDictionary *allData = [data userInfo];
    self.theMatch = [[[MatchViewController alloc] initWithNibName:@"MatchViewController" bundle:nil] autorelease];
    self.theMatch.allData = allData;
    UIViewController *visible = navigationController.visibleViewController;
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [visible.navigationController pushViewController:self.theMatch animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
    //[visible.navigationController pushViewController:self.theMatch animated:NO];
}

- (void)dealloc {
    
    [matcherRequest release];
    [super dealloc];
}

@end
