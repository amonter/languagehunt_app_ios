//
//  SegmentsController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentsController : NSObject


@property (nonatomic, retain) NSArray* viewControllers;
@property (nonatomic, retain) UINavigationController* navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController viewControllers:(NSArray *)viewControllers;
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl;

@end
