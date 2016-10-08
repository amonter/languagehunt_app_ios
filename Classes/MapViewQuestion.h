//
//  MapViewQuestion.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 08/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 
#import "LoadingAnimationView.h" 
#import "RetrieveRemoteQuestions.h" 
#import <CoreLocation/CoreLocation.h>


@interface MapViewQuestion : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {
	
	MKMapView *mapView;
	UIProgressView *progressBar;
	UILabel *progressLabel; 
	NSArray *theQuestions;
	NSMutableArray *mapAnnotations;
	LoadingAnimationView *loading;
	RetrieveRemoteQuestions *request;
	NSMutableDictionary *questionsDic;
}


@property (nonatomic, retain) RetrieveRemoteQuestions *request;
@property (nonatomic, retain) LoadingAnimationView *loading;
@property (nonatomic, retain) NSArray *theQuestions;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) NSMutableDictionary *questionsDic;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar; 
@property (nonatomic, retain) IBOutlet UILabel *progressLabel; 
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(void) refreshContent;

@end
