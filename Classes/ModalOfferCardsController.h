//
//  ModalOfferCardsController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/22/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpWithController.h"
#import "OfferController.h"
#import "InterestedInController.h"


@interface ModalOfferCardsController : UIViewController <UIScrollViewDelegate> {
    
}

@property int theIndex;
@property bool helpMode;
@property (nonatomic, retain) NSString* theName;
@property (nonatomic, retain) IBOutlet UIScrollView* theScroll;
@property (nonatomic, retain) HelpWithController* helpWith;
@property (nonatomic, retain) InterestedInController* interestedIn;
@property (nonatomic, retain) OfferController* offer;



@end
