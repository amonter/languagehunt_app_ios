//
//  MissingLangController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/28/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "MissingLangController.h"
#import "PeopleHuntRequests.h"

@interface MissingLangController ()

@end

@implementation MissingLangController
@synthesize language, number, languageLabel, mobileLabel, postalLabel, postalCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.language.delegate = self;
    self.number.delegate = self;
    self.postalCode.delegate = self;
}



- (IBAction)submitForm:(id)sender {
    
    NSDictionary* allData = [NSDictionary dictionaryWithObjectsAndKeys:language.text, @"language", number.text, @"number", postalCode.text, @"postalcode", [[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"], @"profile_id", nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allData
                                                       options:(NSJSONWritingOptions) (true ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON %@", jsonString);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thanks! We'll be in touch!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    
    PeopleHuntRequests* req = [[PeopleHuntRequests alloc] init];
    [req postMissingLanguage:jsonString];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
