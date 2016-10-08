//
//  PresentAnswerCell.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 20/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PresentAnswerCell : UITableViewCell {

	int row;
	UIButton *addButton;
	UIButton *subButton;
	UITextField *theField;
}

@property int row;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UITextField *theField;
@property (nonatomic, retain) IBOutlet UIButton *subButton;

@end
