//
//  ProfileDataLanguageController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/11/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "ProfileDataLanguageController.h"

@interface ProfileDataLanguageController ()

@end

@implementation ProfileDataLanguageController
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.interest count] > 0 && ![self.addedSection containsObject:@"interest"]&& [indexPath section] == 3) {
        [self.addedSection addObject:@"interest"];
        NSLog(@"locations %f", self.locationsSize);
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestSize], @"section", @"interest", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return self.interestSize;
    }
    
    
    if ([self.help count] > 0 && ![self.addedSection containsObject:@"help"]&& [indexPath section] == 2) {
        [self.addedSection addObject:@"help"];
        NSLog(@"locations %f", self.locationsSize);
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.helpSize], @"section", @"help", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return self.helpSize ;
    }
    
    if ([self.interested count] > 0 && ![self.addedSection containsObject:@"interested"] && [indexPath section] == 1) {
        [self.addedSection addObject:@"interested"];
        
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestedSize], @"section", @"interested", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
         NSLog(@"INTERESTED NOW %@ %f", self.interested, self.interestedSize);
        return  self.interestedSize;
    }
    
    if (self.about.length > 0 && ![self.addedSection containsObject:@"about"] && [indexPath section] == 0) {        
        [self.addedSection addObject:@"about"];
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.aboutSize], @"section", @"about", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return self.aboutSize ;
    }
    
    
	return 0;
}

/*- (UIView*)checkWhatSection:(int)section {
    NSDictionary* sectionData = [self.addedHeight objectForKey:[NSString stringWithFormat:@"%i", section]];
    //NSLog(@"SECTION DATA %@", self.addedHeight );
    NSString* element = [sectionData objectForKey:@"element"];
    if ([element isEqualToString:@"interest"]) {
        [self.addedSection addObject:@"interest"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"Interests:";
        return [self cellLayout:cellDim iconImageName:iconImageName content:interest labelInfo:textInfo];
    }
    
    
    if ([element isEqualToString:@"about"]) {
        [self.addedSection addObject:@"about"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"About:";
        return [self cellLayout:cellDim iconImageName:iconImageName content:about labelInfo:textInfo];
    }

}*/


- (void)editVersion:(UILabel *)dataLabel backgroundView:(UIView *)backgroundView {
    //change info level dimentions
    CGRect dataFrame = dataLabel.frame;
    dataFrame.size.width = dataFrame.size.width - 50;
    dataLabel.frame = dataFrame;
    
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.tag = dataLabel.tag;
    [actionButton setFrame:CGRectMake(180, 8, 70, 30)];
    [actionButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 25.0f, 0.0f, 0.0f)];
    [actionButton setTitle:@"Edit" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [backgroundView addSubview:actionButton];
}

- (void) doAction:(id) sender {
    UIButton* selection = (UIButton*)sender;
    [delegate editSelected:selection.tag];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
