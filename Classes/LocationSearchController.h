//
//  LocationSearchController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchController.h"


@interface LocationSearchController : BaseSearchController 

    

@property (nonatomic, retain) NSArray* orderedLocations;

- (void) retrieveLocationData;
- (void) hidePageControllers;
- (void) sortLocations;
@end
