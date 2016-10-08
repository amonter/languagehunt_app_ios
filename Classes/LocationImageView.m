//
//  LocationImageView.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
// location

#import "LocationImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LocationImageView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier imageUrl:(NSString *) theString {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(34.0, 45.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        theImageUrl = theString;
        remoteImage = true;
        //self.centerOffset = CGPointMake(-3, -22.5);
    }
    return self;
}


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(34.0, 45.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        remoteImage = false;
        //self.centerOffset = CGPointMake(3, -22.5);
    }
    return self;    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIImage *pinImage = [UIImage imageNamed:@"pin.png"];    
    UIImage *anImage = nil;
    // Drawing code
    if (remoteImage){
        NSURL *theUrl = [NSURL URLWithString:theImageUrl];
        NSData *theData = [NSData dataWithContentsOfURL:theUrl];
        anImage = [UIImage imageWithData:theData];
       
    } else {
        NSString *photoPath = @"Documents/profilePhotoPull.jpg";
        NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:photoPath];
        anImage = [UIImage imageWithContentsOfFile:thePath];        
    }
    
    [pinImage drawInRect:CGRectMake(0.0, 0.0, 34.0, 45.0)];
    [anImage drawInRect:CGRectMake(2.0, 2.0, 30.0, 30.0)];    
    
}


@end
