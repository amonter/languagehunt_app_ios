//
//  MessageConfirmationController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 6/16/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "MessageConfirmationController.h"

@interface MessageConfirmationController ()

@end

@implementation MessageConfirmationController
@synthesize anImage, numberCount, checkList, footerImage, helpMode, iconImage, msgOverlay, arrow_msg;
@synthesize successMsg, shareBtn, inboxBtn, laterLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    numberCount.font = [UIFont fontWithName:@"Delicious-Heavy" size:26];
    if (self.checkList == 1){
        numberCount.text = [NSString stringWithFormat:@"%i message", self.checkList];
        //self.anImage.image = [UIImage imageNamed:@"success_one.png"];
        //self.numberCount.hidden = true;
    } else {
        numberCount.text = [NSString stringWithFormat:@"%i messages", self.checkList];
    }
    
  
    self.iconImage.hidden = true;
    self.successMsg.hidden = true;
    self.msgOverlay.hidden = false;
    self.arrow_msg.hidden = false;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"has_shared"]){
        self.shareBtn.hidden = false;
        self.footerImage.hidden = false;
        self.laterLabel.hidden = false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)goInbox:(id)sender {
    //if ([[NSUserDefaults standardUserDefaults] objectForKey:@"has_shared"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"go_inbox" object:self userInfo:nil];
    //}
}

- (IBAction)goInbox2:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"go_inbox" object:self userInfo:nil];
}



- (IBAction)doHelp:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connection_info" object:self userInfo:nil];
}

@end
