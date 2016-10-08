//
//  RadarCountView.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 27/05/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "RadarCountView.h"

@implementation RadarCountView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) setEndDegree:(float) endDeg {

    self->endDegree = endDeg;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    float startDeg = 270;    
    int x = 60;
    int y = 60;
    int r = 20;
    
   
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.3, 0.3, 0.3, 0.7);
    CGContextSetRGBFillColor(ctx,  0.3, 0.3, 0.3, 0.7);
    CGContextSetLineWidth(ctx, 1.0);
    
    //Draw a circle border
    CGContextStrokeEllipseInRect(ctx, CGRectMake(40.0, 40.0, 40.0, 40.0));
    CGContextFillEllipseInRect(ctx, CGRectMake(58.5, 58.5, 3.5, 3.5));
    
    //NSLog(@"END DEGREE %f", endDegree);
    
    //add the color o to the changing angle      
    CGContextSetRGBFillColor(ctx,  0.5, 0.5, 0.5, 0.3);
    CGContextMoveToPoint(ctx, x, y);
    CGContextAddArc(ctx, x, y, r, (startDeg)*M_PI/180.0, (endDegree)*M_PI/180.0, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
}

@end
