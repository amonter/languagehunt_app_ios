//
//  IOSUtility.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 11/27/13.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "IOSUtility.h"

@implementation IOSUtility


+ (CGSize) checkSizeWithFont:(CGSize) cgSize theFont:(UIFont*) aFont theText:(NSString*) text {
    CGSize expectedLabelSize;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        NSDictionary *attributes = @{NSFontAttributeName: aFont};
        CGRect result = [text boundingRectWithSize:cgSize options:NSStringDrawingUsesLineFragmentOrigin||NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGFloat height = ceilf(result.size.height);
        CGFloat width  = ceilf(result.size.width);
        expectedLabelSize = CGSizeMake(width, height);
       
    } else {
        expectedLabelSize = [text sizeWithFont:aFont constrainedToSize:cgSize lineBreakMode:UILineBreakModeWordWrap];
    }
    
	return expectedLabelSize;
}

@end
