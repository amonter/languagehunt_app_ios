//
//  HuntFeedController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 11/10/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "HuntProfileHelper.h"
#import "HuntFeedCell.h"
#import "TheMatcher.h"
#import "FeedTableBase.h"
#import "HuntProfileHelper.h"
#import "MatchViewController.h"
#import "ProtocolCommunication.h"
#import "MyCustomSearch.h"

@interface MainFeelersCardController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, HuntProfileHelperDelegate> {
    
    HuntProfileHelper *huntHelper;
    NSMutableArray *selectedAnswers;
    
    NSMutableSet *haveTooAnswers;
    ProtocolCommunication *protocol;
    
    NSMutableDictionary *parentAnswers;
    UITextView *knowledgeField;
    UIImageView *characterImageAddExperience;
    NSMutableArray *changingAnswers;
    NSMutableArray *feelerDataArray;
    
    bool isHuntHappening;
    TheMatcher *matcherRequest;
    bool fastHunting;
    bool hitOnce;
    bool hitSharingOnce;
    bool showExitingFeelerAdded;
    bool updateDataFeeler;
    bool insertTheFeelerBool;
    
    int bundleId;
    int huntId;
    NSString *bundleName;
    NSString *theSearchText;
    
    NSTimer *theTimer;
    NSString *matchedUsername;
    NSDictionary *foundData;
    MatchViewController *theMatch;
    NSMutableArray *tempInserts;
    dispatch_queue_t queue;
    NSString *location;
    NSString *feelerData;
    
    MyCustomSearch *searchBar;
    IBOutlet UITableView *tableView;
    
    
}


@property int segmentDownload;
@property int lastSelectedFeelerId;
@property int huntId;
@property int bundleId;
@property int totalAnswers;
@property bool fastHunting;
@property bool hitOnce;
@property bool hitSharingOnce;
@property bool showExitingFeelerAdded;
@property bool updateDataFeeler;
@property bool insertTheFeelerBool;

@property (nonatomic, retain) NSString *theSearchText;
@property (nonatomic, retain) MyCustomSearch *searchBar;
@property (nonatomic, retain) NSString *feelerData;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *bundleName;
@property (nonatomic, retain) NSMutableArray *tempInserts;
@property (nonatomic, retain) MatchViewController *theMatch;
@property (nonatomic, retain) TheMatcher *matcherRequest;
@property (nonatomic, retain) NSMutableArray *changingAnswers;
@property (nonatomic, retain) NSMutableArray *feelerDataArray;
@property (nonatomic, retain) UITextView *knowledgeField;
@property (nonatomic, retain) NSMutableDictionary *parentAnswers;
@property (nonatomic, retain) NSMutableDictionary *dateNew;
@property (nonatomic, retain) ProtocolCommunication *protocol;
@property (nonatomic, retain) NSMutableArray *selectedAnswers;
@property (nonatomic, retain) NSMutableSet *haveTooAnswers;
@property (nonatomic, retain) UIImageView *characterImageAddExperience;
@property (nonatomic, retain) NSDictionary *foundData;
@property (nonatomic, retain) NSString *matchedUsername;
@property (nonatomic, retain) IBOutlet UITableView *tableView;



- (CGSize) getCellWidth:(UITableView *)theTableView copy:(NSString *)copy;
- (void) closeSelection;
- (void) backButtonTapped;
- (void) doFastHunting;
- (void) dataProvidingAnswers:(NSNotification *) data;
- (void) startHuntingNow;
- (void) updateData;
- (void) managePopUps:(NSArray *)feelerArray;
- (void)insertTheFeeler:(id) sender;
- (void) resetTable;
- (void) shareFriendsPop:(bool)logIn;
- (void) postedSuccessfullyFB:(UIView*) successView;

@end
