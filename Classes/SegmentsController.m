//
//  SegmentsController.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "SegmentsController.h"

@implementation SegmentsController

@synthesize viewControllers, navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)theViewControllers {
    if (self = [super init]) {
        self.navigationController = aNavigationController;  
        self.viewControllers = theViewControllers;
    }
    return self;
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    NSUInteger index = aSegmentedControl.selectedSegmentIndex;
    NSLog(@"CHANGE %i", index);
    UIViewController * incomingViewController = [self.viewControllers objectAtIndex:index];
    
    NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
    [self.navigationController setViewControllers:theViewControllers animated:NO];
    
    incomingViewController.navigationItem.titleView = aSegmentedControl;
}

- (void)dealloc {
    self.viewControllers = nil;
    self.navigationController = nil;
    [super dealloc];
}

@end
