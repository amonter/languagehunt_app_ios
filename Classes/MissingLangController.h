//
//  MissingLangController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/28/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissingLangController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>




@property (nonatomic, retain) IBOutlet UILabel* languageLabel;
@property (nonatomic, retain) IBOutlet UILabel* mobileLabel;
@property (nonatomic, retain) IBOutlet UILabel* postalLabel;
@property (nonatomic, retain) IBOutlet UITextField* language;
@property (nonatomic, retain) IBOutlet UITextField* number;
@property (nonatomic, retain) IBOutlet UITextField* postalCode;

- (IBAction)submitForm:(id)sender;




@end
