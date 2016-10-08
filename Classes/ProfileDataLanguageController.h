//
//  ProfileDataLanguageController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/11/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "MatchDataTableController.h"

@protocol ProfileDataDelegate <NSObject>
- (void)editSelected:(int) element;
@end


@interface ProfileDataLanguageController : MatchDataTableController {
    id<ProfileDataDelegate> delegate;
}

@property (retain) id delegate;

@end
