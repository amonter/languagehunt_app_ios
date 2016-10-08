//
//  PeopleHuntRequests.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 12/07/2011.
//  Copyright 2011 crowdscanner. All rights reserved.
//

#import "PeopleHuntRequests.h"
#import "StringEscapeUtil.h"


@implementation PeopleHuntRequests  
@synthesize requester, matchTimer;



- (void) retrieveProfileData { 
    
	[self flushConnections];
    //[[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]
    NSMutableString *urlFormat = [NSMutableString stringWithFormat:@"http://50.19.45.37:8080/rest/retrievehunterprofile/?profileid=%i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];
    NSLog(@"format %@", urlFormat);
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:40.0];
    
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];   
	
	[theURL release];
	[serverRequest release];
}

- (void) retrieveUserHuntId:(int) bundleId {
	
	[self flushConnections];
    NSString *myUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSMutableString *urlFormat = [NSMutableString stringWithFormat:@"http://50.19.45.37:8080/rest/retrieveuserhuntid?username=%@&bundleid=%i", myUsername, bundleId];
    NSLog(@"URL format %@", urlFormat);
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
    
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
    
}




- (void) postJsonProfile:(NSDictionary*) theData {
     

    
   

}

- (void) findAmigoMatch:(int) myhuntId {
	
	[self flushConnections];	
    
    NSMutableString *urlFormat = [NSMutableString stringWithFormat:@"http://50.19.45.37:8080/rest/pairinghuntmatching/?myhuntid=%i", myhuntId];
    NSLog(@"format %@", urlFormat);
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:40.0];
    
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
    //matchTimer = [NSTimer scheduledTimerWithTimeInterval: 14.0 target: self selector: @selector(cancelConnectionForHunt) userInfo: nil repeats: YES];
	
	[theURL release];
	[serverRequest release];        
}


- (void) cancelConnectionForHunt {

    if (connection!=nil) {
		[connection cancel];
		[connection release];
		connection = nil;
	}
    [matchTimer invalidate];
    matchTimer = nil;
    NSLog(@"connectiion has benn cancelled");
    
}



