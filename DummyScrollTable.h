//
//  DummyScrollTable.h
//  RealOusiastikos
//
//  Created by Adrian Avendano on 16/06/2010.
//  Copyright 2010 meetforeal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DummyScrollTable : UITableViewController <UITextFieldDelegate> {
	
		UITextField		*textFieldNormal;
		UITextField		*textFieldRounded;
		UITextField		*textFieldSecure;
		UITextField		*textFieldLeftView;		
		NSArray			*dataSourceArray;
	}
	
	@property (nonatomic, retain, readonly) UITextField	*textFieldNormal;
	@property (nonatomic, retain, readonly) UITextField	*textFieldRounded;
	@property (nonatomic, retain, readonly) UITextField	*textFieldSecure;
	@property (nonatomic, retain, readonly) UITextField	*textFieldLeftView;
	
	@property (nonatomic, retain) NSArray *dataSourceArray;
	

@end
