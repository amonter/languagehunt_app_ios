//
//  ProcessingProtocol.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 18/03/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolCommunication.h"
#import "ConnectionListController.h"

@interface ProcessingProtocol : NSObject <ProtocolDelegate> {

    
}
@property (nonatomic, retain) ConnectionListController *connectionController;

@end
