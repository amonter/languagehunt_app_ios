//
//  NotificationCell.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 16/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell {

    IBOutlet UILabel *theTapToTry;
    IBOutlet UILabel *theChatMessage;
    IBOutlet UIImageView *photoChat;
    IBOutlet UIView *theShadowBackground;
    IBOutlet UIImageView *thePhotoCorner;
    IBOutlet UILabel *nameLabel;
    NSMutableData* data;
    NSURLConnection* connection;
    IBOutlet UILabel *dateLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *theTapToTry;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *theChatMessage;
@property (nonatomic, retain) IBOutlet UIImageView *photoChat;
@property (nonatomic, retain) IBOutlet UIView *theShadowBackground;
@property (nonatomic, retain) IBOutlet UIImageView *thePhotoCorner;


- (void) setBackgroundShadow;
- (void) setOtherPhoto:(NSString *) theUrl;

@end
