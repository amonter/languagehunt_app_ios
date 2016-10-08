//
//  PaymentTipControllerController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/30/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "PaymentTipControllerController.h"

@interface PaymentTipControllerController ()

@end

@implementation PaymentTipControllerController
@synthesize tipImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Paymwnt Type -- -- -- - %i", self.paymentType);
   
    switch (self.paymentType) {
        case 1:
            self.tipImage.image = [UIImage imageNamed:@"confirm_paycoffee.png"];
            break;
        case 2:
            self.tipImage.image = [UIImage imageNamed:@"confirm_payguide.png"];
            break;
        case 3:
            self.tipImage.image = [UIImage imageNamed:@"confirm_payfood.png"];
            break;
        
    }
}


- (IBAction)removeView:(id)sender {
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
