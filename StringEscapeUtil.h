//
//  StringEscapeUtil.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 24/07/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringEscapeUtil : NSObject {

}

- (NSMutableString *)xmlSimpleUnescape:(NSMutableString *) theString;
+(NSMutableString *)xmlSimpleEscape:(NSMutableString *) theString;
- (void) insertExtraPercent:(NSMutableString *) theString;
+ (NSMutableString *) decode:(NSMutableString *) theString;
- (NSMutableString *) escapeNewLines:(NSMutableString *) theString;
+ (NSMutableString *) urlDecoder :(NSString *) theString;
+ (NSMutableString *) noBlankSpaces:(NSMutableString *) theString;

@end
