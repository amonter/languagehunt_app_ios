//
//  PaymentViewController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/14/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKView.h"

@interface PaymentViewController : UIViewController<PTKViewDelegate>


@property(weak, nonatomic) PTKView *paymentView;

@end
