///
//  ProtocolCommunication.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 22/08/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "ProtocolCommunication.h"
#import "StringEscapeUtil.h"
#import "NSData+GTMZLibAdditions.h"

@interface ProtocolCommunication ()

// Properties that don't need to be seen by the outside world.

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

@end


@implementation ProtocolCommunication
@synthesize inputStream, outputStream,delegate;


- (void) initNetworkCommunication {
    //NSLog(@"INIT STREAM");
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //74.50.62.220
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"74.50.62.220", 1045, &readStream, &writeStream);
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"coms.peoplehunt.me", 1045, &readStream, &writeStream);
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"50.19.45.37", 1045, &readStream, &writeStream);
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 1045, &readStream, &writeStream);
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"74.50.62.220", 1045, &readStream, &writeStream);
    if (readStream&&writeStream) {
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    
        inputStream = (NSInputStream *)readStream;
        [inputStream retain];
    
        outputStream = (NSOutputStream *)writeStream;
        [outputStream retain];
    
        [inputStream setDelegate:self];
        [outputStream setDelegate:self];
        //do the Looping
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
        [inputStream open];
        [outputStream open];        
    }

}


- (void) closeNetworkCommunication {

    //NSLog(@"CLOSSSSING");
    [inputStream close];
    [outputStream close];
    [inputStream  removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream  removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    [inputStream release];
    [outputStream release];
    inputStream = nil;
    outputStream = nil;
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {            
		case NSStreamEventOpenCompleted:           
            NSLog(@"connection open");
			break;            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                
                int len = 0;
                
                NSRange weDone;
                
                NSMutableString *data= [[[NSMutableString alloc] init] autorelease];
                
                while([inputStream hasBytesAvailable] || (len>0 && weDone.location == NSNotFound) ){
                    
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    
                    if (len > 0) {
                        
                        NSString *output = [[[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding] autorelease];
                        
                        [data appendString:output];
                        
                        weDone = [output rangeOfString:@"\r\n"];
                        
                        //NSRange foundRange = [output rangeOfString:@"\r\n"];
                        
                        //if (foundRange.location != NSNotFound)break;
                        
                    }                    
                }
                
                [delegate serverResponse:[NSString stringWithUTF8String:[data cStringUsingEncoding:NSUTF8StringEncoding]]];
                
            }           
			break;
        case NSStreamEventHasSpaceAvailable:
            /*
            if (theStream == outputStream) {
                //send data
                uint8_t buffer[11] = "I send this";
                int len;
                
                len = [outputStream write:buffer maxLength:sizeof(buffer)];
                if (len > 0) {
                    NSLog(@"Command send");
                    //[outputStream close];
                }
            }
            */
            break;           
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
            //try again
            [self closeNetworkCommunication];
            [self initNetworkCommunication];
            [self sendMessage:[NSString stringWithFormat:@"1:%i:%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"profileid"] intValue], [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"]]];			
			break;
            
		case NSStreamEventEndEncountered:
            NSLog(@"Stream has been closed %i", streamEvent);
            [inputStream close];
            [outputStream close];
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [theStream release];
            theStream = nil;
			break;
            
		default:
            //[self initNetworkCommunication];
			NSLog(@"Unknown event %i", streamEvent);
	}
}




- (bool) checkStreamStatus {
    
    bool isStreamOpen = true;
    int status = outputStream.streamStatus;
    switch (status) {
        case NSStreamStatusNotOpen:
            isStreamOpen = false;
            break;
        case NSStreamStatusClosed:
            isStreamOpen = false;
            break;            
        case NSStreamStatusError:
            isStreamOpen = false;
            break;       
    }
    
    return isStreamOpen;
}

- (void) sendMessage:(NSString *) msg {
    //StringEscapeUtil *escape = [[[StringEscapeUtil alloc] init] autorelease];
    
    NSString *response  = [NSString stringWithFormat:@"%@\n",msg];   
	NSData *data = [[[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    //NSData *newdata = [NSData gtm_dataByRawDeflatingData:data compressionLevel:9];
	[outputStream write:[data bytes] maxLength:[data length]];
    
}


- (void)dealloc {    
    [super dealloc];
}

@end
