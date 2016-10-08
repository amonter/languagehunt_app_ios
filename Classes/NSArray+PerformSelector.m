//
//  NSArray+PerformSelector.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "NSArray+PerformSelector.h"

@implementation NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector {
    NSMutableArray * results = [NSMutableArray new];
    
    for (id object in self) {
        id result = [object performSelector:selector];
        //NSLog(@"RES RES %@", object);
        [results addObject:result];
    }
    
    return results;
}

@end
