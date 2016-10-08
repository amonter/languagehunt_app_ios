//
//  AltAnswerView.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 06/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "AltAnswerView.h"
#import <QuartzCore/QuartzCore.h> 

@implementation AltAnswerView
@synthesize aQuestion;
@synthesize yValue;

- (id)initWithFrame:(CGRect)frame questionP:(Question *)theQuestion {
    if (self = [super initWithFrame:frame]) {
     
		self.aQuestion = theQuestion;		
    }
    return self;
}



- (void)drawRect:(CGRect)rect {    
	
				
} 	



- (void)dealloc {
	[aQuestion release];
    [super dealloc];
}


@end
