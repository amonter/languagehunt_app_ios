//
//  RetrieveBundleData.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 30/07/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//




#import "HuntProfileHelper.h"
#import "PeopleHuntRequests.h"


#import "ProfileV2Controller.h"
#import "StringEscapeUtil.h"
#import "LoadingAnimationView.h"


#import "LinkAccountsController.h"
#import "iphoneCrowdAppDelegate.h"

#import "ShareAuthenticateController.h"

#import <QuartzCore/QuartzCore.h>
#import "Twitter/Twitter.h"

#import <Accounts/Accounts.h>

@implementation HuntProfileHelper
@synthesize bundles, delegate;



+ (void) doAlertError {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Oops, Something went wrong while creating your account. Please try again!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


- (void) getFriends {
    NSLog(@"CALLING GET FRIEDS");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [FBRequestConnection startWithGraphPath:FACEBOOK_QUERY
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {                             
                              if (error) {
                                  NSLog(@"Error getFriends: %@", error);
                                  [HuntProfileHelper doAlertError];
                              } else {
                                  NSArray *friendData = [[result objectForKey:@"friends"] objectForKey:@"data"];
                                  NSLog(@"FRIEDNDATA %@", friendData);
                                  [[NSUserDefaults standardUserDefaults] setObject:friendData forKey:@"all_friends"];
                                  [delegate facebookActionDone];
                              }
                          }];
}

- (void) retrieveFriends {   
    if (![[FBSession activeSession] isOpen]) {        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {               
                [self getFriends];
            }];
        } else {
            iphoneCrowdAppDelegate  *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFriends) name:FBSessionStateChangedNotification object:nil];
            [appDelegate openSessionReadWithAllowLoginUI:YES];
        }
    } else {
        [self getFriends];
    }
}


+ (void) getProfileInterests:(NSMutableDictionary *)theDic {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likes"]){
        NSDictionary* newCopy = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"likes"]];
        [theDic setObject:newCopy forKey:@"likes"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"skills"]){
        NSDictionary* newCopy = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"skills"]];
        [theDic setObject:newCopy forKey:@"skills"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]){
        NSDictionary* newCopy = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]];
        [theDic setObject:newCopy forKey:@"languages"];
    }
}


+ (void) formatInterests:(NSMutableArray*) theArray {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"likes"]){
        NSArray* newCopy = [[[NSUserDefaults standardUserDefaults] objectForKey:@"likes"] objectForKey:@"data"];
        for (NSDictionary* dic in newCopy) {
            [theArray addObject:[dic objectForKey:@"name"]];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"skills"]){
        NSArray* skillsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"skills"] objectForKey:@"values"];
        for (NSDictionary* aSkills in skillsArray) {
            [theArray addObject:[[aSkills objectForKey:@"skill"] objectForKey:@"name"]];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]){
        NSDictionary* newCopy = [[NSUserDefaults standardUserDefaults] objectForKey:@"languages"];
        for (id key in [newCopy allKeys]) {
          NSLog(@"DESCRI %@", [newCopy objectForKey:key]);   
        }
    }

}


+ (void) checkProfileInterests {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"profile_interests"]){
       
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableDictionary* theDic = [[NSMutableDictionary alloc] init];
        
        [self getProfileInterests:theDic];        
        
        NSLog(@"CALLL CALLL ((())))))))))))))))) LIKES %@", theDic);
        
        if ([theDic count] > 0) {
            NSError *error = NULL;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONReadingAllowFragments error:&error];
            NSString *theResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *msgProt = [NSString stringWithFormat:@"7:%i:%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], theResult];
            [appDelegate.protocol sendMessage:msgProt];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"profile_interests"];
        }
    }

}


