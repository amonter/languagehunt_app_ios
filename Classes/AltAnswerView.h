//
//  AltAnswerView.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 06/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"


@interface AltAnswerView : UIView {

	Question *aQuestion;
	int yValue;
}

@property int yValue;
@property (nonatomic, retain) Question *aQuestion;

- (id)initWithFrame:(CGRect)frame questionP:(Question *)theQuestion;

@end
