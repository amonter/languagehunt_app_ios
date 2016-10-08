//
//  ShareAuthenticateController.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 17/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareAuthenticateController : UIViewController{

    IBOutlet UIImageView *backgroundCurve;
    IBOutlet UIImageView *backgroundCurve2;
    
}


@property (nonatomic, retain) NSString *authenticate;
@property (nonatomic, retain) IBOutlet UIView *twitterSubview;
@property (nonatomic, retain) IBOutlet UIView *facebookSubview;
@property (nonatomic, retain) UIImageView *backgroundCurve;
@property (nonatomic, retain) UIImageView *backgroundCurve2;


- (void) setUpTwitter:(id)sender;
- (void) backButtonTapped;

@end
