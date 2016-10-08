//
//  DummyIos6.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 15/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "DummyIos6.h"
#import "LocationImageView.h"
#import "iphoneCrowdAppDelegate.h"
#import "NSData+GTMZLibAdditions.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>


@interface DummyIos6 ()

@end

@implementation DummyIos6

@synthesize aMapView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"ALOHAASA");
    
    NSString *response  = [NSString stringWithFormat:@"%@\n", @"40:adriano@meetforeal.com:Aloha there hope you are great and all that"];
	NSData *data = [[[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]] autorelease];
    NSData *newdata = [NSData gtm_dataByRawDeflatingData:data compressionLevel:9];
    NSLog(@"compressed %i", [newdata length]);
    NSLog(@"not compressed %i", [data length]);
    NSData *deflated = [NSData gtm_dataByRawInflatingData:newdata];
    NSLog(@"%@", [NSString stringWithUTF8String:[deflated bytes]]);
    
}




- (void) testDummy {

    NSDictionary *theLoc = [[NSDictionary alloc] initWithObjectsAndKeys:@"40.727425", @"latitude", @"-74.005011", @"longitude", nil];
    [[NSUserDefaults standardUserDefaults] setObject:theLoc forKey:@"current_location"];
    // 37.7858, -122.406

    [self postTheMap:@"37.7858,-122.406"];
}



#pragma mark - Map methods
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    
    NSLog(@"setting region");
    MKAnnotationView *annotationViewOne = [views objectAtIndex:1];
    MKAnnotationView *annotationViewTwo = [views objectAtIndex:0];
    CLLocationCoordinate2D userCoordinateOne = [[annotationViewOne annotation] coordinate];
    CLLocationCoordinate2D userCoordinateTwo = [[annotationViewTwo annotation] coordinate];
    
    
    MKCoordinateRegion region;
    region.center.latitude = userCoordinateOne.latitude - (userCoordinateOne.latitude - userCoordinateTwo.latitude) * 0.5;
    region.center.longitude = userCoordinateOne.longitude + (userCoordinateTwo.longitude - userCoordinateOne.longitude) * 0.5;
    region.span.latitudeDelta = fabs(userCoordinateOne.latitude - userCoordinateTwo.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(userCoordinateTwo.longitude - userCoordinateOne.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mv regionThatFits:region];
    [mv setRegion:region animated:YES];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString *annotationIdentifier = @"PinViewAnnotation";    
    LocationImageView *pinView = (LocationImageView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];    
    if (!pinView) {
        
        if ([[annotation title] isEqualToString:@"yours"]) {
            pinView = [[[LocationImageView alloc]
                        initWithAnnotation:annotation
                        reuseIdentifier:annotationIdentifier imageUrl:@"http://50.19.45.37:8080"] autorelease];
            
        } else {
            pinView = [[[LocationImageView alloc]
                        initWithAnnotation:annotation
                        reuseIdentifier:annotationIdentifier] autorelease];

        }
        
    } else {
        
        pinView.annotation = annotation;
    }
    
    return pinView;
    
}


#pragma mark - SOCKETS
- (void)initProtocolCommunication {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // Top-level pool
    //Open Socket connection
    [self performSelectorOnMainThread:@selector(initProtocolCommunicationMainThread) withObject:nil waitUntilDone:NO];
    [pool release];
}



- (void) serverResponse:(NSString *)response {
   
    NSArray *responses = [response componentsSeparatedByString:@":"];
    NSLog(@"response %@", response);
    int code = [[responses objectAtIndex:0] intValue];
    NSDictionary *chatResponse = nil;
    switch (code) {
        case 50:
            //chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:[responses objectAtIndex:1], @"name", [responses objectAtIndex:2], @"content", @"other", @"image_type", nil] autorelease];
            
                        
            [self postTheMap:[responses objectAtIndex:2]];
            break;
        case 40:
            chatResponse = [[[NSDictionary alloc] initWithObjectsAndKeys:[responses objectAtIndex:1], @"name", [responses objectAtIndex:2], @"content", @"other", @"image_type", nil] autorelease];
            
            break;
        case 20:
            NSLog(@"%@",[responses objectAtIndex:1]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[responses objectAtIndex:1] delegate:self
												  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag = 20;
            [alert show];
            [alert release];
            break;
        default:
            break;
            
    }
    
    //add the tableRow now
    if (chatResponse != nil){
        //[self addNewRow:chatResponse];
        
    }
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
   
    NSLog(@"location updated");
   
}


- (void) postTheMap:(NSString *) theData {    
    
    aMapView.hidden = false;
    NSArray *theLoc = [theData componentsSeparatedByString:@","];    
      
    NSDictionary *theDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_location"];    
    
    CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake([[theDic objectForKey:@"latitude"] doubleValue], [[theDic objectForKey:@"longitude"] doubleValue]);
    MKPointAnnotation *point = [[[MKPointAnnotation alloc] init] autorelease];
    point.title = @"mine";
    [point setCoordinate:userCoordinate];
    
    CLLocationCoordinate2D userCoordinate2 = CLLocationCoordinate2DMake([[theLoc objectAtIndex:0] doubleValue], [[theLoc objectAtIndex:1] doubleValue]);
    MKPointAnnotation *point2 = [[[MKPointAnnotation alloc] init] autorelease];
    point2.title = @"yours";
    [point2 setCoordinate:userCoordinate2];
    
    NSArray *allPoints = [[[NSArray alloc] initWithObjects:point, point2, nil] autorelease];
    [self.aMapView addAnnotations:allPoints];
   
}



- (IBAction) sendChatMessage:(id) sender {
    
    ((UIButton *)sender).hidden = true;
    iphoneCrowdAppDelegate *theDelegate = (iphoneCrowdAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(sendMapProtocol)
                                                 name:@"location_ready" object:theDelegate];
	[theDelegate startGeolocation];
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
