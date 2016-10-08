//
//  SelectedDataController.h
//  PeopleHunt
//
//  Created by Adrian Avendano on 14/07/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectedDataDelegate <NSObject>
- (void)dataSelected:(NSString *)theElement;
- (void)deleteElement:(NSString*)theElement;
@end


@interface SelectedDataController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    id<SelectedDataDelegate> delegate;
    float cellHeight;
}

@property (retain) id delegate;
@property (nonatomic, retain) IBOutlet UITableView* theTable;
@property (nonatomic, retain) NSMutableArray* theSelectedData;
@property float cellHeight;


- (void) addTheElement:(NSString*) theElement isNew:(bool) isNewElement;
@end
