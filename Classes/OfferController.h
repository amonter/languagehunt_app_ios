//
//  OfferController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/23/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchController.h"

@interface OfferController : BaseSearchController

@property (nonatomic, retain) NSString* theName;
@property int aggregateHelpWith;
@property int numberAdds;
@property (nonatomic,retain) NSMutableDictionary* proficiencyLevels;
- (void) retrieveOffers;
@end