- (void) addTransaction:(NSString*) jsonData {    
    
    [self flushConnections];
    NSMutableString *parameters = [[NSMutableString alloc] init];
    NSURL *theURL = [[NSURL alloc] initWithString:@"http://50.19.45.37:8080/rest/addtransaction"];
    NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:60.0];
    
    [serverRequest setHTTPMethod:@"POST"];
    [serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
    [serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    
    [serverRequest setHTTPBody:[jsonData dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
    
    
    [theURL release];
    [parameters release];
    [serverRequest release];
}



- (void) postMissingLanguage:(NSString*) jsonData {
    
    
    [self flushConnections];
    NSMutableString *parameters = [[NSMutableString alloc] init];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/addmissinglang/%i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];
    NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:60.0];
    
    [serverRequest setHTTPMethod:@"POST"];
    [serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
    [serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
   
    [serverRequest setHTTPBody:[jsonData dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
    
    
    [theURL release];
    [parameters release];
    [serverRequest release];
    
}





- (void) addAllFeelerData:(NSDictionary*) feelerData {
    
    NSLog(@"DIC %@", feelerData);
    [self flushConnections];
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/addallfeelers/%i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
    [serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    
    NSError *error = NULL;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:feelerData options:NSJSONReadingAllowFragments error:&error];
    NSString *theResult = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"JSON %@", theResult);
    
    [serverRequest setHTTPBody:[theResult dataUsingEncoding:NSUTF8StringEncoding]];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	
	[theURL release];
	[parameters release];
	[serverRequest release];
    
}


- (void) retrieveOffers {
    
    [self flushConnections];
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/getoffers"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
}



- (void) retrieveHelpWithData {
    
    [self flushConnections];	
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/gethelp?profileid=10"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[theURL release];
	[serverRequest release];
}


- (void) retrieveInterestedInData {
    
    [self flushConnections];
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/getinterested"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
    
}


- (void) retrieveAllLocations {

    [self flushConnections];
    self.alterURL = @"array";
    NSString *urlFormat = @"http://50.19.45.37:8080/rest/getlocationscoord";
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];

}


- (void) retrieveHuntBundles {
	
	[self flushConnections];	
    
    self.alterURL = @"array";
	NSString *urlFormat = @"http://50.19.45.37:8080/rest/retrievehuntbatchquestions/";
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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


- (void) retrieveLatestUpdateLink {
    
    [self flushConnections];    
	NSURL *theURL = [[NSURL alloc] initWithString:[@"http://50.19.45.37:8080/rest/updatelink" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];

}


- (void) retrieveMyFeelerData:(int) segment {
	
	[self flushConnections];
    NSString *theUrl = @"http://50.19.45.37:8080/rest/getfeelerdata";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"]){
        theUrl = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/getfeelerdata?&username=%@&page=%i", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], segment];
    }
    
    NSLog(@"SEGMENT %@", theUrl);
	NSURL *theURL = [[NSURL alloc] initWithString:[theUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];

}



- (void) disableNotifications {
	
	[self flushConnections];
    
	NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/addusertobundle/?bundleid=%i&profileid=%i&action=4",3033, [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];    
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
}



- (void) terminateMatch {
	
	[self flushConnections];
    
	NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/addusertobundle/?bundleid=%i&profileid=%i&action=0",3033, [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];
    NSLog(@"DSIABLE URL %@", urlFormat);
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
}



- (void) addGroupMembership:(int) groupid {
	
	[self flushConnections];
    
	NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/addmembership?username=%@&groupid=%i",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"], groupid];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];	
	
	[theURL release];
	[serverRequest release];    
}



- (void) updateUserEmail {
	
	[self flushConnections];	    
    
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/updateuseremail/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	[parameters appendFormat:@"%@=%@", @"email", [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];		    
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	
}



- (void) sendEfactorData:(NSString *) theJsonData {

    [self flushConnections];	    
    
    NSLog(@"EFACROE JSON %@", theJsonData);
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/addefactordata/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	[parameters appendFormat:@"%@=%@", @"jsondata", theJsonData];		    
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	

}


- (void) addSimpleProfile:(NSString*) profileType {
    
    [self flushConnections];   
    StringEscapeUtil *escape = [[StringEscapeUtil alloc] init];
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
    
    
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/addsimpleprofile/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	//[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	//[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];     
	[parameters appendFormat:@"%@=%@&", @"name", [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"]];
	[parameters appendFormat:@"%@=%@&", @"password",@"apassword"];
    [parameters appendFormat:@"%@=%@&", @"email", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"]];
    NSString *encodedImageUrl = (NSString *) CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)[[NSUserDefaults standardUserDefaults] objectForKey:@"my_image"],
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 );
    [parameters appendFormat:@"%@=%@&", @"myimage", encodedImageUrl];
    [parameters appendFormat:@"%@=%@&", @"bio", [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"]];
	[parameters appendFormat:@"%@=%g&", @"latitude", currentLatitude];
	[parameters appendFormat:@"%@=%g&", @"longitude", currentLongitude];
    [parameters appendFormat:@"%@=%@&", @"placemark", [[NSUserDefaults standardUserDefaults] objectForKey:@"placemark"]];
	[parameters appendFormat:@"%@=%@&", @"profile_type", profileType];
    [parameters appendFormat:@"%@=%@", @"token", [[NSUserDefaults standardUserDefaults] objectForKey:@"the_token"]]; 

    
	[serverRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
    [escape release];
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];
}


- (void) updateProfileInfo:(NSDictionary*) elements {
    [self flushConnections];
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/saveprofileinfo"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    [parameters appendFormat:@"%@=%i&", @"profileid", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];
    [parameters appendFormat:@"%@=%@&", @"bio", [elements objectForKey:@"bio"]];
    [parameters appendFormat:@"%@=%@&", @"interests", [elements objectForKey:@"interests"]];
    NSString* thePlacemark = [[NSUserDefaults standardUserDefaults] objectForKey:@"placemark"];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"show_location"] boolValue]){
        NSLog(@"NO LOCATION");
        thePlacemark = nil;
    }
    
    [parameters appendFormat:@"%@=%@", @"currentCity", thePlacemark];
    NSLog(@"PARAM %@", parameters);
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];
}

- (void) addLinkedInData:(NSString *) name url:(NSString *) theUrl {
	
	[self flushConnections];	        
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/addlinkedindata/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [parameters appendFormat:@"%@=%@&", @"name", name];
    [parameters appendFormat:@"%@=%@", @"url", theUrl];
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	
}


- (void) giveGroupAccess:(NSString *) otherUsername {

    [self flushConnections];
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/giveotheraccess?username=%@&other=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"], otherUsername];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];

}


- (void) addTwitterHandle {
	
	[self flushConnections];	    
    
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/addtwitterhandle/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [parameters appendFormat:@"%@=%@", @"handle", [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_handle"]];		    
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	
}



- (void) sendPushNotificationToken {
	
	[self flushConnections];	    
    		
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/addpushtoken/"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];  
	
    
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
	[parameters appendFormat:@"%@=%@", @"token", [[NSUserDefaults standardUserDefaults] objectForKey:@"the_token"]];		    
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	
}






- (void) retrieveSocialStream:(int) bundleId {
	
	[self flushConnections];	
    
    self.alterURL = @"array";
	NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/retrievesocialstream/%i",bundleId];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[theURL release];
	[serverRequest release];
}



- (void) retrieveBundlePlayers:(int) bundleId {
	
	[self flushConnections];	
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/retrievecurrentplayers/%i",bundleId];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[theURL release];
	[serverRequest release];
}






- (void) deleteFeelerState:(int) feelerId statusType:(NSString *) type {
    
    [self flushConnections];
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/deletestatus?username=%@&feelerid=%i&statustype=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],feelerId, type];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
}


- (void) addFeelerState:(int) feelerId statusType:(NSString *) type {

    [self flushConnections];
    
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/addstatus?username=%@&feelerid=%i&statustype=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],feelerId, type];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[theURL release];
	[serverRequest release];
}