+ (void)setLoginVariables:(id) allData type:(NSString*) theType {
    
    NSString *theName = nil;
    NSString *theId = nil;
    NSString *theEmail = nil;
    NSString *theBio = nil;
    NSArray *friendData = nil;
    NSString *imageUrl = nil;
    
    
    if ([theType isEqualToString:@"facebook"]){
        //Data extract
        theName = [allData objectForKey:@"name"];
        theId = [allData objectForKey:@"id"];
        theEmail = [allData objectForKey:@"email"];
        theBio = [allData objectForKey:@"bio"];
        friendData = [[allData objectForKey:@"friends"] objectForKey:@"data"];
        imageUrl = [[[allData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        [[NSUserDefaults standardUserDefaults] setObject:[allData objectForKey:@"likes"] forKey:@"likes"];
        NSLog(@"FEACEBOOK URL %@", imageUrl);
    }
    
    if ([theType isEqualToString:@"linkedin"]){
        //Data extract
        theName = [NSString stringWithFormat:@"%@ %@", [allData objectForKey:@"firstName"], [allData objectForKey:@"lastName"]];
        theId = [allData objectForKey:@"id"];
        theEmail = [allData objectForKey:@"emailAddress"];
        theBio = [allData objectForKey:@"summary"];
        imageUrl = [allData objectForKey:@"url"];
        [[NSUserDefaults standardUserDefaults] setObject:[allData objectForKey:@"skills"] forKey:@"skills"];
        [[NSUserDefaults standardUserDefaults] setObject:[allData objectForKey:@"languages"] forKey:@"languages"];
    }
    
    
    NSData *tempName = [theName dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *nameConverted = [[[NSString alloc] initWithData:tempName encoding:NSASCIIStringEncoding] autorelease];
    NSMutableString *theUsername = [NSMutableString stringWithFormat:@"%@", nameConverted];
	[theUsername replaceOccurrencesOfString:@" "  withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [theUsername length])];
	theUsername = [NSString stringWithFormat:@"%@_%@@meetforeal.com", theUsername, theId];
    
	[[NSUserDefaults standardUserDefaults] setObject:nameConverted forKey:@"fullname"];
	[[NSUserDefaults standardUserDefaults] setObject:theUsername forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:theEmail forKey:@"user_email"];
    [[NSUserDefaults standardUserDefaults] setObject:friendData forKey:@"all_friends"];
    [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:@"my_image"];
    NSLog(@"ADDED BIO %@", theBio);
    if(theBio) [[NSUserDefaults standardUserDefaults] setObject:theBio forKey:@"bio"];
    //load profile image
    AvatarImageView *theImage = [[[AvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)] autorelease];
    [theImage checkIfImageExists:imageUrl theImageFrame:CGRectMake(0, 0, 90, 90)];
    
}







+ (void) facebookCall:(NSArray *)theMessages otherId:(int) theOtherId {
    NSMutableDictionary* theDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"Check this out", @"data",
                                    nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:[NSString stringWithFormat:@"Saw this and thought of you"]  title:nil parameters:theDic handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Error launching the dialog or sending the request.
            NSLog(@"Error sending request.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
                for (NSString *param in [[resultURL query] componentsSeparatedByString:@"&"]) {
                    NSArray *elts = [param componentsSeparatedByString:@"="];
                    if([elts count] < 2) continue;
                    [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
                }
                if (![params valueForKey:@"request"]) {
                    // User clicked the Cancel button
                    NSLog(@"User canceled request.");
                } else {
                    // User clicked the Send button
                    //NSString *requestID = [params valueForKey:@"request"];
                    if (theMessages != nil){
                        NSString *content = [NSString stringWithFormat:@"I just referred you to someone - automated message"];
                        iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
                        NSString *msgProt = [NSString stringWithFormat:@"40:%i:%@:%i", theOtherId, content, [theMessages count] + 1];
                        [theDelegate.protocol sendMessage:msgProt];
                        //NSDictionary* myChatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:@"adrian", @"name", content, @"content", @"mine", @"reference", nil] autorelease];
                        //[self addNewRow:myChatResponse];
                    }
                }
            }
        }
    }];    
}








#pragma mark - twitter show the stuff
+ (void) showTwitterPop:(UIViewController *) theController {

    Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if(tweeterClass != nil) {   // check for Twitter integration
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
        // check Twitter accessibility and at least one account is setup
       
        if([TWTweetComposeViewController canSendTweet]) {
            
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            // Create an account type that ensures Twitter accounts are retrieved.
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    // Get the list of Twitter accounts.
                    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                    if ([accountsArray count] > 0){
                        
                        //Show view twitter tag selection
                        int y_val2 = 260;
                        if ([accountsArray count] == 3){
                            y_val2 = 280;
                        }
                        if ([accountsArray count] == 4){
                            y_val2 = 320;
                        }
                        if ([accountsArray count] > 4){
                            y_val2 = 390;
                        }
                        
                        UIView *emailPop = [[[UIView alloc] initWithFrame:CGRectMake(20, 10, 280, y_val2)] autorelease];
                        emailPop.backgroundColor = [UIColor whiteColor];
                        emailPop.tag = 69;
                        emailPop.layer.cornerRadius = 4.0;
                        emailPop.layer.borderColor = [[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1] CGColor];
                        emailPop.layer.borderWidth = 1;
                        
                        UILabel *selectTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10,10, 260, 40)] autorelease];
                        selectTitle.backgroundColor = [UIColor whiteColor];
                        selectTitle.textColor = [UIColor blackColor];
                        selectTitle.numberOfLines = 0;
                        selectTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
                        selectTitle.textAlignment = UITextAlignmentCenter;
                        selectTitle.text = [NSString stringWithFormat:@"Link your Twitter account here:"];
                        [emailPop addSubview:selectTitle];
                        
                        /*UILabel *selectTitle2 = [[[UILabel alloc] initWithFrame:CGRectMake(10,60, 260, 30)] autorelease];
                        selectTitle2.backgroundColor = [UIColor whiteColor];
                        selectTitle2.textColor = [UIColor blackColor];
                        selectTitle2.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:13.0];
                        selectTitle2.numberOfLines = 0;
                        selectTitle2.textAlignment = UITextAlignmentCenter;
                        selectTitle2.text = [NSString stringWithFormat:@""];
                        [emailPop addSubview:selectTitle2];*/
                        
                        
                        int y_val = 85;
                        for (ACAccount *account in accountsArray) {
                            
                            UIButton *handlerSelect = [UIButton buttonWithType:UIButtonTypeCustom];                          
                            [handlerSelect setFrame:CGRectMake(40, y_val, 203, 46)];
                            [[NSUserDefaults standardUserDefaults] setObject:account.identifier forKey:[NSString stringWithFormat:@"@%@", account.username]];
                            [handlerSelect setTitle:[NSString stringWithFormat:@"@%@", account.username] forState:UIControlStateNormal];
                            
                            //Check for viewController type
                            if ([theController isKindOfClass:[ShareAuthenticateController class]]){
                                ShareAuthenticateController *theShare = (ShareAuthenticateController *)theController;
                                [handlerSelect addTarget:theShare action:@selector(setUpTwitter:) forControlEvents:UIControlEventTouchUpInside];
                            }
                            
                            if ([theController isKindOfClass:[LinkAccountsController class]]){
                                LinkAccountsController *theLink = (LinkAccountsController *)theController;
                                [handlerSelect addTarget:theLink action:@selector(setUpTwitter:) forControlEvents:UIControlEventTouchUpInside];
                            }
                            
                           
                            handlerSelect.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
                            [handlerSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [handlerSelect setBackgroundImage:[UIImage imageNamed:@"twitterPopUp.png"] forState:UIControlStateNormal];
                            [emailPop addSubview:handlerSelect];
                            y_val+=55;
                        }
                        
                        [[theController.view viewWithTag:612] removeFromSuperview];
                        [theController.view addSubview:emailPop];
                        
                    }
                }
            }];
            
            
        } else {
            [[theController.view viewWithTag:612] removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Whoops! You have no Twitter account set up in your iphone." delegate:self
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
#endif
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Whoops! You are still using iOS 4.x. We don't support it for this action." delegate:self
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


+ (void) addLoadingView:(UIView*) theView {
    LoadingAnimationView *loadingViewObj = [[[LoadingAnimationView alloc] initWithFrame: CGRectMake(90, 110, 140, 80)] autorelease];
    loadingViewObj.tag = 612;
    [theView addSubview:loadingViewObj];
    [theView bringSubviewToFront:loadingViewObj];
}







+ (void) removeLoadingView:(UIView*) aView {
    [[aView viewWithTag:612] removeFromSuperview];

}







+ (void) addHasBeenSentMessage:(UIView*) theView {
    
    UIView *msgView = [[[UIView alloc] initWithFrame:CGRectMake(60, 165, 200, 90)] autorelease];
    msgView.backgroundColor = [UIColor grayColor];
    msgView.tag = 919;
    msgView.layer.shadowRadius = 3.0f;
    msgView.layer.shadowOpacity = 0.2;
    msgView.layer.shadowOffset = CGSizeMake(0, 0);  
    msgView.layer.cornerRadius = 3.0;
    msgView.alpha = 0.9f;
    
    UILabel *targetTitle = [[[UILabel alloc] initWithFrame:CGRectMake(20,25, 160 ,40)] autorelease];
    targetTitle.backgroundColor = [UIColor clearColor];
    targetTitle.textColor = [UIColor whiteColor];
    targetTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:21.0];
    targetTitle.textAlignment = UITextAlignmentCenter;
    targetTitle.numberOfLines = 0;
    targetTitle.lineBreakMode = UILineBreakModeWordWrap;
    targetTitle.text = @"Message Sent!";
    [msgView addSubview:targetTitle];
    
    [UIView animateWithDuration:4 animations:^(void) {
        msgView.alpha = 0.0f;
        [msgView removeFromSuperview];        
    }];
    
    [theView addSubview:msgView];
}




+ (NSString *) getNumbersFromString:(NSString *) originalString {

   
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }

    return strippedString;
}


