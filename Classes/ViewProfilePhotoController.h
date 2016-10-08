//
//  ViewProfilePhotoController.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 23/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadPhotoFileRequest.h"


@interface ViewProfilePhotoController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>   {
	
	UIImageView *imageView;
	UIImagePickerController *imagePicker;
	UploadPhotoFileRequest *uploadRequest;
	bool isOwner;
	NSMutableArray *theBundleArray;
	IBOutlet UIImageView *greenBacking;
	IBOutlet UIButton *getIdentity;
	IBOutlet UILabel *instructions;
    IBOutlet UILabel *labelPersona;
    
    //take photo labels
    IBOutlet UIButton *photoLabel;
    IBOutlet UIImageView *photoBacking;
    IBOutlet UIButton *photoIntro;
}

@property bool isOwner;
@property (nonatomic, retain) UIButton *photoLabel;
@property (nonatomic, retain) UIImageView *photoBacking;
@property (nonatomic, retain) UIButton *photoIntro;
@property (nonatomic, retain) UILabel *instructions;
@property (nonatomic, retain) UILabel *labelPersona;
@property (nonatomic, retain) UIButton *getIdentity;
@property (nonatomic, retain) NSMutableArray *theBundleArray;
@property (nonatomic, retain) UploadPhotoFileRequest *uploadRequest;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *greenBacking;


- (IBAction)getCameraPicture:(id)sender;
- (IBAction)selectExistingPicture;


- (IBAction) changeProfilePhoto;

- (void)selectExistingPicture;
- (void)getCameraPicture:(id)sender;
- (void) alertNow;
-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
- (void)startWiggle;
- (void)stopWiggle;

@end
