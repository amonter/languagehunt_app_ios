//
//  ProfileDataControllerController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 7/10/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "ProfileDataController.h"

@interface ProfileDataController ()

@end

@implementation ProfileDataController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {   
    
    
    if ([self.locations count] > 0 && ![self.addedSection containsObject:@"locations"]&& [indexPath section] == 1) {
        [self.addedSection addObject:@"locations"];
        NSLog(@"locations %f", self.locationsSize);
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.locationsSize], @"section", @"locations", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return self.locationsSize ;
    }
    
    if (self.about.length > 0 && ![self.addedSection containsObject:@"about"] && [indexPath section] == 0) {
        [self.addedSection addObject:@"about"];
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.aboutSize], @"section", @"about", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return self.aboutSize ;
    }
    
	return 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
