//
//  PlanningView.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 23/04/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//




#import "PlanningView.h"
#import "PeopleHuntRequests.h"
#import "HuntProfileHelper.h"
#import "iphoneCrowdAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kOFFSET_FOR_KEYBOARD 40 

@implementation PlanningView
@synthesize keyDown, textViewActivated;

- (void)setPlacemarkLabel {
    
    //addViewbehindLocation
    UIView *whiteBehindLocation = [[[UIView alloc] initWithFrame:CGRectMake(7, 150, 296, 36)] autorelease];
    whiteBehindLocation.backgroundColor = [UIColor whiteColor];
    whiteBehindLocation.layer.borderColor = [UIColor lightGrayColor].CGColor;
    whiteBehindLocation.layer.borderWidth = 1.0;
    whiteBehindLocation.layer.cornerRadius = 6.0;
    whiteBehindLocation.layer.masksToBounds = YES;
    [self addSubview:whiteBehindLocation];
    
    UILabel *currentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15,159,280,20)] autorelease];
    currentLabel.tag = 4411456;
    currentLabel.backgroundColor = [UIColor whiteColor];
    currentLabel.textColor = [UIColor blackColor];
    currentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    currentLabel.textAlignment = NSTextAlignmentLeft;
    currentLabel.numberOfLines = 0;
    currentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    currentLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"placemark"];
    [self addSubview:currentLabel];
    
    //add dont show current location
    UIButton *dontShow = [UIButton buttonWithType:UIButtonTypeCustom];
    [dontShow setFrame:CGRectMake(268, 145, 35, 45)];
    [dontShow addTarget:self action:@selector(dontShowLocation:) forControlEvents:UIControlEventTouchUpInside];
    [dontShow setBackgroundImage:[UIImage imageNamed:@"hideLocation.png"]  forState:UIControlStateNormal];
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"show_location"] boolValue]){
        currentLabel.hidden = true;
        [dontShow setBackgroundImage:[UIImage imageNamed:@"showLocation.png"]  forState:UIControlStateNormal];
        dontShow.selected = YES;
    }
    [self addSubview:dontShow];
}

- (id)initWithFrame:(CGRect)frame superController:(UIView *) superView navigationController:(UINavigationController*) theNavigationController {
    self = [super initWithFrame:frame];
    if (self) {
        
        //add background image
        UIView *behindView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, theNavigationController.view.frame.size.height)] autorelease];
        behindView.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:32/255.0 alpha:0.9];
        behindView.tag = 123456;
        [superView  addSubview:behindView];
        
        
        self.frame =  CGRectMake(5,25, 310, 357);
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"editProfilePiece.png"]];
        //
        keyDown = true;
      
        self.tag = 878724;
        [theNavigationController.view addSubview:self];
        [self addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
        
        //addViewbehindTextView
        UIView *whiteBehindText = [[[UIView alloc] initWithFrame:CGRectMake(7, 55, 296, 87)] autorelease];
        whiteBehindText.backgroundColor = [UIColor whiteColor];
        whiteBehindText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        whiteBehindText.layer.borderWidth = 1.0;
        whiteBehindText.layer.cornerRadius = 6.0;
        whiteBehindText.layer.masksToBounds = YES;
        [self addSubview:whiteBehindText];
        
        //add profile bio textView
        UITextView *theBio = [[[UITextView alloc] initWithFrame:CGRectMake(7,55, 296, 80)] autorelease];
        theBio.tag = 5513910;
        theBio.delegate = self;
        theBio.backgroundColor = [UIColor clearColor];
        theBio.textColor = [UIColor blackColor];
        theBio.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        theBio.textAlignment = UITextAlignmentLeft;
        theBio.returnKeyType = UIReturnKeyDefault;
        NSLog(@"BIO BIO %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"]);
        theBio.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
        [self addSubview:theBio];
        //check and/or add current location label
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"placemark"]){
            //[self setPlacemarkLabel];
            
        } else {//add Button to enable Location
                        UIButton *enableLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            enableLocation.tag = 43773361;
            [enableLocation setFrame:CGRectMake(7,150,296,36)];
            [enableLocation addTarget:self action:@selector(addYourLocation) forControlEvents:UIControlEventTouchUpInside];
            [enableLocation setTitle:@"add your location" forState:UIControlStateNormal];
            //[self addSubview:enableLocation];
        }
        
        //adding behind the planning
        UIView *whiteBehindPlanning = [[[UIView alloc] initWithFrame:CGRectMake(7, 195, 296, 36)] autorelease];
        whiteBehindPlanning.backgroundColor = [UIColor whiteColor];
        whiteBehindPlanning.layer.borderColor = [UIColor lightGrayColor].CGColor;
        whiteBehindPlanning.layer.borderWidth = 1.0;
        whiteBehindPlanning.layer.cornerRadius = 6.0;
        whiteBehindPlanning.layer.masksToBounds = YES;
        //[self addSubview:whiteBehindPlanning];
        
        //adding the planning to go now
        UITextField *planning = [[UITextField alloc] initWithFrame:CGRectMake(15,204, 280, 22)];
        planning.tag = 988316;
        planning.delegate = self;
        planning.textColor = [UIColor blackColor];
		planning.backgroundColor = [UIColor whiteColor];
		planning.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		planning.adjustsFontSizeToFitWidth = YES;
        planning.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
		planning.keyboardType = UIKeyboardTypeDefault;
		planning.returnKeyType = UIReturnKeyDone;
		planning.textAlignment =  UITextAlignmentLeft;
        planning.placeholder = @"Future location plans";
        planning.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"planning"]; 
        //[self addSubview:planning];
       
        //cancel Button
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setFrame:CGRectMake(10, 10, 75, 44)];
        [cancel addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [cancel setBackgroundImage:[UIImage imageNamed:@"cancel_button.png"] forState:UIControlStateNormal];
        [self addSubview:cancel];
       
        //add save button
        UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
        [save setFrame:CGRectMake(225, 10, 75, 44)];
        [save addTarget:self action:@selector(saveAll) forControlEvents:UIControlEventTouchUpInside];
        [save setBackgroundImage:[UIImage imageNamed:@"done_button.png"] forState:UIControlStateNormal];
        [self addSubview:save];
        
    }
    return self;
}