+ (void) dismmissLeftAlertViews {

    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        NSArray *subviews = window.subviews;
        if ([subviews count] > 0) {
            for (UIView *theView in subviews) {
                if ([theView isKindOfClass:[UIAlertView class]]){
                    [((UIAlertView *)theView) dismissWithClickedButtonIndex:0 animated:YES];
                }
            }
        }
    }
}


+ (void) deleteSession:(UIViewController *) controller {
    
    [controller.navigationController setNavigationBarHidden:NO animated:NO];
    iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *controllers = appDelegate.navigationController.viewControllers;
    bool controllerExists = false;
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[ProfileV2Controller class]]) {
            controllerExists = true;
            [appDelegate.navigationController popToViewController:controller animated:YES];
        }
    }
    
    if (!controllerExists) {
        ProfileV2Controller *events = [[ProfileV2Controller alloc] initWithNibName:@"ProfileV2Controller" bundle:nil];
        [controller.navigationController pushViewController:events animated:NO];
        [events release];
    }
}

+ (void) serverResponse:(NSString *)response theDelegate:(UIViewController *) theDel {
    
    NSArray *responses = [response componentsSeparatedByString:@":"];
    int code = [[responses objectAtIndex:0] intValue];
    switch (code) {
        case 20:
            NSLog(@"%@",[responses objectAtIndex:1]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[responses objectAtIndex:1] delegate:theDel
												  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag = 20;
			[alert show];
            [alert release];           
            break;
        case 30:
            NSLog(@"%@",[responses objectAtIndex:1]);
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[responses objectAtIndex:1] delegate:theDel
                                                   cancelButtonTitle:@"No, sorry" otherButtonTitles:@"Sure", nil];
            alert2.tag = 30;
			[alert2 show];
            [alert2 release];
            break;
        case 31:
            NSLog(@"%@",[responses objectAtIndex:1]);
            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[responses objectAtIndex:1] delegate:theDel
                                                   cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert3.tag = 31;
			[alert3 show];
            [alert3 release];
            break;
        case 32:
            NSLog(@"%@",[responses objectAtIndex:1]);
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@""
                                                             message:[responses objectAtIndex:1] delegate:theDel
                                                   cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert4.tag = 32;
			[alert4 show];
            [alert4 release];
            break;
        default:
            break;
    }
    
    NSLog(@"Server responded %@", response);
}





+ (void)postToTwitter:(NSString *) message {

    // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];

    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSString *twitterHandle = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_handle"];
            ACAccount *twitterAccount = [accountStore accountWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:twitterHandle]];
            TWRequest *postRequest = nil;
            
            postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:message forKey:@"status"] requestMethod:TWRequestMethodPOST];
            
            // Set the account used to post the tweet.
            [postRequest setAccount:twitterAccount];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            if ([urlResponse statusCode] == 200) {
                                NSLog(@"TWEET sucessfull");
                            } else {
                                 NSLog(@"TWEET failed %@ data %@", error, [NSString stringWithUTF8String:[responseData bytes]]);
                            }
                        });
                    }];
            });
        }
    }];
}







- (void)dealloc {
    [bundles release];
    [super dealloc];
}

@end
