//
//  DummyNewTable.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 3/23/15.
//  Copyright (c) 2015 crowdscanner. All rights reserved.
//

#import "DummyNewTable.h"

@interface DummyNewTable ()

@end

@implementation DummyNewTable

@synthesize theTable, locations, help, askFor, interested, addedSection, about, addedHeight;
@synthesize aboutSize, interestedSize, locationsSize, helpSize,  proficiency, link, linkSize, askForSize;
@synthesize interestSize, interest, paymentType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //add dummy data
    self.addedSection = [[NSMutableArray alloc] init];
    self.addedHeight = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    self.withinSizeVal = 155;
    
    
    if (paymentType != nil){
        if ([[paymentType objectForKey:@"payment_type"] intValue] == 2){
            self.askFor = [NSString stringWithFormat:@"$%i for 1hr Session",  [[paymentType objectForKey:@"amount"] intValue]];
        } else {
            self.askFor =  [NSString stringWithFormat:@"%@ for $%i", [paymentType objectForKey:@"description"], [[paymentType objectForKey:@"amount"] intValue]];
        }
    }  
    
    
    /*self.interest = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObject:@"Kayaking" forKey:@"name"], [NSDictionary dictionaryWithObject:@"Climbing" forKey:@"name"],  [NSDictionary dictionaryWithObject:@"Meditating" forKey:@"name"], nil];
    
    self.help = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Spanish",@"language", nil];
    self.locations = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"New York", @"location", nil];
    self.about = @"I really like listening to Mantras that is the ultimate hack!";*/
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSArray *viewsToRemove = [cell.contentView subviews];
        for (UIView *v in viewsToRemove) [v removeFromSuperview];
    }
    
    //cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueProfileNew.png"]];
   
    NSLog(@" sec %i  row %i", [indexPath section], [indexPath row]);
    cell.backgroundColor = [UIColor clearColor];
    CGRect cellDim = CGRectMake(0, 0, 250, 40);
    
    //UIView *result = [self cellLayout:cellDim iconImageName:@"icon_profileProfile.png" content:@"This is just some content to play with" labelInfo:@"Interests" theElement:@"interested"];
    //[cell.contentView addSubview:result];
   
    [cell.contentView addSubview:[self checkWhatSection:[indexPath section]]];
   
    
    return cell;
}


- (UIView *)createViewIcons:(CGRect)cellDim iconImageName:(NSString *)iconImageName labelInfo:(NSString *)labelInfo dataLabel:(UILabel *)dataLabel {
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:cellDim];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView* iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 22, 23)];//change dimentions
    iconImage.image = [UIImage imageNamed:iconImageName];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, 70, 30)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;
    infoLabel.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    infoLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
    infoLabel.text = labelInfo;
    [infoLabel sizeToFit];
    
    [backgroundView addSubview:infoLabel];
    [backgroundView addSubview:iconImage];
    [backgroundView addSubview:dataLabel];
    if ([labelInfo isEqualToString:@"link:"]){
        UIButton *closeItButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeItButton setFrame:cellDim];
        [closeItButton addTarget:self action:@selector(doPopLink) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:closeItButton];
    }
    
    
    [self editVersion:dataLabel backgroundView:backgroundView];
    
    return backgroundView;
}


- (void)editVersion:(UILabel *)dataLabel backgroundView:(UIView *)backgroundView {
    
}


