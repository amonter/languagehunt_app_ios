//
//  NextViewController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 27/09/2010.
//  Copyright 2010 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NextViewController : UIViewController {

	IBOutlet UIScrollView *avatarsView;
}

@property (nonatomic,retain) UIScrollView *avatarsView;
- (IBAction) goBack;

@end
