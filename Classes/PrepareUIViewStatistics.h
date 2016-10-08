//
//  PrepareUIViewStatistics.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 25/03/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "UIViewStatistics.h"
#import "AsyncImageView.h"


@interface PrepareUIViewStatistics : NSObject {

	AsyncImageView *asyncImage;
	int offsetHeight;
}

@property int offsetHeight;
@property (nonatomic, retain) AsyncImageView *asyncImage;

- (UIViewStatistics *) drawStatsResults:(Question *) theQuestion theView:(UIScrollView *) view theYValue:(int) yvalue;

@end