- (void) addYourLocation {
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"placemark_ready" object:theDelegate queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [self viewWithTag:43773361].hidden = true;
        [self setPlacemarkLabel];        
    }];
    //location_fail
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationWarningPop)
                                                 name:@"location_fail" object:theDelegate];
	[theDelegate startGeolocation];

}

- (void) locationWarningPop {
    NSString *message = nil;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0.1" options:NSNumericSearch] != NSOrderedAscending) {
        message = [NSString stringWithFormat:@"Whoops! \nTurn on Location Services to share your location: \n \nSettings>Location Services"];
    }else{
        message = [NSString stringWithFormat:@"Whoops! \nTurn on Location Services to share your location: \n \nSettings>Privacy>Location Services"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message delegate:self
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

- (void) closeView {
    UIView *theBehindView = (UIView *)[self.superview viewWithTag:123456];
    [theBehindView removeFromSuperview];
    [self removeFromSuperview];
}

- (void) saveAll {
    [HuntProfileHelper addLoadingView:self];
    NSString *planning = ((UITextField*)[self viewWithTag:988316]).text;
    NSString *theBio = ((UITextView*)[self viewWithTag:5513910]).text;
    UIView *theBehindView = (UIView *)[self.superview viewWithTag:123456];
    [theBehindView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"planning"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bio"]; 

    
    if (theBio) [[NSUserDefaults standardUserDefaults] setObject:theBio forKey:@"bio"];
    if (planning) [[NSUserDefaults standardUserDefaults] setObject:planning forKey:@"planning"];
    PeopleHuntRequests *req = [[[PeopleHuntRequests alloc] init] autorelease];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"load_end" object:req queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"edit_bio" object:self];
        [self removeFromSuperview];        
    }];
    [req updateProfileInfo];        
}

- (void) dontShowLocation:(id) sender {
    
    UILabel *theLocation = (UILabel *)[self viewWithTag:4411456];
    if (((UIButton *)sender).selected) {//Do not show
        theLocation.hidden = false;
        [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"hideLocation.png"]  forState:UIControlStateNormal];
        ((UIButton *)sender).selected = NO;    
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"show_location"];
    } else {//show the current location
        theLocation.hidden = true;
        [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"showLocation.png"] forState:UIControlStateNormal];
        ((UIButton *)sender).selected = YES;       
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"show_location"];
    }
}

#pragma mark - move view with Scroll
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textViewActivated = true;
    keyDown = false;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    keyDown = true;
    UITextField *theField = (UITextField*)[self viewWithTag:988316];
    [theField resignFirstResponder];
    //[self setViewMovedUp:NO];
    return NO;
}
- (void) dismissKeyboard {
    if (!keyDown){
        keyDown = true;
        UITextField *theField = (UITextField*)[self viewWithTag:988316];
        [theField resignFirstResponder];
        UITextView *theTextView = (UITextView*)[self viewWithTag:5513910];
        [theTextView resignFirstResponder];
        //if (!textViewActivated)[self setViewMovedUp:NO];
        //else textViewActivated = false;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender {
    //move the main view, so that the keyboard does not hide it.
    if  (self.frame.origin.y >= 0) {
        keyDown = false;
        //[self setViewMovedUp:YES];
    }    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.frame;
    if (movedUp) {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.frame = rect;
    
    [UIView commitAnimations];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
