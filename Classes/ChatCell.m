//
//  ChatCell.m
//  CrowdScannerMindField
//
//  Created by ellie's macbook on 03/11/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "ChatCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChatCell
@synthesize theChatMessage, photoChat, theShadowBackground, thePhotoCorner, fileName;



- (void) setOwnerPhoto {
    
    self.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];   
    NSLog(@"ADDIND OWNER PHOTO");
    NSString *photoPath = @"Documents/profilePhotoPull.jpg";
    NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:photoPath];
    UIImage *theProfileImage = [UIImage imageWithContentsOfFile:thePath];
    self.photoChat.image = theProfileImage;    
}


- (void) setBackgroundShadow {
    
    self.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];    
    theShadowBackground.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    thePhotoCorner.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cornerPhotoChat.png"]];    
}

- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect theFrameText = theChatMessage.frame;
    theFrameText.size.height = self.frame.size.height;
    theChatMessage.frame = theFrameText;
   

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];   
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma - mark loading images method

- (void)setOtherPhoto:(NSString *) theUrl {		
    if (connection!=nil) {
		[connection cancel];
		[connection release];
		connection = nil;
	}
    if (data!=nil) {
		[data release];
		data = nil;
	}    
    
    NSArray *parts = [theUrl componentsSeparatedByString:@"/"];
    self.fileName = [parts objectAtIndex:[parts count] -1];
    NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", self.fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:thePath]){
        NSLog(@"CACHED");
        UIImage *image = [UIImage imageWithContentsOfFile:thePath];
        self.photoChat.image = image;
        [self setNeedsLayout];		
    } else {
        NSURL *url = [NSURL URLWithString:theUrl];
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:60.0];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }   
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {	
    if (data==nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
    
    UIImage *image = [UIImage imageWithData:data];
    self.photoChat.image = image;
	[self setNeedsLayout];
    
    //store the image now
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", self.fileName]];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
	
	[data release];
	data = nil;
}



- (void)dealloc {  
    [fileName release];
    [data release];
    [theChatMessage release];
    [photoChat release];
    [theShadowBackground release];
    [thePhotoCorner release];
    [super dealloc];
}

@end
