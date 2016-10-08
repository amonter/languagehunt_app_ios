//
//  LocationImageView.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AsyncImageView.h"

@interface LocationImageView : MKAnnotationView {

    AsyncImageView *theImage;
    NSString *theImageUrl;
    bool remoteImage;
}


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier imageUrl:(NSString *) theString;
@end