- (void) addGuessReq:(int) herHuntid myGuess:(NSString *) theGuess bundleId:(int) bundleid {
	
    int myhuntId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"huntid"] intValue];
	[self flushConnections];		
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/addguess"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];  
	
	[parameters appendFormat:@"%@=%i&", @"myhuntid", myhuntId];
    [parameters appendFormat:@"%@=%i&", @"herhuntid", herHuntid];
    [parameters appendFormat:@"%@=%i&", @"bundleid", bundleid];
	[parameters appendFormat:@"%@=%@", @"myguess", theGuess];		
    
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	
}


- (void) addFoundTarget:(int) bundleId collectedUser:(NSString *) collectedUsername {
	
    [self flushConnections];		
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/collectionaction"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];	
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];	
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];	
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];  
	
	[parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];   
    [parameters appendFormat:@"%@=%@&", @"collecteduser", collectedUsername];
    [parameters appendFormat:@"%@=%i&", @"bundleid", bundleId];		
    
    NSLog(@"PARAMETERS %@", parameters);
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	    
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];	
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];		
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];	
}


- (void) retrieveMyGroupsProfile {
    
    [self flushConnections];
    NSString *myUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSLog(@"the username %@", myUsername);
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/getmygroups?username=%@", myUsername];
    NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:60.0];
    [serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
    [serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    
    connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
    
    //[urlFormat release];
    [theURL release];
    [serverRequest release];
}


- (void) removePreviousMatch:(int) otherProfileId {
    [self flushConnections];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/disablematch/?profileone=%i&profiletwo=%i&action=%i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], otherProfileId, 1];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];

}


- (void) cantFindTarget:(int) bundleId collectedUser:(int) collectedHuntId theHuntId:(int) aHuntId {
	
    [self flushConnections];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/disablematch/?profileone=%i&profiletwo=%i&bundleid=%i", aHuntId, collectedHuntId, bundleId];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];    
}


