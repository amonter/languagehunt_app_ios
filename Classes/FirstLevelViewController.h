//
//  FirstLevelViewController.h
//  Ousiastikos2
//
//  Created by Adrian Avendano on 27/11/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolCommunication.h"


@interface UINavigationController (TheNavController)
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
@end


@interface FirstLevelViewController : UIViewController {
	
	UIButton *theButton;
    IBOutlet UIImageView *splashReplica;
   
    
}

@property (nonatomic, retain) UIButton *theButton;
@property (nonatomic, retain) IBOutlet UIImageView *splashReplica;




@end
