//
//  ExchangeDealView.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 3/20/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "ExchangeDealView.h"

@implementation ExchangeDealView

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

- (void) setDeal:(int) rating {
    
    UIImageView *dealSign = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 13, 13)];
    dealSign.tag = 9881891;
    
    NSLog(@"Setting deal %i", rating);
    
    switch (rating) {
            case 1:
            dealSign.image = [UIImage imageNamed:@"coffee.png"];
                break;
            case 2:
            dealSign.image = [UIImage imageNamed:@"money.png"];
                break;
            case 3:
            dealSign.image = [UIImage imageNamed:@"food.png"];
                break;
    }
        
        
    [self addSubview:dealSign];
}

- (void) removeImageView {    
    [[self viewWithTag:9881891] removeFromSuperview];
}


@end
