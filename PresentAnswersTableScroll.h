//
//  PresentAnswersTableScroll.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 20/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PresentAnswersTableScroll : UITableViewController <UITextFieldDelegate> {

	int numberRows;
	int currentResponder;
}

@property int currentResponder;
@property int numberRows;
- (void) subTractCell:(id) sender;
- (void) addCell:(id) sender;
@end
