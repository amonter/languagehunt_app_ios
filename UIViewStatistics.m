//
//  UIViewStatistics.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 27/01/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "UIViewStatistics.h"
#import "Answer.h"
#import "QuartzCore/QuartzCore.h"


@implementation UIViewStatistics
@synthesize graphHeight;
@synthesize graphWidth;
@synthesize answerArray;
@synthesize yValue;
@synthesize colorsArray;
@synthesize theImageView;
@synthesize questionObj;


- (id)initWithFrame:(CGRect)frame uiImageFrame:(CGRect) theFrame {
    if (self = [super initWithFrame:frame]) {
       
		
		NSArray *colorsArrayObj =  [[NSArray alloc] initWithObjects:@"9000FF",
		@"90FF00",  
		@"FF9000",
		@"0074FF",
		@"00FF74",
		@"FFF200",
		@"F200FF",
		@"22B573",
		@"FF0074",
		@"00FFF2",
		@"E99C71",
		@"40CD29",
		@"3AC59F",   
		@"000000", nil ];
		self.colorsArray = colorsArrayObj;
		
		theImageView = [[AsyncImageView alloc] initWithFrame:theFrame];
		[colorsArrayObj release];		
    }
    return self;
}


- (void) drawPoint: (int) y_val x_loc: (int) x_loc theAnswer: (Answer *)theAnswer  {
	
	UIColor *mainTextColor = [UIColor darkGrayColor];
	[mainTextColor set];
        
	CGPoint point = CGPointMake(x_loc, y_val);
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:13.7];
    
    NSString *answer = [[[NSString alloc] initWithFormat:@"%@", theAnswer.answerDescription] autorelease];	
	[answer drawAtPoint:point forWidth:300 withFont:font minFontSize:18 actualFontSize:NULL
			  lineBreakMode: UILineBreakModeWordWrap baselineAdjustment:UIBaselineAdjustmentAlignBaselines]; 
	
	NSString *result = [[[NSString alloc] initWithFormat:@"%i", theAnswer.resStat] autorelease];				
	UIFont *font2 = [UIFont fontWithName:@"Helvetica-Bold" size:13.7];
	[result drawAtPoint:CGPointMake(x_loc + 236, y_val) forWidth:300 withFont:font2 minFontSize:18 actualFontSize:NULL
		  lineBreakMode: UILineBreakModeWordWrap baselineAdjustment:UIBaselineAdjustmentAlignBaselines];

}


