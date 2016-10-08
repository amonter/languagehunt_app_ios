//
//  ChatCell.h
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 03/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ChatCell : UITableViewCell {

    IBOutlet UILabel *theChatMessage;
    IBOutlet UIImageView *photoChat;
    IBOutlet UIView *theShadowBackground;
    IBOutlet UIImageView *thePhotoCorner;
    NSMutableData* data;
    NSURLConnection* connection;
    NSString *fileName;
    
}

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) IBOutlet UILabel *theChatMessage;
@property (nonatomic, retain) IBOutlet UIImageView *photoChat;
@property (nonatomic, retain) IBOutlet UIView *theShadowBackground;
@property (nonatomic, retain) IBOutlet UIImageView *thePhotoCorner;


- (void) setBackgroundShadow;
- (void) setOwnerPhoto;
- (void) setOtherPhoto:(NSString *) theUrl;


@end
