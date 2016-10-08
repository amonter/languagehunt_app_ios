//
//  LanguageRatingView.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 5/25/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "LanguageRatingView.h"

@implementation LanguageRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
        //topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];
       
        
        
    }
    return self;
}



- (void) setRating:(int) rating {
    
    UIImageView *pageControl1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 13, 13)];
    UIImageView *pageControl2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2, 13, 13)];
    UIImageView *pageControl3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 2, 13, 13)];
    UIImageView *pageControl4 = [[UIImageView alloc] initWithFrame:CGRectMake(45, 2, 13, 13)];
    UIImageView *pageControl5 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 2, 13, 13)];
    
    
    switch (rating) {
        case 1:
            pageControl1.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl2.image = [UIImage imageNamed:@"star_empty.png"];
            pageControl3.image = [UIImage imageNamed:@"star_empty.png"];
            pageControl4.image = [UIImage imageNamed:@"star_empty.png"];
            pageControl5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        case 2:
            pageControl1.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl2.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl3.image = [UIImage imageNamed:@"star_empty.png"];
            pageControl4.image = [UIImage imageNamed:@"star_empty.png"];
            pageControl5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        case 3:
            pageControl1.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl2.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl3.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl4.image = [UIImage imageNamed:@"star_empty.png"];
            pageControl5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        case 4:
            pageControl1.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl2.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl3.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl4.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl5.image = [UIImage imageNamed:@"star_empty.png"];
            break;
        case 5:
            pageControl1.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl2.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl3.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl4.image = [UIImage imageNamed:@"star_filled.png"];
            pageControl5.image = [UIImage imageNamed:@"star_filled.png"];
            break;
       
    }    
   
    
    [self addSubview:pageControl1];
    [self addSubview:pageControl2];
    [self addSubview:pageControl3];
    [self addSubview:pageControl4];
    //[self addSubview:pageControl5];
}



@end
