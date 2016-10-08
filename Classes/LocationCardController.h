//
//  LocationCardController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 26/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomSearch.h"
#import "BaseSearchController.h"

@interface LocationCardController : BaseSearchController

@property (nonatomic, retain) NSMutableArray* selectedData;

- (void)doRestData;
@end
