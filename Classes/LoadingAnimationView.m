//
//  LoadingAnimationView.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 03/02/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "LoadingAnimationView.h"
#import <QuartzCore/QuartzCore.h>


@implementation LoadingAnimationView
@synthesize spinner;
@synthesize theLabel;
@synthesize parentView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
		self.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.4];       
		self.alpha = 1.0;
        
         self.clipsToBounds = YES;
         if ([self.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) self.layer setCornerRadius: 10];
         self.layer.shadowRadius = 6.0f;
         self.layer.shadowOpacity = 0.6;
         self.layer.shadowOffset = CGSizeMake(0, 6);
         self.layer.shouldRasterize = YES;
         
		
		UIActivityIndicatorView *activityIndObj = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
		activityIndObj.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 );
		self.spinner = activityIndObj;
		[self addSubview: spinner];
		[self.spinner startAnimating];
    }
    return self;
}



- (void)dealloc {
	[spinner release];
	[theLabel release];
    [super dealloc];
}


@end