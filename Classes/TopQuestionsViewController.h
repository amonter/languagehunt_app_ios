//
//  TopQuestionsViewController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 13/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalQuestionsViewController.h"
#import "MapViewQuestion.h"
#import "LocationManagerObject.h"


@interface TopQuestionsViewController : UIViewController {

	UIBarButtonItem *flipButton;
	ModalQuestionsViewController *modalView;
	MapViewQuestion *mapView;
	NSArray *questions;
	LocationManagerObject *location;
}


@property (nonatomic, retain) NSArray *questions;
@property (nonatomic, retain) LocationManagerObject *location;
@property (nonatomic, retain) UIBarButtonItem *flipButton;
@property (nonatomic, retain) ModalQuestionsViewController *modalView;
@property (nonatomic, retain) MapViewQuestion *mapView;

- (void) flipViews;
- (void) viewSelectedModalQuestion:(NSNotification *) theResult;
- (void) viewSelectedMapQuestion: (NSNotification *) theResult;
- (void) refreshContent;

@end
