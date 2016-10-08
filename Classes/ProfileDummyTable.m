//
//  ProfileDummyTable.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/30/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "ProfileDummyTable.h"

@interface ProfileDummyTable ()

@end

@implementation ProfileDummyTable
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) customTableOrder {
    //add setup values
    /*[self.addedSection addObject:@"help"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.helpSize], @"section", @"help", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 0]];
    
    [self.addedSection addObject:@"locations"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.locationsSize], @"section", @"locations", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 1]];*/
    
    [self.addedSection addObject:@"interest"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestSize], @"section", @"interest", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 1]];
    
    [self.addedSection addObject:@"about"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.aboutSize], @"section", @"about", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 0]];
    
    
    /*[self.addedSection addObject:@"askFor"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestSize], @"section", @"askFor", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 3]];*/
}


- (void)editVersion:(UILabel *)dataLabel backgroundView:(UIView *)backgroundView {
    
    /*//change info level dimentions
    CGRect dataFrame = dataLabel.frame;
    dataFrame.size.width = 130;
    dataLabel.frame = dataFrame;
    
    CGRect backFrame = backgroundView.frame;
    backFrame.size.width = 285;
    backgroundView.frame = backFrame;
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.tag = dataLabel.tag;
    actionButton.backgroundColor = [UIColor clearColor];
    [actionButton setFrame:CGRectMake(240, 4, 48, 30)];
    [actionButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitle:@"Edit" forState:UIControlStateNormal];
    actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [[[backgroundView superview] superview] addSubview:actionButton];*/
}



- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"HEIGHT-----33333--------- Section %i row %i", [indexPath section], [indexPath row]);
    //NSLog(@"INTERESTS ++++++++ %@", self.interest);    
    
    if ([indexPath section] == 2) {
        NSLog(@"interests %f", self.interestSize);
        if (self.interestSize > 35) return self.interestSize + 10;
        return self.interestSize;
    }
    
    
    if ([indexPath section] == 0) {
        NSLog(@"help %f", self.aboutSize);
        if (self.aboutSize > 35) return self.aboutSize + 10;
        return self.aboutSize;
    }
    
    
    return 0;
}



- (void) doAction:(id) sender {
    UIButton* selection = (UIButton*)sender;    
    [delegate goSelected:(int)selection.tag];
}



@end
