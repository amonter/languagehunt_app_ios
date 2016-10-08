//
//  AsyncImageView.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 10/03/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//
#import <QuartzCore/QuartzCore.h> 
#import "AsyncImageView.h"



@implementation AsyncImageView
@synthesize imageFrame, notify, urlString, nodeData, isDragable, cacheImage;


- (id)initWithFrame:(CGRect)aRect {
    
	if (self == [super initWithFrame:aRect]) {				
		notify = true;
		urlString = @"";
		isDragable = NO;
	} 	
	return self;
}

- (void)loadImageFromURL:(NSURL*)url theImageFrame:(CGRect) theFrame {
	
    //self.urlString = [url absoluteString];
    if (connection!=nil) {
		[connection cancel];
		[connection release];
		connection = nil;
	}
    if (data!=nil) {
		[data release]; 
		data = nil;
	}
	
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.imageFrame = theFrame;
    //TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	
    if (data==nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}


- (void) loadLowDefinitionImage:(NSURL*)url theImageFrame:(CGRect) theFrame  {
    //Must put this at the correct size...
    self.imageFrame = theFrame;
    self.urlString = [url absoluteString];
    NSURL *lowURL = [NSURL URLWithString:urlString];
    NSString *lastPath = [lowURL lastPathComponent];
    NSArray *lines = [lastPath componentsSeparatedByString:@"."];
    NSURL *highURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://s3.amazonaws.com/crowdscanner_images/%@_low.png", [lines objectAtIndex:0]]];    
    [self loadImageFromURL:highURL theImageFrame:theFrame];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
	
    //NSLog(@"loaded ASYNC %@", self.urlString);
	UIImageView* imageView = [[[UIImageView alloc] initWithFrame:imageFrame] autorelease];	
	imageView.tag = 232;
    imageView.contentMode = UIViewContentModeScaleAspectFit;  
	UIImage *image = [UIImage imageWithData:data];
  
    [self loadImageFromURL:[NSURL URLWithString:self.urlString] theImageFrame:self.imageFrame];
    
	imageView.image = image;
    [self addSubview:imageView];
    
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    [data release];
    data = nil;
	if (notify) {
        //first_load
		[[NSNotificationCenter defaultCenter] postNotificationName:@"send_ok" object:self];
	}
}


- (void) needsReload {
	
	NSString *uploadingPhoto = [[NSUserDefaults standardUserDefaults] objectForKey:@"uploading_photo"];	
	if ([self.urlString isEqualToString:@""] || [uploadingPhoto isEqualToString:@"YES"]) {
		NSArray *theSubviews = [self subviews];
		if ([theSubviews count] > 0) {
			for (UIView *theView in theSubviews) {
				[theView removeFromSuperview];
			}	
		}
        
		UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];   
		//CGRect theFrame = self.frame;
		//CGRect spinnerFrame = CGRectMake(30, 30, (theFrame.size.width / 2) - 15, (theFrame.size.height / 2) - 15);
		spinny.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		//spinny.frame = spinnerFrame;
		[spinny startAnimating];
		[self addSubview:spinny];
		[spinny release];
	}
}



- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {    
	//UITouch *touch = [touches anyObject];
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
}


- (void) addImageView:(UIImage *) theImage {
	UIImageView* imageView = [[[UIImageView alloc] initWithFrame:imageFrame] autorelease];	
    imageView.contentMode = UIViewContentModeScaleAspectFit;  	
	imageView.image = theImage;
    [self addSubview:imageView];	
    [imageView setNeedsLayout];
    [self setNeedsLayout];
}


- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc {
	[nodeData release];
    [connection cancel];
    [connection release];
	[urlString release];
    [data release];
    [super dealloc];
}


@end
