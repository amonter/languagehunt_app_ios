//
//  AvatarImageView.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 26/09/2010.
//  Copyright 2010 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AvatarImageView : UIView {
	NSURLConnection* connection;
    NSMutableData* data;
	CGRect imageFrame;	
	NSString *urlString;
	CGPoint startLocation;
	NSMutableDictionary *nodeData;
	NSMutableDictionary *cacheData;
	bool loadingGraphData;
	NSString *theEmail;
	float cornerRadius;
	bool displayUImage;
    NSString *fileName;
}

@property bool displayUImage;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSMutableDictionary *cacheData;
@property (nonatomic,retain) NSString *theEmail;
@property (nonatomic, retain) NSMutableDictionary *nodeData;
@property (nonatomic, retain) NSString *urlString;
@property CGRect imageFrame;
@property float cornerRadius; 

- (void)loadImageFromURL:(NSURL*)url theImageFrame:(CGRect) theFrame; 
- (void) needsReload;
- (void) addCachedImage:(UIImage *) anImage aFrame:(CGRect) theFrame;
- (void) removeImageView;
- (void) checkIfImageExists:(NSString*) url theImageFrame:(CGRect) theFrame;
- (bool) isMyphoto;


@end
