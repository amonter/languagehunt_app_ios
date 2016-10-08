//
//  UploadPhotoFileRequest.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 22/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "UploadPhotoFileRequest.h"


#import "ViewProfilePhotoController.h"


BOOL IsDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES; 
	}
#endif
	return NO;
}


@implementation UploadPhotoFileRequest
@synthesize theController, isOwner;

- (void) flushConnections {
	if (connection!=nil) {
		[connection cancel];
		[connection release];
		connection = nil;
	}   
}


- (void)postUpload:(NSString *)filePath {
	
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	
	[self flushConnections];
	NSString *theUrlString = @"http://50.19.45.37:8080/rest/uploadprofilephotomatch/";	
	NSURL *theURL = [NSURL URLWithString:theUrlString];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL 
															  cachePolicy:NSURLRequestReloadIgnoringCacheData 
														  timeoutInterval:20.0f];
	
	NSMutableDictionary *requestData = [[NSMutableDictionary alloc] initWithCapacity:2];
   // NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
		
	
    NSLog(@"DIC %@", requestData);
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"124gtgwt554twwggg" forHTTPHeaderField:@"uid"];
	
	// define post boundary...
	NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
	NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[theRequest addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
	
	// define boundary separator...
	NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
	
	//adding the body...
	NSMutableData *postBody = [NSMutableData data];
	
	// adding params...
	for (id key in requestData) {
		NSString *formDataName = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
		NSString *formDataValue = [NSString stringWithFormat:@"%@\r\n", [requestData objectForKey:key]];
		[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[formDataName dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[formDataValue dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	// if file is defined, upload it...
	//NSString *photoPath = [[NSBundle mainBundle] pathForResource:@"crowdscannerheader" ofType:@"png"];	
	if (filePath) {
		//NSArray *split = [filePath componentsSeparatedByString:@"/"];
		//NSString *fileName = (NSString*)[split lastObject];
		NSData *fileContent = [NSData dataWithContentsOfFile:filePath options:0 error:nil];
		
		[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", @"crowdscannerheader.png"] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:fileContent];
	}
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary]
						  dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest setHTTPBody:postBody];	
	
	connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];		
	[requestData release];
}


- (void)connectionDidFinishLoading:(NSURLConnection *) theConnection {	
	
	
}


#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;	
    int statusCode = [resp statusCode];  
	NSLog(@"Status code %i %@", statusCode, [resp.URL absoluteString]);
    if (statusCode >= 300) { 
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error UploadProfile" 
														message:@"An Error happened, Sorry" delegate:self 
											  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];	
	}
}


- (void)dealloc {
	[theController release];
	[connection cancel];
    [connection release];	
    [super dealloc];
}



@end
