//
//  NSArray+PerformSelector.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector;

@end
