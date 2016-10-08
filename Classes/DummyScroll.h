//
//  DummyScroll.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 16/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface DummyScroll : UIViewController <UITableViewDelegate, UITableViewDataSource,  UITextViewDelegate, HPGrowingTextViewDelegate> {
     HPGrowingTextView *textView;
}


@property (nonatomic, retain) UIView* textChatContainer;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UIScrollView* scroll;
@end
