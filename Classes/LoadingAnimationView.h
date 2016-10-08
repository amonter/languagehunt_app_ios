//
//  LoadingAnimationView.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 03/02/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingAnimationView : UIView {
    
	UIView *parentView;
	UIActivityIndicatorView	*spinner;
	UILabel *theLabel;
}

@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UILabel *theLabel;

@end