//
//  AddAnswerController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 02/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddAnswerController : UIViewController <UITableViewDelegate, UITableViewDataSource ,UITextViewDelegate, UIAlertViewDelegate> {
	UITableView *tableView;
	UITextView *theTextView;
	NSString *theAnswer;	
	int questionId;
}

@property int questionId;
@property (nonatomic, retain) IBOutlet UITextView *theTextView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *theAnswer;


- (IBAction) goBack;
- (bool) validateQuestionData;

@end
