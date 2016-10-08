//
//  ProtocolCommunication.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 22/08/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolDelegate <NSObject>
- (void)serverResponse:(NSString *)response;
@end


@interface ProtocolCommunication : NSObject <NSStreamDelegate> {

    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    id<ProtocolDelegate> delegate;
}

@property (retain) id delegate;

- (void) initNetworkCommunication;
- (void) closeNetworkCommunication;
- (void) sendMessage:(NSString *) msg;
- (bool) checkStreamStatus;
@end
