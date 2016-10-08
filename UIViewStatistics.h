//
//  UIViewStatistics.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 27/01/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Question.h"


@interface UIViewStatistics : UIView {

	AsyncImageView *theImageView;
	NSArray *answerArray;
	NSArray *colorsArray;
	int graphWidth;
	int graphHeight;
	int yValue;
	Question *questionObj;
}

@property int yValue;
@property int graphHeight;
@property int graphWidth;


@property (nonatomic, retain) Question *questionObj;
@property (nonatomic, retain) AsyncImageView *theImageView;
@property (nonatomic,retain) NSArray *answerArray;
@property (nonatomic,retain) NSArray *colorsArray;
- (AsyncImageView *) getGraphic:(NSMutableArray *) arrayAnswers questionDes:(NSString *) des;
- (id)initWithFrame:(CGRect)frame uiImageFrame:(CGRect) theFrame; 
- (UIColor *) colorWithHexString: (NSString *) stringToConvert;
- (void) imageLoaded;
@end
