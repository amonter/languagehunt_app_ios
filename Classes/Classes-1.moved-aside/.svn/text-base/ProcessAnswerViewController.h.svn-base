//
//  ProcessAnswerViewController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 20/03/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"


@interface ProcessAnswerViewController :  UIViewController <UITextViewDelegate> {

	UIButton *addQuestionButton;
	int positionButton;
	int positionField;
	NSMutableArray *fields;
	CGFloat animatedDistance;
	UIScrollView *theScrollView;
	Question *theQuestion;
}

@property int positionButton;
@property int positionField;
@property (nonatomic, retain) NSMutableArray *fields;
@property (nonatomic, retain) Question *theQuestion;
@property (nonatomic, retain) UIButton *addQuestionButton;
@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;

- (void) addTextField;
- (void) removeButton;
- (void) awesomeAlert;


@end
