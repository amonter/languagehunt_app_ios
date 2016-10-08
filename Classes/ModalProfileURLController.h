//
//  ModalProfileURLController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/21/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalProfileURLController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView* webView;
}

@property (nonatomic, retain) NSString* theUrl;
@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end
