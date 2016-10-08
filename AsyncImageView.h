//
//  AsyncImageView.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 10/03/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIView {
	
	NSURLConnection* connection;
    NSMutableData* data;
	CGRect imageFrame;
	bool notify;
	NSString *urlString;    
	CGPoint startLocation;
	NSDictionary *nodeData;
	bool isDragable;
    bool cacheImage;
}

@property bool isDragable;
@property bool cacheImage;
@property (nonatomic, retain) NSDictionary *nodeData;
@property (nonatomic, retain) NSString *urlString;
@property bool notify;
@property CGRect imageFrame;
- (void)loadImageFromURL:(NSURL*)url theImageFrame:(CGRect) theFrame; 
- (UIImage*) image;
- (void) needsReload;
- (void) addImageView:(UIImage *) theImage;
- (void) loadLowDefinitionImage:(NSURL*)url theImageFrame:(CGRect) theFrame;

@end
