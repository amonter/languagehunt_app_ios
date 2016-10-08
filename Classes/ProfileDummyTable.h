//
//  ProfileDummyTable.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/30/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "DummyNewTable.h"


@protocol DummyProfileDataDelegate <NSObject>
- (void)goSelected:(int) element;
@end


@interface ProfileDummyTable : DummyNewTable {
    
     id<DummyProfileDataDelegate> delegate;
}

@property (retain) id delegate;

@end
