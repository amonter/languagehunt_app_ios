//
//  FacebookProfileSelection.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 15/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookProfileSelection : UIViewController 


@property (nonatomic, retain) IBOutlet UILabel* theBioLabel;
@property (nonatomic, retain) NSDictionary *profileData;
@property (nonatomic, retain) IBOutlet UITableView *theTable;

@end
