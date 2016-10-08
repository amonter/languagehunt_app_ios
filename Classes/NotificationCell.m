//
//  NotificationCell.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 16/02/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize theChatMessage, photoChat, theTapToTry, theShadowBackground, thePhotoCorner, nameLabel, dateLabel;


- (void) setBackgroundShadow {
    

}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect theFrameText = theChatMessage.frame;
    theFrameText.size.height = self.frame.size.height - 60;
    theChatMessage.frame = theFrameText;
    
    CGRect theTap = theTapToTry.frame;
    theTap.origin.y = theChatMessage.frame.size.height + 38;
    theTapToTry.frame = theTap;
    
    /*CGRect theDate = dateLabel.frame;
    theDate.origin.y = theChatMessage.frame.size.height + 28;
    dateLabel.frame = theDate;*/
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
	
    NSURL *url = [NSURL URLWithString:theUrl];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
	
	[data release];
	data = nil;
}



- (void)dealloc {
    [dateLabel release];
    [nameLabel release];
    [data release];
    [theChatMessage release];
    [photoChat release];
    [theShadowBackground release];
    [thePhotoCorner release];
    [theTapToTry release];
    [super dealloc];
}
@end
