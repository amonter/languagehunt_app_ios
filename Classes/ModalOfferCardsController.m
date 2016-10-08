//
//  ModalOfferCardsController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 4/22/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "ModalOfferCardsController.h"
#import "InterestedInController.h"

@interface ModalOfferCardsController ()

@end

@implementation ModalOfferCardsController
@synthesize theScroll, helpWith, offer, theName, theIndex, interestedIn, helpMode;



- (void)doOfferLoad
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"offer_load" object:self.offer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
    }];
    //second_load
    [self.offer retrieveOffers];
}

- (void)displayOfferView
{
    [theScroll addSubview:self.offer.view];
    [theScroll setContentSize:CGSizeMake(596, 400)];
    [theScroll setContentOffset:CGPointMake(298, 0) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle: @"Done"
                                                                               style: UIBarButtonItemStyleBordered
                                                                              target: self
                                                                              action: @selector(done)];
    
    self.theScroll.delegate = self;
    self.theScroll.clipsToBounds = NO;
    self.helpWith = [[HelpWithController alloc] initWithNibName:@"HelpWithController" bundle:nil];
    self.helpWith.hideDone = true;
    self.interestedIn = [[InterestedInController alloc] initWithNibName:@"InterestedInController" bundle:nil];
    self.offer = [[OfferController alloc] initWithNibName:@"OfferController" bundle:nil];
    self.offer.view.tag = theIndex;
    self.offer.theName = self.theName;
    
    CGRect helpWithFrame = self.helpWith.view.frame;
    helpWithFrame.origin.x = 11;
    helpWithFrame.origin.y = 71;
    helpWithFrame.size.width = 298;
    helpWithFrame.size.height = 530;
    self.helpWith.view.frame = helpWithFrame;
    
    CGRect interestedInFrame = self.interestedIn.view.frame;
    interestedInFrame.origin.x = 11;
    interestedInFrame.origin.y = 71;
    interestedInFrame.size.width = 298;
    interestedInFrame.size.height = 530;
    self.interestedIn.view.frame = interestedInFrame;
    
    
    CGRect offerFrame = self.offer.view.frame;
    //interestedFrame.origin.x = 607;297.5
    //offerFrame.origin.x = 309;
    offerFrame.origin.x = 309;
    offerFrame.origin.y = 84;
    offerFrame.size.width = 298;
    offerFrame.size.height = 530;
    self.offer.view.frame = offerFrame;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"first_load" object:self.helpWith queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self doOfferLoad];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"first_load" object:self.interestedIn queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self doOfferLoad];
    }];
    
    //second_load
    [[NSNotificationCenter defaultCenter] addObserverForName:@"done_language" object:self.helpWith queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self displayOfferView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"done_language" object:self.interestedIn queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [self displayOfferView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"done_offer" object:self.offer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        
        NSMutableDictionary* theHelpDic = self.helpWith.selectedDataDic;
        NSMutableDictionary* theOfferDic = self.offer.selectedDataDic;
        NSMutableArray* helpArray = [[NSMutableArray alloc] init];
        NSMutableArray* offerArray = [[NSMutableArray alloc] init];
        NSArray* keys = [theHelpDic allKeys];
        for(NSString* key in keys) {
            [helpArray addObject:[theHelpDic objectForKey:key]];
        }
        NSArray* keysOffer = [theOfferDic allKeys];
        for(NSString* key in keysOffer) {
            [offerArray addObject:[theOfferDic objectForKey:key]];
        }
        
        NSDictionary* otherData = [[data userInfo] mutableCopy];
        //NSLog(@"HELP %@ and Offer %@", [helpArray componentsJoinedByString:@","]  , [offerArray componentsJoinedByString:@","]);
        [otherData setValue:[NSString stringWithFormat:@"%@ and %@", [helpArray componentsJoinedByString:@","], [offerArray componentsJoinedByString:@","]] forKey:@"offer"];
        
        [self dismissViewControllerAnimated:YES completion:^ {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"show_message" object:self userInfo:otherData];
        }];
    }];
    
    if (!helpMode){
       
        [self.helpWith retrieveHelpData];
        [theScroll addSubview:self.helpWith.view];
    } else {
        [self.interestedIn loadInterestedInData];
        [theScroll addSubview:self.interestedIn.view];
    }
    
    //for 6 1788 /for 4 1192/ for 2 596
    [theScroll setContentSize:CGSizeMake(298, 400)];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"SCROLL %f", scrollView.contentOffset.x);
}

- (void) done {

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
