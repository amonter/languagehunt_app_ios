//
//  MapAnnotation.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 08/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation
@synthesize questionDescription;
@synthesize coordinate;
@synthesize pinColor;
@synthesize questionRemarks;
@synthesize questionPhoneId;


#pragma mark -
- (NSString *)title {	
	return self.questionRemarks;
}

- (NSString *)subtitle { 

	return self.questionDescription;
}

- (void) mapCoordinates:(double) latitude theLongitude:(double) aLongitude {

	CLLocationCoordinate2D cordObj;
	cordObj.latitude = latitude;
	cordObj.longitude = aLongitude;
	
	self.coordinate = cordObj;
}


- (void)dealloc { 
	[questionRemarks release];
	[questionDescription release];
	[super dealloc];
}

@end
