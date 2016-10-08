//
//  HelpWithController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomSearch.h"
#import "BaseSearchController.h"

@interface HelpWithController : BaseSearchController <UIAlertViewDelegate>


@property bool hideDone;
@property int aggregateHelpWith;
@property int numberAdds;
@property (nonatomic,retain) UISlider* theSlider;
@property (nonatomic,retain) NSMutableDictionary* proficiencyLevels;
@property (nonatomic,retain) NSMutableDictionary* proficiencyResults;
- (void) retrieveHelpData;
@end
