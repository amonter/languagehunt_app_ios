//
//  MatchDataTableController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 19/08/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import "MatchDataTableController.h"

@interface MatchDataTableController ()

@end

@implementation MatchDataTableController
@synthesize theTable, locations, help, interested, addedSection, about, addedHeight;
@synthesize aboutSize, interestedSize, locationsSize, helpSize, inverseOrder, proficiency, link, linkSize;
@synthesize interestSize, interest;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.addedSection = [[NSMutableArray alloc] init];
    self.addedHeight = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    self.theTable.backgroundColor = [UIColor clearColor];
    self.view.tag = 30209911;
    self.interestedLabel = @"Learn:";
    self.helpLabel = @"Share:";
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        //NSArray *viewsToRemove = [cell.contentView subviews];
        //for (UIView *v in viewsToRemove) [v removeFromSuperview];
    }
   
    
    cell.backgroundColor = [UIColor blueColor];
    //cell.backgroundColor = [UIColor clearColor];
    //cell.contentView.backgroundColor = [UIColor redColor];
    //cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blueProfileNew.png"]];
    //NSLog(@"WHAT SECTION %i", [indexPath section]);
    [cell.contentView addSubview:[self checkWhatSection:[indexPath section]]];
    // Configure the cell...
    
    return cell;
}

- (void)editVersion:(UILabel *)dataLabel backgroundView:(UIView *)backgroundView {
   
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

    if ([labelInfo isEqualToString:@"Learn:"] || [labelInfo isEqualToString:@"Share:"]){
        //[self editVersion:dataLabel backgroundView:backgroundView];
    }
    
    return backgroundView;
}


- (void) doPopLink {

    NSLog(@"Pop Link");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pop_profile" object:self];
}


- (UIView *)cellLayout:(CGRect)cellDim iconImageName:(NSString *)iconImageName content:(NSString *)content labelInfo:(NSString*) labelInfo theElement:(NSString*) element {
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 155, cellDim.size.height)];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dataLabel.numberOfLines = 0;
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
    dataLabel.text = content;
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
    }    
    
    return [self createViewIcons:cellDim iconImageName:iconImageName labelInfo:labelInfo dataLabel:dataLabel];
}

/*- (UIView *)cellLayoutAttribute:(CGRect)cellDim iconImageName:(NSString *)iconImageName content:(NSAttributedString *)content labelInfo:(NSString*) labelInfo theElement:(NSString*) element {
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 155, cellDim.size.height)];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.lineBreakMode = UILineBreakModeWordWrap;
    dataLabel.numberOfLines = 0;
    dataLabel.textColor = [UIColor whiteColor];
    dataLabel.font = [UIFont fontWithName:@"Delicious-Heavy" size:14.0];
    dataLabel.attributedText = content;
    
    void (^selectedCase)() = @ {
           @"about" : ^{
               NSLog(@"--------about");
           },
           @"interested" : ^{
               NSLog(@"=-------interested");
           },
           @"help" : ^{
               NSLog(@"---------help");
           },
           @"interests" : ^{
                NSLog(@"-------interests");
           },
       }[element];
    
    if (selectedCase != nil)
        selectedCase();
    
    return [self createViewIcons:cellDim iconImageName:iconImageName labelInfo:labelInfo dataLabel:dataLabel];;
}*/

- (void)setHelpString:(NSMutableAttributedString *)content {
    for (id theKey in self.help) {
        NSString* helpContent = [self.help objectForKey:theKey];
        //NSLog(@"PROFEE %@", self.proficiency);
        if ([[self.proficiency allKeys] containsObject:theKey]){
            int level = [[self.proficiency objectForKey:theKey] intValue];
            NSString* skillLevel = @"";
            if (!inverseOrder) {
                switch (level) {
                    case 1:
                        skillLevel = @"(Master)";
                        break;
                    case 2:
                        skillLevel = @"(Adept)";
                        break;
                    case 3:
                        skillLevel = @"(Novice)";
                        break;
                }
            }
            
            NSMutableAttributedString *theLabel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@\n",helpContent, skillLevel]];
            int powerLength = [[NSString stringWithFormat:@" %@", skillLevel] length];
            [theLabel addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0] range:NSMakeRange((theLabel.length - powerLength), powerLength)];
            [content appendAttributedString:theLabel];
        } else {
            NSMutableAttributedString *theLabel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", helpContent]];
            [content appendAttributedString:theLabel];
        }
    }
}

