//
//  FeedTableBase.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 24/10/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableBase : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *tableView;
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    BOOL isNavOpen;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    UIView *underNavView;
    UIButton *navigationButton;
    
    
}

@property (nonatomic, retain) UIButton *navigationButton;
@property (nonatomic, retain) UIView *underNavView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void) updateData;
- (void) stopLoading;
- (void)setupHomeTab;
@end
