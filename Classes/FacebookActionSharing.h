//
//  FacebookActionSharing.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 05/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarImageView.h"

@interface FacebookActionSharing : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>{

    IBOutlet UILabel *startTyping;
    
}

@property int currentLocation;
@property (nonatomic, retain) Class classType;
@property (nonatomic, retain) NSString *theMessage;
@property (nonatomic, retain) NSString *selectedFeeler;
@property (nonatomic, retain) IBOutlet UITableView *theTable;
@property (nonatomic, retain) IBOutlet UITextView *theTextField;
@property (nonatomic, retain) IBOutlet NSMutableArray *allFriends;
@property (nonatomic, retain) NSMutableString *theSearchText;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) IBOutlet AvatarImageView *avatar;
@property (nonatomic, retain) NSMutableArray *selectedFriends;
@property (nonatomic, retain) IBOutlet UILabel *startTyping;

@end
