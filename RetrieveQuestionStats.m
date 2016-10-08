//
//  RetrieveQuestionStats.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 30/01/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "RetrieveQuestionStats.h"
#import "StringEscapeUtil.h"
#import <CoreLocation/CoreLocation.h>

@implementation RetrieveQuestionStats
@synthesize theData, alterURL, notificationName;
//@synthesize theResult;

- (void) flushConnections {
	if (connection!=nil) {
		[connection cancel];
		[connection release];
		connection = nil;
	}
    if (theData!=nil) {
		[theData release]; 
		
		theData = nil;
	}
}



- (void) retrieveSingleBundle {	
	
	[self flushConnections];
	
	NSString *urlFormat = [[NSString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/retrievesinglebundlebeta/"];
	NSURL *theURL = [[NSURL alloc] initWithString:urlFormat];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];	
	[theURL release];
	[serverRequest release];
}



- (void) processQuestionsStats:(NSDictionary *) userInfo jsonRequest:(NSString *) json saveBatch:(bool) save {
	
	[self flushConnections];
	NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];
	double currentLatitude;
	double currentLongitude;
	if ([locDic count] == 0) {
		currentLatitude = 45.2440844;
		currentLongitude = 24.955650;
	} else {
		currentLatitude = [[locDic objectForKey:@"latitude"] doubleValue];
		currentLongitude = [[locDic objectForKey:@"longitude"] doubleValue];
	}	
	
	NSLog(@"JSON SEND %@", json);
	
	StringEscapeUtil *escape = [[StringEscapeUtil alloc] init];
    NSString *theUrlString = @"http://50.19.45.37:8080/rest/processhuntanswers/";	
	
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSURL *theURL = [[NSURL alloc] initWithString:theUrlString];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL 
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];		
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	char *passwordUTF8 = (char *)[[userInfo objectForKey:@"password"] UTF8String];
	[parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	[parameters appendFormat:@"%@=%@&", @"name", [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"]];
	//[parameters appendFormat:@"%@=%@&", @"email", [userInfo objectForKey:@"email"]];
	[parameters appendFormat:@"%@=%@&", @"twitter_image", [userInfo objectForKey:@"twitter_image"]];
	[parameters appendFormat:@"%@=%@&", @"password",[escape xmlSimpleUnescape:[NSMutableString stringWithUTF8String:(char *)passwordUTF8]]];
	[parameters appendFormat:@"%@=%i&", @"savebatch",save];
	[parameters appendFormat:@"%@=%g&", @"latitude", currentLatitude];
	[parameters appendFormat:@"%@=%g&", @"longitude", currentLongitude];   
		
    [parameters appendFormat:@"%@=%@&", @"token", [[NSUserDefaults standardUserDefaults] objectForKey:@"the_token"]];	
	char *jsonUTF8 = (char *)[json UTF8String];
	[parameters appendFormat:@"%@=%@", @"jsondata", [escape xmlSimpleUnescape:[NSMutableString stringWithUTF8String:(char *)jsonUTF8]]];	   
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"JSON ENCODED %@", [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[escape	release];
	[theUrlString release];
	[theURL release];
	[serverRequest release];	
	[parameters release];
}


- (void) insertProvidingFeeler:(NSString *) feelerData status:(bool) theStatus {
    
    [self flushConnections];
	NSMutableString *parameters = [[NSMutableString alloc] init];
   
	NSURL *theURL = [[NSURL alloc] initWithString:@"http://50.19.45.37:8080/rest/addnewfeeler"];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	[parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	[parameters appendFormat:@"%@=%@&", @"feelerdata", feelerData];
    [parameters appendFormat:@"%@=%i", @"looking", theStatus];
    NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];	
	
	[theURL release];
	[serverRequest release];
	[parameters release];
}


- (void) updateBundleAnswers:(NSString *) jsonRequest {

    [self flushConnections];   
	NSMutableString *parameters = [[NSMutableString alloc] init];    
    StringEscapeUtil *escape = [[StringEscapeUtil alloc] init];
    
	NSURL *theURL = [[NSURL alloc] initWithString:@"http://50.19.45.37:8080/rest/updatebundleanswers/"];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL 
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];		
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	[parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];	
	char *jsonUTF8 = (char *)[jsonRequest UTF8String];  
	[parameters appendFormat:@"%@=%@", @"jsondata", [escape xmlSimpleUnescape:[NSMutableString stringWithUTF8String:(char *)jsonUTF8]]];	   
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"JSON UPDATED ENCODED %@", [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[escape	release];
	[theURL release];
	[serverRequest release];	
	[parameters release];
}


- (void) getIndividualFeelerData:(NSString *) jsonRequest {
    
    [self flushConnections];
	NSMutableString *parameters = [[NSMutableString alloc] init];
    StringEscapeUtil *escape = [[StringEscapeUtil alloc] init];
    
	NSURL *theURL = [[NSURL alloc] initWithString:@"http://50.19.45.37:8080/rest/getindividualfeeler"];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    char *jsonUTF8 = (char *)[jsonRequest UTF8String];
	[parameters appendFormat:@"%@=%@", @"jsondata", [escape xmlSimpleUnescape:[NSMutableString stringWithUTF8String:(char *)jsonUTF8]]];
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"JSON UPDATED ENCODED %@", [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[escape	release];
	[theURL release];
	[serverRequest release];
	[parameters release];
}





- (void) retrieveImageURLUID {
	
	[self flushConnections];	
	
}



- (void) retrieveAnswerStat:(int) questionPhoneId answerLabel:(NSString *) theAnswerLabel {
	
	StringEscapeUtil *escape = [[StringEscapeUtil alloc] init];
	//NSLog(@"phone id %i label %@", questionPhoneId, theAnswerLabel);
	[self flushConnections];		
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/computequestionmatch/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];  
	
	char *theUTF8 = (char *)[theAnswerLabel UTF8String];
	[parameters appendFormat:@"%@=%i&", @"questionPhoneId", questionPhoneId];
	[parameters appendFormat:@"%@=%@", @"stringanswer", [escape xmlSimpleUnescape:[NSMutableString stringWithUTF8String:(char *)theUTF8]]];		
	   
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];
	[escape release];
}


#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
	NSMutableData *theDataObj = [[NSMutableData alloc] initWithCapacity:0];
	self.theData = theDataObj;
	[theDataObj release];
    int statusCode = [resp statusCode];
    NSLog(@"Status code %i", statusCode);
    if (statusCode >= 300) { 		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Opps, An Error happened, Please try again!" delegate:self 
											  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"error_happened" object:self];
	}
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
     if (data != nil){
         [self.theData appendData:data];
     } else {
         NSLog(@"NOT RECEIVING DATA");
     }
}

- (void) cancelTheConnection {
    if (connection!=nil) {
		[connection cancel];
		[connection release];
		connection = nil;
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *) theConnection {	
	
	NSError *error = nil;
	//[self.theResult release];
	id resArray = nil;
    NSDictionary *dicResult = nil;
    if (notificationName.length == 0){
        notificationName = @"load_end";
    }

	if (self.alterURL.length > 0) {
        resArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
        //NSLog(@"RES %@", resArray);
		[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:resArray];
	} else {		
        dicResult = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
       //NSLog(@"RES NEW JSON %@", dicResult);
       [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:dicResult];       
	}	
		
	[connection release];
    connection = nil;
	[theData release];  
    //[dicResult release];
    theData = nil;
}



- (void)dealloc {
    [notificationName release];
	[alterURL release];
	//[theResult release];
	[connection cancel];
    [connection release];
	[theData release];	
    [super dealloc];
}

@end
