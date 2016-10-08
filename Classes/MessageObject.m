//
//  MessageObject.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 8/28/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "MessageObject.h"

@implementation MessageObject
@synthesize locations, help, interested;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.locations forKey:@"locations"];
    [encoder encodeObject:self.help forKey:@"help"];
    [encoder encodeObject:self.interested forKey:@"interested"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.locations = [decoder decodeObjectForKey:@"locations"];
        self.help = [decoder decodeObjectForKey:@"help"];
        self.interested = [decoder decodeObjectForKey:@"interested"];
    }
    return self;
}




@end
