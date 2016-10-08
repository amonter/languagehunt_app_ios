//
//  StringEscapeUtil.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 24/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "StringEscapeUtil.h"


@implementation StringEscapeUtil

- (NSMutableString *)xmlSimpleUnescape:(NSMutableString *) aString {
	
	NSString *decodedString = [((NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)aString,
																				   NULL,NULL,kCFStringEncodingUTF8)) autorelease];
            
    
    NSMutableString *theString = [[decodedString mutableCopy] autorelease];	
	//[theString replaceOccurrencesOfString:@"%"  withString:@"%25"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];	
    [theString replaceOccurrencesOfString:@"&"  withString:@"%26"  options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
    [theString replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
    [theString replaceOccurrencesOfString:@"'"  withString:@"%27" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
	[theString replaceOccurrencesOfString:@"+"  withString:@"%2B" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
    //[theString replaceOccurrencesOfString:@">"  withString:@"%3E"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
    //[theString replaceOccurrencesOfString:@"<"  withString:@"%3C"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
	[theString replaceOccurrencesOfString:@"@"  withString:@"%40"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];	
	[theString replaceOccurrencesOfString:@"/"  withString:@"%2F"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
	[theString replaceOccurrencesOfString:@"$"  withString:@"%24"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
	[theString replaceOccurrencesOfString:@")"  withString:@"%29"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
	[theString replaceOccurrencesOfString:@"("  withString:@"%28"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
	[theString replaceOccurrencesOfString:@"!"  withString:@"%21"   options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
		
    
	return theString;
}


- (void) insertExtraPercent:(NSMutableString *) theString {

	int location = [theString rangeOfString:@"%"].location;
	NSLog(@"location %i", location);
	//if ([theString ])
}

+ (NSMutableString *) decode:(NSMutableString *) theString {

       [theString replaceOccurrencesOfString:@"\%27"  withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
    
    return theString;
}


+ (NSMutableString *) noBlankSpaces:(NSMutableString *) theString {
    
    [theString replaceOccurrencesOfString:@" "  withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
    
    return theString;
}


- (NSMutableString *) escapeNewLines:(NSMutableString *) theString {
	
	[theString replaceOccurrencesOfString:@" "  withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];	
    
	return theString;
    
}


+ (NSMutableString *)xmlSimpleEscape:(NSMutableString *) theString {
	
	[theString replaceOccurrencesOfString:@"+"  withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [theString length])];	
    
	return theString;
		
}

+ (NSMutableString *) urlDecoder :(NSString *) theString {

    NSMutableString *theRes = [[[theString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy] autorelease];   
    [self xmlSimpleEscape:theRes];
    
    return theRes;
}

@end
