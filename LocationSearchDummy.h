//
//  LocationSearchDummy.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 12/23/13.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerDummy.h"

@interface LocationSearchDummy : UIViewController


@property (nonatomic, retain) NSArray* orderedLocations;
@property (nonatomic, retain) NSMutableDictionary* theDictionary;

- (void) retrieveLocationData;
- (void) hidePageControllers;
- (void) sortLocations;
- (void) testDummy;

@end
