//
//  FooterCustomView.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 24/02/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "FooterCustomView.h"

@implementation FooterCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {      
         NSLog(@"Touch Footer");
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"touch_interaction" object:self];        
    }
}


@end