- (UIView*) checkWhatSection:(int) section {
    
    NSDictionary* sectionData = [self.addedHeight objectForKey:[NSString stringWithFormat:@"%i", section]];
    //NSLog(@"SECTION DATA %@", self.addedHeight );
    NSString* element = [sectionData objectForKey:@"element"];
    if ([element isEqualToString:@"interest"]) {
        [self.addedSection addObject:@"interest"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"I like:";
        NSString* interestsCopy = [self extractInterest];
        return [self cellLayout:cellDim iconImageName:iconImageName content:interestsCopy labelInfo:textInfo theElement:element];
    }
    
    
    if ([element isEqualToString:@"askFor"]) {
        [self.addedSection addObject:@"askFor"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"Ask For:";       
        
        return [self cellLayout:cellDim iconImageName:iconImageName content:self.askFor labelInfo:textInfo theElement:element];
    }
    
    
    if ([element isEqualToString:@"about"]) {
        [self.addedSection addObject:@"about"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"About me:";
        return [self cellLayout:cellDim iconImageName:iconImageName content:about labelInfo:textInfo theElement:element];
    }
    
    if ([element isEqualToString:@"locations"]) {
        [self.addedSection addObject:@"locations"];
        NSString *content = [[self.locations allValues] componentsJoinedByString:@"\n"];
        NSLog(@"Size location %f", self.locationsSize);
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_location_anchorProfile.png";
        NSString* textInfo = @"Where:";
        //NSLog(@"Locations %@", content);
        return [self cellLayout:cellDim iconImageName:iconImageName content:content labelInfo:textInfo theElement:element];
    }
    
    if ([element isEqualToString:@"interested"]) {
        [self.addedSection addObject:@"interested"];
        NSString *content = [[self.interested allValues] componentsJoinedByString:@"\n"];
        NSLog(@"interested %@", content);
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_pinProfile.png";
        NSString* textInfo = self.interestedLabel;
       
        return [self cellLayout:cellDim iconImageName:iconImageName content:content labelInfo:textInfo theElement:element];
    }
    
    if ([element isEqualToString:@"help"]) {
        [self.addedSection addObject:@"help"];
        NSString *content = [[self.help allValues] componentsJoinedByString:@"\n"];
        
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_lightProfile.png";
        NSString* textInfo = @"I speak:";
       
        return [self cellLayout:cellDim iconImageName:iconImageName content:content labelInfo:textInfo theElement:element];
    }
    
    return nil;
}

- (UIView *)cellLayout:(CGRect)cellDim iconImageName:(NSString *)iconImageName content:(NSString *)content labelInfo:(NSString*) labelInfo theElement:(NSString*) element {
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 8, 155, cellDim.size.height)];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dataLabel.numberOfLines = 0;
    dataLabel.textColor = [UIColor colorWithRed:0.475 green:0.471 blue:0.471 alpha:1];
    dataLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:16.0];
    dataLabel.text = content;
    [dataLabel sizeToFit];
    if ([labelInfo isEqualToString:@"link:"]){
        NSAttributedString* attrStr =
        [[NSAttributedString alloc] initWithString:content // <---
                                        attributes:
         @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)
           }];
        dataLabel.attributedText = attrStr;
    }
    
    if ([element isEqualToString:@"about"]){
        dataLabel.tag = 0;
    } else if ([element isEqualToString:@"interested"]){
        dataLabel.tag = 1;
    } else if ([element isEqualToString:@"help"]){
        dataLabel.tag = 2;
    } else if ([element isEqualToString:@"interest"]){
        dataLabel.tag = 3;
    } else if ([element isEqualToString:@"about"]){
        dataLabel.tag = 4;
    }
    
    return [self createViewIcons:cellDim iconImageName:iconImageName labelInfo:labelInfo dataLabel:dataLabel];
}


- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"HEIGHT--------------- Section %i row %i", [indexPath section], [indexPath row]);
    //NSLog(@"INTERESTS ++++++++ %@", self.interest);
    
    if ([indexPath section] == 3) {
        if (askForSize > 35) return askForSize + 10;
        return askForSize;
    }
    
    if ([indexPath section] == 2) {
        NSLog(@"interests %f", interestSize);
        if (interestSize > 35) return interestSize + 10;
        return interestSize;
    }
    
    if ([indexPath section] == 1) {
        NSLog(@"location %f", locationsSize);
        if (locationsSize > 35) return locationsSize + 10;
        return locationsSize;
    }
    
    if ([indexPath section] == 0) {
        NSLog(@"help %f", helpSize);
        if (helpSize > 35) return helpSize + 10;
        return helpSize;
    }
    
    
    return 0;
}



