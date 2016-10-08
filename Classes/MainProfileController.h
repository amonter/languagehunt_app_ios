//
//  MainProfileController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/10/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDataController.h"
#import "ProfileDummyTable.h"
#import "ProfileDataLanguageController.h"


@protocol MainProfileDataDelegate <NSObject>
- (void)goSelected:(int) element;
@end


@interface MainProfileController : UIViewController <UIScrollViewDelegate>{

    id<DummyProfileDataDelegate> delegate;
}

@property (retain) id delegate;
@property (nonatomic, retain) ProfileDataController* profileDataTable;
@property (nonatomic, retain) ProfileDataLanguageController* profileDataLanguage;
@property (nonatomic, retain) IBOutlet UIScrollView* underScroll;
@property (nonatomic, retain) NSMutableDictionary *profileData;
@property (nonatomic, retain) ProfileDummyTable* dummyTable;

- (void) displayProfileData;
- (void) doCommit:(id)sender;
- (void)addKeepBrowsing;
- (void) removeButton;
- (void) redisplayDummyTable;

@end