- (void) retrieveMatchList {
    
    [self flushConnections];
    self.alterURL = @"array";
    NSString *myUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/matchconnections?username=%@", myUsername];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];
}


- (void) retrieveProfileFeelerData:(int) otherProfileId {
    
    [self flushConnections];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/profilefeelerdata?otherprofileid=%i",            otherProfileId];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];
}



- (void) retrieveInbox:(int) otherProfileId {
	
    [self flushConnections];
    int myProfileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/retrieveinbox?profileid=%i&otherprofileid=%i", myProfileId, otherProfileId];
    NSLog(@"URRR %@", urlFormat);
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];
}


- (void) retrieveOpenGroups {
    
    [self flushConnections];
    NSString *urlFormat = @"http://50.19.45.37:8080/rest/getopengroups";
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];
}


- (void) searchFeelerLike:(NSString*) likeData {

    [self flushConnections];
    self.alterURL = @"array";
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/retrievelikefeelers?likefeeler=%@", likeData];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];
}


- (void) retrieveFastFeeler:(int) feelerId {
    [self flushConnections];
    NSString *urlFormat = [NSString stringWithFormat:@"http://127.0.0.1:7015/rest/findfeeler/?feelerid=%i", feelerId];
    NSLog(@"FORMAT %@", urlFormat);
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];

}

- (void) retrieveRandomFeelers {
    
    [self flushConnections];
    self.alterURL = @"array";
    NSString *urlFormat = @"http://50.19.45.37:8080/rest/getrandomfeelers";
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];    
}

- (void) retrieveSentMessages {
    
    [self flushConnections];
    self.alterURL = @"array";
    int profileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue];
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/sentmessages?profileid=%i", profileId];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];

}

- (void) retrieveMyNotifications {
	
    [self flushConnections];
    self.alterURL = @"array";
    int profileId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]; 
    NSString *urlFormat = [NSString stringWithFormat:@"http://50.19.45.37:8080/rest/retrievenotifications?profileid=%i", profileId];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	//[urlFormat release];
	[theURL release];
	[serverRequest release];
}

- (void) postNewMessage:(NSString *) content recipient:(NSString *) theRecipient {
	
	[self flushConnections];    
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSMutableString *urlFormat = [[NSMutableString alloc]initWithFormat:@"http://50.19.45.37:8080/rest/postnewmessage"];
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    [parameters appendFormat:@"%@=%@&", @"username", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [parameters appendFormat:@"%@=%@&", @"content", content];
    [parameters appendFormat:@"%@=%@", @"recipient", theRecipient];
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
	
	[urlFormat release];
	[theURL release];
	[parameters release];
	[serverRequest release];
}

- (void) postPushNotification:(int) senderId {

    [self flushConnections];
	NSMutableString *parameters = [[NSMutableString alloc] init];
	NSString *urlFormat = @"http://50.19.45.37:8080/rest/postpushnotification";
	NSURL *theURL = [[NSURL alloc] initWithString:[urlFormat stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *serverRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
																	  cachePolicy:NSURLRequestUseProtocolCachePolicy
																  timeoutInterval:60.0];
	
	[serverRequest setHTTPMethod:@"POST"];
	[serverRequest setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[serverRequest setValue: @"text/plain,text/html,application/xhtml+xml,application/xml;q=0.9,q=0.8" forHTTPHeaderField:@"Accept"];
	[serverRequest setValue: @"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
    [parameters appendFormat:@"%@=%i&", @"senderid", senderId];
    [parameters appendFormat:@"%@=%i", @"callerid", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue]];
	NSString *parameters2 = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[serverRequest setHTTPBody:[parameters2 dataUsingEncoding:NSUTF8StringEncoding]];
	
	connection = [[NSURLConnection alloc] initWithRequest:serverRequest delegate:self];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[NSString stringWithFormat:@"senderid_%i", senderId]];
   
	
	
	[theURL release];
	[parameters release];
	[serverRequest release];

}


@end