- (UIView*) checkWhatSection:(int) section {
    
    NSDictionary* sectionData = [self.addedHeight objectForKey:[NSString stringWithFormat:@"%i", section]];
    //NSLog(@"SECTION DATA %@", self.addedHeight );
    NSString* element = [sectionData objectForKey:@"element"];
    if ([element isEqualToString:@"interest"]) {
        [self.addedSection addObject:@"interest"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"Interests:";
        NSString* interestsCopy = [self extractInterest];
        return [self cellLayout:cellDim iconImageName:iconImageName content:interestsCopy labelInfo:textInfo theElement:element];
    }
    
    
    if ([element isEqualToString:@"link"]) {
        [self.addedSection addObject:@"link"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"link:";
        return [self cellLayout:cellDim iconImageName:iconImageName content:self.link labelInfo:textInfo theElement:element];
    }
    
    
    if ([element isEqualToString:@"about"]) {
        [self.addedSection addObject:@"about"];
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_profileProfile.png";
        NSString* textInfo = @"About:";
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
        if (inverseOrder) textInfo = @"help him or her with:";
        return [self cellLayout:cellDim iconImageName:iconImageName content:content labelInfo:textInfo theElement:element];
    }
    
    if ([element isEqualToString:@"help"]) {
        [self.addedSection addObject:@"help"];
        NSString *content = [[self.help allValues] componentsJoinedByString:@"\n"];
        
        CGRect cellDim = CGRectMake(0, 0, 250, [[sectionData objectForKey:@"section"] floatValue]);
        NSString* iconImageName = @"icon_lightProfile.png";
        NSString* textInfo = self.helpLabel;
        
        if (inverseOrder) textInfo = @"I need help with:";
        //[self setHelpString:content];

        return [self cellLayout:cellDim iconImageName:iconImageName content:content labelInfo:textInfo theElement:element];
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"height Section %i", [indexPath section]);
    //NSLog(@"INTERESTS ++++++++ %@", self.interest);
    if (link.length > 0 && ![addedSection containsObject:@"link"] && [indexPath section] == 4) {
        [self.addedSection addObject:@"link"];
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.linkSize], @"section", @"link", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        NSLog(@"INTERESTS");
        return linkSize;
    }
    
    
    if ([interest count] > 0 && ![addedSection containsObject:@"interest"] && [indexPath section] == 3) {
        [self.addedSection addObject:@"interest"];
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestSize], @"section", @"interest", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return interestSize;
    }
    
    if (about.length > 0 && ![addedSection containsObject:@"about"] && [indexPath section] == 2) {
        [self.addedSection addObject:@"about"];
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.aboutSize], @"section", @"about", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return aboutSize ;
    }
    
    if ([locations count] > 0 && ![addedSection containsObject:@"locations"]&& [indexPath section] == 1) {
        [self.addedSection addObject:@"locations"];
        NSLog(@"locations %f", locationsSize);
       [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.locationsSize], @"section", @"locations", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return locationsSize ;
    }
    
    if ([interested count] > 0 && ![addedSection containsObject:@"interested"]&& [indexPath section] == 0) {
        [self.addedSection addObject:@"interested"];
        NSLog(@"interested %f", interestedSize);
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.interestedSize], @"section", @"interested", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        return interestedSize;
    }
    
    if ([help count] > 0 && ![addedSection containsObject:@"help"] && [indexPath section] == 0) {
        [self.addedSection addObject:@"help"];
        [self.addedHeight setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.helpSize], @"section", @"help", @"element", nil]  forKey:[NSString stringWithFormat:@"%i", [indexPath section]]];
        //NSLog(@"help %f", helpSize);
        return helpSize ;
    }
    
   
	return 0;
}


- (NSString *)extractInterest {
    NSString *interestsCopy= nil;
    NSMutableArray* arrayInterests = [NSMutableArray new];
    for (NSDictionary* theInterest in self.interest) {
        [arrayInterests addObject:[theInterest objectForKey:@"name"]];
    }
    
    interestsCopy = [arrayInterests componentsJoinedByString:@" \n"];
    return interestsCopy;
}

- (CGFloat) calculateLayout {
    [self.addedHeight removeAllObjects];
    [self.addedSection removeAllObjects];
    NSMutableAttributedString* helpCopy = nil;
    NSString* interestedCopy = nil;
    NSString* locationCopy = nil;
    NSString* interestsCopy = nil;
    if ([self.help count] > 0){
        helpCopy = [[NSMutableAttributedString alloc] init];
        [self setHelpString:helpCopy];
    }
    if ([self.interested count] > 0) {
        interestedCopy = [[self.interested allValues]  componentsJoinedByString:@" \n"];
    }
    if ([self.locations count] > 0) {
        locationCopy = [[self.locations allValues]  componentsJoinedByString:@" \n"];
    }
    if ([self.interest count] > 0) {
        interestsCopy = [self extractInterest];
    }
    
    
    CGSize withinsize = CGSizeMake(155, 2000);
    CGRect szInterestedCopy = [interestedCopy boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:14.0]} context:nil];
    CGRect szHelpCopy = [[helpCopy string] boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:14.0]} context:nil];
    CGRect szLocationCopy = [locationCopy boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:14.0]} context:nil];
    CGRect szBioCopy = [about boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:14.0]} context:nil];
    CGRect linkCopy = [link boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:14.0]} context:nil];
    CGRect szInterestCopy = [interestsCopy boundingRectWithSize:withinsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Delicious-Heavy" size:14.0]} context:nil];
    
    
    self.interestSize = szInterestCopy.size.height;
    if (self.interestSize < 35.0) self.interestSize = 45;
    self.linkSize = linkCopy.size.height;
    if (self.linkSize < 35.0) self.linkSize = 45;
    self.helpSize = szHelpCopy.size.height;
    if (self.helpSize < 35.0) self.helpSize = 45;
    self.interestedSize = szInterestedCopy.size.height;
    if (self.interestedSize < 35.0) self.interestedSize = 45;
    self.aboutSize = szBioCopy.size.height;
    if (self.aboutSize < 35.0) self.aboutSize = 45;
    self.locationsSize = szLocationCopy.size.height;
    if (self.locationsSize < 35.0) self.locationsSize = 45;
    
    CGFloat finalPadding = 0;
    if ([self.interest count] > 0) finalPadding+=self.interestSize;
    if ([self.link length] > 0) finalPadding+=self.linkSize;
    if ([self.about length] > 0) finalPadding+=self.aboutSize;
    if ([self.help count] > 0) finalPadding+=self.helpSize;
    if ([self.interested count] > 0) finalPadding+=self.interestedSize;
    if ([self.locations count] > 0) finalPadding+=self.locationsSize;
    
    return finalPadding;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end