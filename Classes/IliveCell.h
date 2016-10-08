//
//  IliveCell.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 17/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IliveCell : UITableViewCell {

	UITextField *theField;
}


@property (nonatomic, retain) UITextField *theField;
- (UITextField *)textFieldRounded;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier theLabel:(NSString *) aLabel; 

@end
