//
//  ProcessingProtocol.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 18/03/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "ProcessingProtocol.h"
#import "ConnectionListController.h"
#import "HuntFeedController.h"
#import "iphoneCrowdAppDelegate.h"
#import "HuntProfileHelper.h"
#import "IncomingConnection.h"
#import "StringEscapeUtil.h"
#import "IntroSwipeController.h"
#import "AsynchMessageController.h"
#import "IndividualFeelerController.h"
#import "MainCardController.h"
#import "SignupIntroController.h"

@implementation ProcessingProtocol
@synthesize connectionController;


- (void)addMatchingView:(UIViewController *)theFeed theProfile:(NSDictionary *)theProfile {
    UIView *matchView = [theFeed.view viewWithTag:888987];
    if (matchView == nil){        
        if ([theFeed isKindOfClass:[HuntFeedController class]])[((HuntFeedController*)theFeed).searchBar resignFirstResponder];
        [[IncomingConnection alloc] initWithFrame:CGRectMake(0, 0, 0, 0) superController:theFeed.view data:theProfile];
    }
}

- (void) serverResponse:(NSString *)response {
    
    NSLog(@"RESPONSE %@", response);
    iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *visible = appDelegate.navigationController.visibleViewController;
   
        NSArray *responses = [response componentsSeparatedByString:@":"];
        int code = [[responses objectAtIndex:0] intValue];
        NSDictionary *theProfile = nil;
        NSString *content = nil;
        NSError *error = nil;
        NSArray *controllers;
   
        switch (code) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"heartbeat" object:nil];
                break;
            case 1:
                NSLog(@"case one");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_added" object:nil];
                [HuntProfileHelper checkProfileInterests];
                break;
            case 50:
                //if he has shared his location and I haven't display chat
                if ([visible isKindOfClass:[AsynchMessageController class]]) {
                    content = [[responses objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [((AsynchMessageController *) visible) incomingMapLocation:responses];
                }
                if ([visible isKindOfClass:[ConnectionListController class]]) {                    
                     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ just share her/his location", [responses objectAtIndex:1]] forKey:[NSString stringWithFormat:@"message_%i", [[responses objectAtIndex:3] intValue]]];
                    //refresh the cell                    
                    NSDictionary *liveUser = [NSDictionary dictionaryWithObjectsAndKeys:[responses objectAtIndex:3], @"id", nil];
                    [((ConnectionListController *) visible) userLive:liveUser];
                }               
        
                [[NSUserDefaults standardUserDefaults] setObject:[responses objectAtIndex:2] forKey:[responses objectAtIndex:3]];
               
                break;
            case 40:
                content = [[responses objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                content = [StringEscapeUtil urlDecoder:content];
                
                if ([visible isKindOfClass:[MainCardController class]]) {
                    int otherProfileId = ((MainCardController *) visible).otherProfileId;
                     NSDictionary *liveUser = [NSDictionary dictionaryWithObjectsAndKeys:[responses objectAtIndex:1], @"id", content, @"message", nil];
                    if (otherProfileId == [[responses objectAtIndex:1] intValue]){                       
                        [((MainCardController *) visible) incomingMessage:responses];
                    }
                    if ([responses count] > 3) [((MainCardController *) visible) userLive:liveUser];
                }
                if ([visible isKindOfClass:[IntroSwipeController class]]) {
                    NSDictionary *liveUser = [NSDictionary dictionaryWithObjectsAndKeys:[responses objectAtIndex:1], @"id", content, @"message", nil];
                    [((IntroSwipeController *) visible) liveMessage];
                }
                break;
            case 20:
                NSLog(@"%@",[responses objectAtIndex:1]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[responses objectAtIndex:1] delegate:self
                                                      cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                alert.tag = 20;
                [alert show];
                [alert release];
                break;
            case 55:
                response = [response substringWithRange:NSMakeRange(3, [response length] - 3)];
                id resultArray = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                if ([visible isKindOfClass:[IntroSwipeController class]]) {
                    [((IntroSwipeController *) visible) populateHubLocations:resultArray];
                }
                break;
            case 80://insert or refresh live connections
                response = [response substringWithRange:NSMakeRange(3, [response length] - 3)];
                NSArray *arrayRes = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                /*if ([visible isKindOfClass:[ConnectionListController class]]) {
                    ConnectionListController *connections = (ConnectionListController *)visible;
                    [connections addLiveUsers:arrayRes];
                 }*/
                if ([visible isKindOfClass:[HuntFeedController class]]) {
                    HuntFeedController *theFeed = (HuntFeedController *)visible;
                    if ([arrayRes count] > 0){
                        NSDictionary *theProfile = [arrayRes objectAtIndex:0];
                        [self addMatchingView:theFeed theProfile:theProfile];
                    }
                }
                if ([visible isKindOfClass:[IndividualFeelerController class]]) {
                    IndividualFeelerController *indControl = (IndividualFeelerController *)visible;
                    if ([arrayRes count] > 0){
                        NSDictionary *theProfile = [arrayRes objectAtIndex:0];
                        [self addMatchingView:indControl theProfile:theProfile];
                    }
                }
                break;
            case 101:
                controllers = appDelegate.navigationController.viewControllers;
                for (UIViewController *theController in controllers) {
                    if ([visible isKindOfClass:[MainCardController class]]) {
                        [((MainCardController *) visible) chatConfirmed:[[responses objectAtIndex:1] intValue]];
                        break;
                    }
                }              
                break;
            case 110:
                response = [response substringWithRange:NSMakeRange(4, [response length] - 4)];
                theProfile = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                NSLog(@"helo the profile %@", theProfile);
                if ([visible isKindOfClass:[ConnectionListController class]]) {                   
                    ConnectionListController *connections2 = (ConnectionListController *)visible;
                    [connections2 userLive:theProfile];
                }              
                if ([visible isKindOfClass:[HuntFeedController class]]) {
                    HuntFeedController *theFeed = (HuntFeedController *)visible;
                    [self addMatchingView:theFeed theProfile:theProfile];
                }
                if ([visible isKindOfClass:[IndividualFeelerController class]]) {
                    IndividualFeelerController *theFeed = (IndividualFeelerController *)visible;
                    [self addMatchingView:theFeed theProfile:theProfile];
                }
                
                break;
             case 88:
                response = [response substringWithRange:NSMakeRange(3, [response length] - 3)];
                NSDictionary *theDic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                NSLog(@"MATCH RESPONSES %@", response);
                
                if ([visible isKindOfClass:[IntroSwipeController class]]) {
                    IntroSwipeController *theFeed = (IntroSwipeController *)visible;
                    theFeed.profileMode = false;
                    [theFeed showCards:theDic];
                }
             case 113:
                response = [response substringWithRange:NSMakeRange(4, [response length] - 4)];
                NSArray *allMessages = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                NSLog(@"RESPONSE 113----------- %@", response);
                if ([visible isKindOfClass:[MainCardController class]]) {
                    MainCardController *theFeed = (MainCardController *)visible;
                    [theFeed populateMessages:allMessages];
                }
                
            default:
                break;
                
        }
    
}




- (void)dealloc {
    [connectionController release];
    [super dealloc];
}

@end
