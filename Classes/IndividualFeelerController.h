//
//  IndividualFeelerController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 19/12/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileFlipController.h"
#import "HuntProfileHelper.h"

@interface IndividualFeelerController : UIViewController <UIScrollViewDelegate, HuntProfileHelperDelegate>{

    NSDictionary *feelerData;
    IBOutlet UIImageView *backgroundIndividual;
    IBOutlet UILabel *theText;
    IBOutlet UIView *centerTextView;
    IBOutlet UIView *buttonsView;
    IBOutlet UIView *topWhiteBG;
    IBOutlet UIButton *wantBtn;
    IBOutlet UIButton *knowBtn;
    IBOutlet UILabel *wantLbl;
    IBOutlet UILabel *knowLbl;
    IBOutlet UILabel *interestedLbl;
    IBOutlet UILabel *interestedLbl2;

}

@property bool knows;
@property bool wants;
@property bool reloadBack;
@property (nonatomic, retain) UIImageView *middleCard;
@property (nonatomic, retain) UIImageView *bottomCard;
@property (nonatomic, retain) HuntProfileHelper *profileHelper;
@property (nonatomic, retain) NSMutableDictionary *knowers;
@property (nonatomic, retain) NSMutableDictionary *wanters;
@property (nonatomic, retain) IBOutlet UIScrollView* theScrollView;
@property (nonatomic, retain) IBOutlet UIView *buttonsView;
@property (nonatomic, retain) NSDictionary *feelerData;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundIndividual;;
@property (nonatomic, retain) IBOutlet UILabel *theText;
@property (nonatomic, retain) IBOutlet UIView *centerTextView;
@property (nonatomic, retain) IBOutlet ProfileFlipController *flipView;
@property (nonatomic, retain) IBOutlet UIView *topWhiteBG;
@property (nonatomic, retain) IBOutlet UIButton *wantBtn;
@property (nonatomic, retain) IBOutlet UIButton *knowBtn;
@property (nonatomic, retain) IBOutlet UILabel *wantLbl;
@property (nonatomic, retain) IBOutlet UILabel *knowLbl;
@property (nonatomic, retain) IBOutlet UILabel *interestedLbl;
@property (nonatomic, retain) IBOutlet UILabel *interestedLbl2;



- (void) backButtonTapped;
- (void) createAvatarImage:(int)y_val x_val:(int)x_val imageUrl:(NSString *)theImageUrl profileId:(int) theProfileId containerView:(UIView *) container;
- (void) postedSuccessfullyFB:(UIView*) successView;
- (void)addMyselfAction:(id) sender;
- (void)meetNowCellSelected:(id) theSender;

@end