- (int) writeStringLong: (NSString *) theDescription y_val: (int) y_val x_loc: (int) x_loc theAnswer: (Answer *)theAnswer {
			
	    // It trims it after 16
		UIColor *mainTextColor = [UIColor darkGrayColor];
		[mainTextColor set];
	
		NSString *lineOne = [theDescription substringToIndex:16];
		NSLog(@"line one %@", lineOne);
		CGPoint point = CGPointMake(x_loc, y_val);
		UIFont *font = [UIFont fontWithName:@"Verdana" size:13.7];
		[lineOne drawAtPoint:point forWidth:300 withFont:font minFontSize:18 actualFontSize:NULL
			   lineBreakMode: UILineBreakModeWordWrap baselineAdjustment:UIBaselineAdjustmentAlignBaselines];  				
				
		int totalLenght = [theDescription length] - (16);
		NSString *lineTwo = [theDescription substringWithRange:NSMakeRange(16, totalLenght)];	
        NSLog(@"line two %@", lineTwo);	
		CGPoint point2 = CGPointMake(x_loc, y_val + 15);
		[lineTwo drawAtPoint:point2 forWidth:300 withFont:font minFontSize:18 actualFontSize:NULL
			   lineBreakMode: UILineBreakModeWordWrap baselineAdjustment:UIBaselineAdjustmentAlignBaselines]; 				
		
		NSString *result = [[[NSString alloc] initWithFormat:@"%i", theAnswer.resStat] autorelease];				
		UIFont *font2 = [UIFont fontWithName:@"Verdana-Bold" size:13.7];
		[result drawAtPoint:CGPointMake(x_loc + 126, y_val + 17) forWidth:300 withFont:font2 minFontSize:18 actualFontSize:NULL
			  lineBreakMode: UILineBreakModeWordWrap baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		y_val = y_val + 17;
		
	return y_val;

}
- (void)drawRect:(CGRect)rect {
	//220 set External
    int y_val = self.yValue;
	int x_val = 35;
	int counter = 0;
	bool prev2Lines = FALSE;
    for (Answer *theAnswer in answerArray) {		
        
		int x_loc = 0;	
		NSString *theDescription = theAnswer.answerDescription;	
		CGContextRef ctx = UIGraphicsGetCurrentContext();				
		x_loc =  x_val;
		y_val = y_val + 25;				
		if ([theDescription length] > 60) {
			prev2Lines = TRUE;
			[self writeStringLong: theDescription y_val: y_val x_loc: x_loc theAnswer: theAnswer];  	
			x_loc =  x_val + 150;								
		}
		else {		
			prev2Lines = FALSE;
			[self drawPoint: y_val x_loc: x_loc theAnswer: theAnswer];
		}	
		
		UIColor *theColor = [self colorWithHexString:[colorsArray objectAtIndex:counter]];				
		CGFloat* components = CGColorGetComponents(theColor.CGColor);
		CGFloat red = components[0];
		CGFloat green = components[1];
		CGFloat blue = components[2];		
		
		CGContextSetRGBFillColor(ctx, red,green,blue, 1);		
		CGContextFillRect(ctx, CGRectMake(x_loc -25 , y_val -1, 19, 19));
		//}
		/*
		else {			
			x_loc =  x_val + 156;				
			if ([theDescription length] > 16) {				
				y_val = [self writeStringLong: theDescription y_val: y_val x_loc: x_loc theAnswer: theAnswer];				
			} 
			else {				
				[self drawPoint: y_val x_loc: x_loc theAnswer: theAnswer];
				if(prev2Lines) {
					y_val = y_val + 25;
				}
			}		 
		}
		*/		  
		counter++;		
    } 	
	
}

- (AsyncImageView *) getGraphic:(NSMutableArray *) arrayAnswers questionDes:(NSString *) des  {
	
	NSMutableString *data = [[NSMutableString alloc] init];
	NSMutableString *answerData = [[NSMutableString alloc] init];
	NSMutableString *colorArray = [[NSMutableString alloc] init];
	int index = 0;
	
	for (Answer *theAns in arrayAnswers) {
		
		NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
		if (theAns.resStat != 0) {
		
			[data appendString:[[[NSString alloc] initWithFormat:@"%i,",theAns.resStat] autorelease]];
			[colorArray appendString:[[[NSString alloc] initWithFormat:@"%@,", [colorsArray objectAtIndex:index]] autorelease]];		
			[answerData appendString:[[[NSString alloc] initWithFormat:@"%@|",theAns.answerDescription] autorelease]];			
		}
		
		index++; 
		[loopPool release];
	}	
	
    NSString *formatedColors = [colorArray substringToIndex:[colorArray length] -1];	
	NSString *theResData = [data substringToIndex:[data length] -1];
	//365x165
	//chart.apis.google.com/chart?cht=p3&chd=t:%@&chs=%ix%i&chl=%@&chco=0000FF&chtt=%@&chts=666666,17&&chco=%@
	
	NSLog(@" ANNEWER DATA %@", answerData);
	NSString *requestString = [[NSString alloc] initWithFormat:@"http://chart.apis.google.com/chart?cht=p3&chd=t:%@&chs=%ix%i&chco=%@",theResData,self.graphWidth, self.graphHeight, formatedColors];
	NSLog(@"%@", requestString);
	NSString *finalRequestString = [requestString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(imageLoaded)
																			name:@"send_ok" object: self.theImageView];
	
	
	NSURL *requestURL = [NSURL URLWithString:finalRequestString];	
	[theImageView loadImageFromURL:requestURL theImageFrame: CGRectMake(6,0,self.graphWidth,self.graphHeight)];
	
	[requestString release];
	[colorArray release];
	[data release];
	[answerData release];
	
	return theImageView;	
}

- (void) imageLoaded {

	
}



- (UIColor *) colorWithHexString: (NSString *) stringToConvert  {
	
	
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];     
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
}  


- (void)dealloc {
	[questionObj release];
	[theImageView release];
	[colorsArray release];
	[answerArray release];
    [super dealloc];
}


@end
