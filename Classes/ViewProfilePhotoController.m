//
//  ViewProfilePhotoController.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 23/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)


#import "ViewProfilePhotoController.h"
#import "UploadPhotoFileRequest.h"


#import "iphoneCrowdAppDelegate.h"

#import "LoadingAnimationView.h"




@implementation ViewProfilePhotoController
@synthesize imageView, imagePicker, uploadRequest, isOwner, theBundleArray;
@synthesize getIdentity, instructions, greenBacking, labelPersona;
@synthesize photoBacking, photoLabel, photoIntro;

- (void) viewDidLoad {    
   
   
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.tag = 257;
    [photoButton setFrame:CGRectMake(30, 88, 261, 57)];
    [photoButton addTarget:self action:@selector(changeProfilePhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"add_your_photo.png"] forState:UIControlStateNormal];
    self.navigationItem.hidesBackButton = YES;
    [self.view addSubview:photoButton];
    
	getIdentity.hidden = YES;
	greenBacking.hidden = YES;
	instructions.hidden = YES;
    labelPersona.hidden = YES;
	
	
	
	if (self.imageView == nil) {
		UIImageView *theImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 22, 80, 80)];
		self.imageView = theImage;
		[theImage release];
	}
	
	
	NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/profilePhoto.jpg"];
	
	NSLog(@"A PATH %@", thePath);
	//UIImage *theREal = [UIImage imageWithContentsOfFile:thePath];
	
	/*
     if (theREal.size.width < 1.0) {
     UIImage *newImage = [UIImage imageNamed:@"newphoto.png"];
     [UIImageJPEGRepresentation(newImage, 1.0) writeToFile:thePath atomically:YES];
     theREal = [UIImage imageWithContentsOfFile:thePath];
     }
     
     
     imageView.image = theREal;
     UIBarButtonItem *totalButtonObj = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStyleDone
     target:self
     action:@selector(changeProfilePhoto)];
     
     self.navigationItem.rightBarButtonItem = totalButtonObj;
	 */
	[self.view addSubview:self.imageView];
	//[self startWiggle];
	//[totalButtonObj release];
	
	[super viewDidLoad];
}







- (void) alertNow {
    //photo labels
    photoBacking.hidden = TRUE;
    photoIntro.hidden = TRUE;
    photoLabel.hidden = TRUE;
    
    //Persona Label
	getIdentity.hidden = FALSE;
	greenBacking.hidden = FALSE;
	instructions.hidden = FALSE;
    labelPersona.hidden = FALSE;
}


- (IBAction) changeProfilePhoto {
	
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Go existing",nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}


#pragma mark -
- (void)getCameraPicture:(id)sender {
	
    //photo labels
    photoBacking.hidden = TRUE;
    photoIntro.hidden = TRUE;
    photoLabel.hidden = TRUE;
    
    LoadingAnimationView *loadingViewObj = [[[LoadingAnimationView alloc] initWithFrame: CGRectMake(90, 130, 140, 80)] autorelease];
    loadingViewObj.tag = 69;
    [self.view addSubview:loadingViewObj];
    
	UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.allowsEditing = YES;
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{
        //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
    
}


- (void)selectExistingPicture {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing photo library"
                              message:@"Device does not support a photo library"
                              delegate:nil
                              cancelButtonTitle:@"Drat!"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    [[self.view viewWithTag:69] removeFromSuperview];
    
	getIdentity.hidden = FALSE;
	greenBacking.hidden = FALSE;
	instructions.hidden = FALSE;
    labelPersona.hidden = FALSE;
    
    //photo labels
    photoBacking.hidden = TRUE;
    photoIntro.hidden = TRUE;
    photoLabel.hidden = TRUE;
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"reload_key_0"];
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"reload_key_1"];
	[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"uploading_photo"];
	//UIImage *theImage = [info objectForKey:UIImagePickerControllerEditedImage];
	
	//imageView.image = theImage;
	
	//UploadPhotoFileRequest *photoUpload = [[[UploadPhotoFileRequest alloc] init] autorelease];
	//self.uploadRequest.theController = self.navigationController;
	//self.uploadRequest.isOwner = self.isOwner;
	//[self.uploadRequest postUpload:jpgPath];
    
    //[self startWiggle];
    [picker dismissViewControllerAnimated:YES completion:^{
        //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        //[self pushQuestionBundle];
    }];
	
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	NSLog(@"CAncel cancel");
    [[self.view viewWithTag:69] removeFromSuperview];
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"reload_key_0"];
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"reload_key_1"];
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"uploading_photo"];
    [picker dismissModalViewControllerAnimated:YES];
}


-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
	
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

//Added by Ken (15/06/2011)
//This method starts the takePhoto arrow to wiggle for 2.8 seconds. After this time
//it calls the stopWiggle method
- (void)startWiggle {
    
    UIButton *photoWiggleText = (UIButton *)[self.view viewWithTag:257];
    
    photoWiggleText.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-1));
    
    [UIView animateWithDuration:0.20 //determines the speed of the wiggle. The higher the value the slower the speed.
                          delay:0.0  //The delay before starting to wiggle.
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         photoWiggleText.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1));
                         
                         
                     }
                     completion:NULL
     ];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(stopWiggle) userInfo:nil repeats:NO]; //stop wiggle after 2.8 sec.
}

//Added by Ken (15/06/2011)
//This method stopps the takePhoto arrow from wiggling. It then pauses for 5 seconds before it calls the
//startWiggle method to kick the wiggle off again ;)
- (void)stopWiggle {
    UIButton *photoWiggleText = (UIButton *)[self.view viewWithTag:257];
    
    [UIView animateWithDuration:0.40
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut)
                     animations:^ {
                         photoWiggleText.transform = CGAffineTransformIdentity;
                         
                     }
                     completion:NULL
     ];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(startWiggle) userInfo:nil repeats:NO]; //start wiggle after 5 sec
}


#pragma mark  - actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		if (![UIImagePickerController isSourceTypeAvailable:
			  UIImagePickerControllerSourceTypeCamera]) {
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Error taking photo"
								  message:@"Device does not have a camera!"
								  delegate:nil
								  cancelButtonTitle:@"Drat!"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		} else {
			[self getCameraPicture:(id)UIImagePickerControllerSourceTypeCamera];
		}
	} else if (buttonIndex == 1) {
		
		[self selectExistingPicture];      
	}
}






- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewWillAppear:(BOOL)animated {
	//[super viewWillAppear:YES];    
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}

- (void)dealloc {
    [photoIntro release];  
    [labelPersona release];
	[greenBacking release];
	[instructions release];
	[getIdentity release];
	[theBundleArray release];
	[uploadRequest release];
	[imagePicker release];
	[imageView release];	
    [super dealloc];
}



@end
