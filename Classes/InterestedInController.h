//
//  InterestedInController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomSearch.h"
#import "BaseSearchController.h"

@interface InterestedInController : BaseSearchController <UIAlertViewDelegate
>

@property int interestedAgregate;
- (void) loadInterestedInData;
@end
