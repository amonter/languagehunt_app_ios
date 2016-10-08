//
//  MapViewQuestion.m
//  RealOusiastikos
//
//  Created by Adrian Avendano on 08/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import "MapViewQuestion.h"
#import "MapAnnotation.h"
#import "LoadingAnimationView.h"
#import "ProcessQuestionSQL.h"


@implementation MapViewQuestion
@synthesize mapView;
@synthesize progressBar;
@synthesize progressLabel, mapAnnotations; 
@synthesize theQuestions, loading, questionsDic, request; 


- (void) singleMapLocation: (NSNotification *) theResult  {
	
	
	//[self.loading removeFromSuperview];
	self.questionsDic = nil;
	self.questionsDic = [[NSMutableDictionary alloc] init];
	NSDictionary *theDictionary =  [theResult userInfo];	
	self.theQuestions = nil;
	self.theQuestions = [theDictionary objectForKey:@"questions"];
	
	CLLocationCoordinate2D cordObj;			
	Question *firstQuestion = [theQuestions objectAtIndex:0];
	cordObj.latitude = firstQuestion.latitude;
	cordObj.longitude = firstQuestion.longitude;
	
	
	self.mapView.mapType = MKMapTypeStandard;
	self.mapView.delegate = self;
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(cordObj, 2000, 2000);
	MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion]; 
	[mapView setRegion:adjustedRegion animated:YES];		
	NSLog(@"Annotation COUNT %i", [self.mapAnnotations count]);
	NSLog(@"QUestion COUNT %i", [self.theQuestions count]);
	
	for (Question *aQuestion in self.theQuestions) {		
		MapAnnotation *annotation = [[MapAnnotation alloc] init];				
		NSLog(@"LAT 2 %g LON 2 %g", aQuestion.latitude, aQuestion.longitude);
		[self.questionsDic setObject:aQuestion forKey:[NSString stringWithFormat:@"%i", aQuestion.questionPhoneId]];
		annotation.questionPhoneId = aQuestion.questionPhoneId;
		if (aQuestion.isParent) {
			annotation.pinColor = MKPinAnnotationColorRed;
		}else {
			annotation.pinColor = MKPinAnnotationColorGreen;
		}
		
		[annotation mapCoordinates:aQuestion.latitude theLongitude:aQuestion.longitude];
		annotation.questionDescription = aQuestion.description;
		annotation.questionRemarks = [NSString stringWithFormat:@"%@, asked %i people", aQuestion.createdBy, aQuestion.answersAggregate];	
		[self.mapAnnotations addObject:annotation];
		[mapView addAnnotation:annotation];
	}
}


- (void) loadMapData {
	
	if (self.request == nil) {			
		RetrieveRemoteQuestions *requestObj = [[RetrieveRemoteQuestions alloc] init];
		self.request = requestObj;
		[requestObj release];
	}
	
			
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(singleMapLocation:)
												 name:@"questionsRetrieved" object: self.request];
	[self.request retrieveQuestionMapData];	

}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.mapAnnotations = [[NSMutableArray alloc] init];
	[self loadMapData];	
	//[self.view addSubview:self.loading];		
    [super viewDidLoad];
}

-(void) refreshContent {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.mapView removeAnnotations:self.mapAnnotations];	
	self.mapAnnotations = nil;
	self.mapAnnotations = [[NSMutableArray alloc] init];	
	NSLog(@"ANOTHER COUNT %i", [self.mapAnnotations count]);
	[self loadMapData];
	
}


#pragma mark - #pragma mark Map View Delegate Methods 
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation { 

	NSLog(@"being called annotation");
	static NSString *placemarkIdentifier = @"Map Location Identifier"; 
	MapAnnotation *theAnnotation;
	if ([annotation isKindOfClass:[MapAnnotation class]]) {
		
		theAnnotation = (MapAnnotation *) annotation;
		
		MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
		if (annotationView == nil) { 
			annotationView = [[MKPinAnnotationView alloc]
													   initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
		}	
		
		
		annotationView.annotation = annotation;	
		//UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock.png"]];		
		UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		//annotationView.leftCalloutAccessoryView = iconView;
		annotationView.rightCalloutAccessoryView = rightButton;
		annotationView.pinColor = theAnnotation.pinColor; 	
		annotationView.enabled = YES; 
		annotationView.animatesDrop = YES; 
		
		annotationView.canShowCallout = YES; 
		[self performSelector:@selector(openCallout:) withObject:annotation afterDelay:0.5];																																											   
		progressBar.progress = 0.75;
		progressLabel.text = NSLocalizedString(@"Creating Annotation",@"Creating Annotation"); 				
		return annotationView;	
	}	
	
	return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *) annotationView calloutAccessoryControlTapped:(UIControl *)control {

	MapAnnotation *theAnnotation = (MapAnnotation *) annotationView.annotation;	
	Question *questionObject = [self.questionsDic objectForKey:[NSString stringWithFormat:@"%i",theAnnotation.questionPhoneId]];		
		
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
													questionObject, @"the_question", nil];	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"answerSelectedMap" object:self userInfo:dict];
	
	[dict release];	
}



- (void)openCallout:(id<MKAnnotation>)annotation { 
	
	
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapAnnotations release];
	[request release];
	[questionsDic release];	
	[theQuestions release];
	[mapView release];
	[progressBar release];
	[progressLabel release];
    [super dealloc];
}


@end
