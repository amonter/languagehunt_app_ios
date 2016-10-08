//
//  UploadPhotoFileRequest.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 22/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UploadPhotoFileRequest : NSObject {

	NSURLConnection *connection;	
	UINavigationController *theController;
	bool isOwner;
}

@property bool isOwner;
@property (nonatomic, retain) UINavigationController *theController;

- (void) flushConnections;
- (void)postUpload:(NSString *)filePath;


@end
