//
//  AboutMeCell.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 17/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutMeCell : UITableViewCell {

	UILabel *aboutMeLabel;
	UITextView *aboutMeView;
}

@property (nonatomic, retain) IBOutlet UILabel *aboutMeLabel;
@property (nonatomic, retain) IBOutlet UITextView *aboutMeView;

- (UITextView *) createTextView;

@end
