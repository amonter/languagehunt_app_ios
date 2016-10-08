//
//  HuntFeedCell.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 11/10/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarImageView.h"

@protocol CellSelectionDelegate <NSObject>
- (void)meetNowCellSelected:(NSIndexPath *)indexPath sender:(id) theSender;
- (void)addMyselfAction:(NSIndexPath *)indexPath isSelected:(bool) selected;
@end




@interface HuntFeedCell : UITableViewCell {
    
    IBOutlet UIView *centerTextView;
    IBOutlet UIImageView *bottomTextView;
    IBOutlet UIImageView *characterImageNew;
    IBOutlet UIView *imagesView;
    IBOutlet UILabel *theHeaderText;
    IBOutlet UILabel *theText;
    IBOutlet UIButton *addMeButton;
    IBOutlet UIImageView *ribbon;
    IBOutlet UIButton *huntButton;
    id<CellSelectionDelegate> delegate;
    IBOutlet UIImageView *backgroundShadow;
    IBOutlet UIImageView *backgroundShadow2;
    IBOutlet UIImageView *lineSeparator;
    IBOutlet UIImageView *lineSeparator2;
    IBOutlet UILabel *findText;
    IBOutlet UILabel *integrationsText;
    IBOutlet UILabel *learners;
    bool isLast;
    bool isUnique;
    bool isTop;
    IBOutlet UIButton *threeDots;
    //avatars
    IBOutlet AvatarImageView *avatarOne;
    IBOutlet AvatarImageView *avatarTwo;
    IBOutlet AvatarImageView *avatarThree;
    
}

@property bool isTop;
@property bool isUnique;
@property bool isLast;
@property (retain) id delegate;
@property (nonatomic, retain) IBOutlet UIButton *addMeButton;
@property (nonatomic, retain) IBOutlet UIButton *huntButton;
@property (nonatomic, retain) IBOutlet UILabel *theText;
@property (nonatomic, retain) IBOutlet UILabel *theHeaderText;
@property (nonatomic, retain) IBOutlet UIView *centerTextView;
@property (nonatomic, retain) IBOutlet UIButton *threeDots;
@property (nonatomic, retain) IBOutlet UIImageView *characterImageNew;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundShadow;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundShadow2;
@property (nonatomic, retain) IBOutlet UILabel *findText;
@property (nonatomic, retain) IBOutlet UILabel *integrationsText;
@property (nonatomic, retain) IBOutlet UIImageView *lineSeparator;
@property (nonatomic, retain) IBOutlet UIImageView *lineSeparator2;
@property (nonatomic, retain) IBOutlet UIView *imagesView;
@property (nonatomic, retain) IBOutlet AvatarImageView *avatarOne;
@property (nonatomic, retain) IBOutlet AvatarImageView *avatarTwo;
@property (nonatomic, retain) IBOutlet AvatarImageView *avatarThree;
@property (nonatomic, retain) IBOutlet UILabel *learners;
@property (nonatomic, retain) IBOutlet UIImageView *ribbon;

- (IBAction) addMyselfAction:(id)sender;
- (IBAction) meetNow:(id)sender;
- (void) setAvatarImage;
- (void) huntButtonStateFind:(id)sender;
- (void) huntButtonStateScanning:(id)sender;
- (void) setBottomImage;
- (void) setTopImage;
- (void) clearTheBorders;
- (void) clearAllAvatars;
- (void) addAllAvatars:(NSArray *) images;
- (void) removeMyselfPhoto;

@end
