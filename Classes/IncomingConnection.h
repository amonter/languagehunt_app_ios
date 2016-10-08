//
//  IncomingConnection.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 04/04/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomingConnection : UIView {
    
}

@property (nonatomic, retain) NSDictionary *incomeData;

- (id)initWithFrame:(CGRect)frame superController:(UIView *) superView data:(NSDictionary *) incomeDic;
@end
