//
//  AvatarImageView.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 26/09/2010.
//  Copyright 2010 crowdscanner. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "AvatarImageView.h"
#import "StringEscapeUtil.h"
#import "iphoneCrowdAppDelegate.h"


@implementation AvatarImageView
@synthesize imageFrame, urlString, nodeData, theEmail, cornerRadius, cacheData, displayUImage, fileName;


- (id)initWithFrame:(CGRect)aRect {	
	if (self == [super initWithFrame:aRect]) {				
		
	} 	
	return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];    
    displayUImage = true;
}

- (bool) isMyphoto {
    bool isPhoto = false;
    NSString *filename = self.fileName;
    NSArray *parts = [filename componentsSeparatedByString:@"/"];
    filename = [parts objectAtIndex:[parts count] -1];
    if ([fileName isEqualToString:@"profilePhotoPull.jpg"]) isPhoto = true;
    return isPhoto;
}


- (void) checkIfImageExists:(NSString*) url theImageFrame:(CGRect) theFrame {
    
    NSArray *parts = [url componentsSeparatedByString:@"/"];
    self.fileName = [parts objectAtIndex:[parts count] -1];   
    [self removeImageView];
    NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", self.fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    if ([fileManager fileExistsAtPath:thePath]){
        //NSLog(@"File name  cached %@", self.fileName);
        UIImage *image = [UIImage imageWithContentsOfFile:thePath];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:theFrame];
		imageView.tag = 797;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.image = image;
		[self addSubview:imageView];
		[imageView setNeedsLayout];
		[self setNeedsLayout];        
    } else {
        NSLog(@"loading image %@", self.fileName);               
        __block UIImage *__image = nil;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data2, NSError *error) {
                                   __image = [UIImage imageWithData:data2];
                                   //dispatch_sync( dispatch_get_main_queue(), ^ {
                                       // display the image in var pImg
                                       UIImageView* imageView = [[UIImageView alloc] initWithFrame:theFrame];
                                       imageView.tag = 797;
                                       imageView.contentMode = UIViewContentModeScaleAspectFit;
                                       imageView.image = __image;
                                       [self addSubview:imageView];
                                       [imageView setNeedsLayout];
                                       [self setNeedsLayout];
                                       
                                       //store the image now
                                       NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", self.fileName]];
                                       NSFileManager *fileManager = [NSFileManager defaultManager];
                                       if (![fileManager fileExistsAtPath:jpgPath]){
                                           NSLog(@"Storing file %@", self.fileName);
                                           [UIImageJPEGRepresentation(__image, 1.0) writeToFile:jpgPath atomically:YES];
                                       }
                                       
                                  //});
         
        }];
    
    }
}


- (void)loadImageFromURL:(NSURL*)url theImageFrame:(CGRect) theFrame {
	
	self.imageFrame = theFrame;
    if (connection!=nil) {
		[connection cancel];		
		connection = nil;
	}
    if (data!=nil) {		
		data = nil;
	}
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	
    if (data==nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}


- (void) addCachedImage:(UIImage *) anImage aFrame:(CGRect) theFrame {
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:theFrame];
    imageView.tag = 317;
    imageView.contentMode = UIViewContentModeScaleAspectFit;     
    imageView.image = anImage;
    [self addSubview:imageView];	
    [imageView setNeedsLayout];
    [self setNeedsLayout];	
}


- (void) removeImageView {
    NSArray *subViews = [self subviews];
    for (UIView *theView in subViews) {
        if ([theView isKindOfClass:[UIImageView class]]){            
            [theView removeFromSuperview];
        }
    }
    [[self viewWithTag:797] removeFromSuperview];
}

- (void)storeDataDisk:(UIImage *)image {
    NSLog(@"adding image %@", self.fileName);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.tag = 797;
    imageView.contentMode = UIViewContentModeScaleAspectFit;		
    imageView.image = image;    
    [self addSubview:imageView];
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    
    //store the image now      
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", self.fileName]];       
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:jpgPath]){
        NSLog(@"Storing file %@", self.fileName);
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {	
   
    connection=nil;
		
    UIImage *image = [UIImage imageWithData:data];
    if (displayUImage){
        //NSLog(@"add image");
        [self storeDataDisk:image];
        
    } else {
        NSString *photoPath = @"Documents/profilePhotoPull.jpg";
        // The value '1.0' represents image compression quality as value from 0.0 to 1.0
        NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:photoPath];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
        iphoneCrowdAppDelegate *appDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate notifiyPhotoDone];
        //NSLog(@"IMAGE LOADED");
    } 
	
	data = nil;
}


- (void) needsReload {
	
	NSArray *theSubviews = [self subviews];
	if ([theSubviews count] > 0) {
		for (UIView *aView in theSubviews) {
			[aView removeFromSuperview];
		}	
	}
	
	UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];   
	spinny.frame = CGRectMake(45, 45, 30, 30);
	[spinny startAnimating];
	[self addSubview:spinny];
	
}




@end
