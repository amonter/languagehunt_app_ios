//
//  RetrieveQuestionStats.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 30/01/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RetrieveQuestionStats : NSObject {

	NSMutableData *theData; 
	NSURLConnection *connection;
	//NSDictionary *theResult;
	NSString *alterURL;
    NSString *notificationName;
}


@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, retain) NSString *alterURL;
//@property (nonatomic, retain) NSDictionary *theResult;
@property (nonatomic, retain) NSMutableData *theData; 
- (void) retrieveAnswerStat:(int) questionPhoneId answerLabel:(NSString *) theAnswerLabel;
- (void) processQuestionsStats:(NSDictionary *) userInfo jsonRequest:(NSString *) json saveBatch:(bool) save; 
- (void) flushConnections;
- (void) retrieveImageURLUID;
- (void) retrieveSingleBundle;
- (void) updateBundleAnswers:(NSString *) jsonRequest;
- (void) cancelTheConnection;
- (void) insertProvidingFeeler:(NSString *) feelerData status:(bool) theStatus;
- (void) getIndividualFeelerData:(NSString *) jsonRequest;

@end

