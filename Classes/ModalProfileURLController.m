//
//  ModalProfileURLController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/21/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "ModalProfileURLController.h"

@interface ModalProfileURLController ()

@end

@implementation ModalProfileURLController
@synthesize webView, theUrl;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.\self
    self.navigationController.navigationBar.hidden = false;
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle: @"Done"
                                                                               style: UIBarButtonItemStyleBordered
                                                                              target: self
                                                                              action: @selector(done)];
    
    
    NSURL *url = [NSURL URLWithString:self.theUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];    
}


- (void) done {
    [self dismissViewControllerAnimated:YES completion:^ {
        //
        
    }];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page is loading");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished loading");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
