//
//  MapAnnotation.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 08/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation> {

	NSString *questionDescription;
	NSString *questionRemarks;
	CLLocationCoordinate2D coordinate;
	int pinColor;
	int questionPhoneId;
}

@property int questionPhoneId;
@property int pinColor;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *questionDescription;
@property (nonatomic, copy) NSString *questionRemarks;



- (void) mapCoordinates:(double) latitude theLongitude:(double) aLongitude;

@end