- (void) customTableOrder {
    
    //add setup values
    [self.addedSection addObject:@"help"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.helpSize], @"section", @"help", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 0]];
    [self.addedSection addObject:@"locations"];
    NSLog(@"locations %f", locationsSize);
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.locationsSize], @"section", @"locations", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 1]];
    [self.addedSection addObject:@"interest"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestSize], @"section", @"interest", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 2]];
    /*[self.addedSection addObject:@"about"];
     [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.aboutSize], @"section", @"about", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 3]];*/
    [self.addedSection addObject:@"askFor"];
    [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestSize], @"section", @"askFor", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", 3]];
}


- (CGFloat) calculateLayout {
    
    [self.addedHeight removeAllObjects];
    [self.addedSection removeAllObjects];
    NSMutableAttributedString* helpCopy = nil;
    NSString* interestedCopy = nil;
    NSString* locationCopy = nil;
    NSString* interestsCopy = nil;
    
    if ([self.interested count] > 0) {
        interestedCopy = [[self.interested allValues]  componentsJoinedByString:@" \n"];
    }
    if ([self.locations count] > 0) {
        locationCopy = [[self.locations allValues]  componentsJoinedByString:@" \n"];
    }
    
    if (self.interest != nil){
        if ([self.interest isKindOfClass:[NSString class]]){
            if ([self.interest length] > 0) interestsCopy = self.interest;
        }
        if ([self.interest isKindOfClass:[NSArray class]]){
            if ([self.interest count] > 0) interestsCopy = [self extractInterest];
        }
    }    
    
    CGSize withinsize = CGSizeMake(self.withinSizeVal, 2000);
    CGRect szInterestedCopy = [interestedCopy boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    CGRect szHelpCopy = [[helpCopy string] boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    CGRect szLocationCopy = [locationCopy boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    CGRect szBioCopy = [about boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    CGRect linkCopy = [link boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    CGRect szInterestCopy = [interestsCopy boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    CGRect askForCopy = [askFor boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:16.0]} context:nil];
    
    
    self.interestSize = szInterestCopy.size.height;
    if (self.interestSize < 35.0) self.interestSize = 35;
    self.linkSize = linkCopy.size.height;
    if (self.linkSize < 35.0) self.linkSize = 35;
    self.helpSize = szHelpCopy.size.height;
    if (self.helpSize < 35.0) self.helpSize = 35;
    self.interestedSize = szInterestedCopy.size.height;
    if (self.interestedSize < 35.0) self.interestedSize = 35;
    self.aboutSize = szBioCopy.size.height;
    if (self.aboutSize < 35.0) self.aboutSize = 35;
    self.locationsSize = szLocationCopy.size.height;
    if (self.locationsSize < 35.0) self.locationsSize = 35;
    self.askForSize = askForCopy.size.height;
    if (self.askForSize < 35.0) self.askForSize = 35;
    
    
    CGFloat finalPadding = 0;
    if (self.interest != nil){
        if ([self.interest isKindOfClass:[NSString class]]){
             if ([self.interest length] > 0) finalPadding+=self.interestSize;
        }
        if ([self.interest isKindOfClass:[NSArray class]]){
            if ([self.interest count] > 0) finalPadding+=self.interestSize;
        }
    }
    
    if ([self.link length] > 0) finalPadding+=self.linkSize;
    if ([self.about length] > 0) finalPadding+=self.aboutSize;
    if ([self.help count] > 0) finalPadding+=self.helpSize;
    if ([self.interested count] > 0) finalPadding+=self.interestedSize;
    if ([self.locations count] > 0) finalPadding+=self.locationsSize;
    if ([self.askFor length] > 0) finalPadding+=self.askForSize;
    
    
    
    [self customTableOrder];
    

    
    
    return finalPadding;
}


- (NSString *)extractInterest {
    
    NSString *interestsCopy= self.interest;
    NSMutableArray* arrayInterests = [NSMutableArray new];
    if ([self.interest isKindOfClass:[NSArray class]]){
        NSLog(@"INTERESTS %@", self.interest);
        for (NSDictionary* theInterest in self.interest) {
            [arrayInterests addObject:[theInterest objectForKey:@"name"]];
        }
        
        interestsCopy = [arrayInterests componentsJoinedByString:@" \n"];
    }   
    
    return interestsCopy;
}


@end
