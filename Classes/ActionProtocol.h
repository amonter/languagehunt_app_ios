//
//  ActionProtocol.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 05/05/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

// FBSample logic
// Wraps an Open Graph object (of type "scrumps:meal") that has just two properties,
// an ID and a URL. The FBGraphObject allows us to create an FBGraphObject instance
// and treat it as an SCOGMeal with typed property accessors.
@protocol TheRequest<FBGraphObject>

@property (retain, nonatomic) NSString        *id;
@property (retain, nonatomic) NSString        *url;

@end

// FBSample logic
// Wraps an Open Graph object (of type "scrumps:eat") with a relationship to a meal,
// as well as properties inherited from FBOpenGraphAction such as "place" and "tags".
@protocol TheRequestAction<FBOpenGraphAction>

@property (retain, nonatomic) id<TheRequest>   theRequest;

@end