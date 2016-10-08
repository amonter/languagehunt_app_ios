//
//  RetrieveBundleData.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 30/07/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#define FACEBOOK_QUERY @"/me?fields=id,name,email,bio,picture.type(normal).height(90).width(90),friends.fields(name,id,picture.type(normal).height(90).width(90)),likes"

#import <Foundation/Foundation.h>

#import "AvatarImageView.h"
#import "ShareAuthenticateController.h"

@protocol HuntProfileHelperDelegate <NSObject>
- (void)facebookActionDone;
@end


@interface HuntProfileHelper : NSObject {

    UIViewController *visibleController;
    NSMutableArray *bundles;
    id<HuntProfileHelperDelegate> delegate;
    
}

@property (nonatomic, retain) NSMutableArray *bundles;
@property (retain) id delegate;




+ (void) serverResponse:(NSString *)response theDelegate:(UIViewController *) theDel;

+ (void) addHasBeenSentMessage:(UIView*) theView;
+ (void) dismmissLeftAlertViews;

+ (NSString *) getNumbersFromString:(NSString *) originalString;

+ (void) showTwitterPop:(UIViewController *) theController;
+ (void)postToTwitter:(NSString *) message;
+ (void) removeLoadingView:(UIView*) aView;
+ (void) addLoadingView:(UIView*) theView;

+ (void) facebookCall:(NSArray *)theMessages otherId:(int) theOtherId;
+ (void) doAlertError;
+ (void)setLoginVariables:(id) allData type:(NSString*)theType;
- (void) retrieveFriends;
- (void) getFriends;
+ (void) deleteSession:(UIViewController *) controller;
+ (void) checkProfileInterests;
+ (void)getProfileInterests:(NSMutableDictionary *)theDic;
+ (void) formatInterests:(NSMutableArray*) theArray;

@end
