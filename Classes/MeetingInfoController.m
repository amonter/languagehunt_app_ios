//
//  MeetingInfoController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 5/27/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "MeetingInfoController.h"

@interface MeetingInfoController ()

@end

@implementation MeetingInfoController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}


- (IBAction)touchDown:(id)sender {

    NSLog(@"Touch DOWN DOWN");
    [self.view removeFromSuperview];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
