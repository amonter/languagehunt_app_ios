//
//  HuntFeedCell.m
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 11/10/2012.
//  Copyright (c) 2012 crowdscanner. All rights reserved.
//

#import "HuntFeedCell.h"

@implementation HuntFeedCell
@synthesize delegate, characterImageNew, huntButton, findText, integrationsText, backgroundShadow, backgroundShadow2, lineSeparator, lineSeparator2, isLast, isUnique, isTop, threeDots, imagesView, centerTextView, avatarOne, avatarTwo, avatarThree, learners, ribbon;

- (void) setAvatarImage {
    
    NSString *photoPath = @"Documents/profilePhotoPull.jpg";
    NSString *thePath = [NSHomeDirectory() stringByAppendingPathComponent:photoPath];
    UIImage *theProfileImage = [UIImage imageWithContentsOfFile:thePath];
    self.characterImageNew.image = theProfileImage;
}


- (void) clearAllAvatars {
    [avatarOne removeImageView];
    avatarOne.fileName = nil;
    [avatarTwo removeImageView];
    avatarTwo.fileName = nil;
    [avatarThree removeImageView];
    avatarThree.fileName = nil;
}

- (void) addAllAvatars:(NSArray *) images {
    if ([images count] > 0){
        [self.avatarThree checkIfImageExists:[images objectAtIndex:0] theImageFrame:CGRectMake(0, 0, 28, 28)];
    }
    if ([images count] > 1){
        [self.avatarTwo checkIfImageExists:[images objectAtIndex:1] theImageFrame:CGRectMake(0, 0, 28, 28)];
    }
    if ([images count] > 2){
        [self.avatarOne checkIfImageExists:[images objectAtIndex:2] theImageFrame:CGRectMake(0, 0, 28, 28)];
    }
}


- (void) removeMyselfPhoto {
    if([self.avatarOne isMyphoto]){
        [self.avatarOne removeImageView];
        avatarOne.fileName = nil;
        return;
    }
    if([self.avatarTwo isMyphoto]){
        [self.avatarTwo removeImageView];
        avatarTwo.fileName = nil;
        return;
    }
    if([self.avatarThree isMyphoto]){
        [self.avatarThree removeImageView];
        avatarThree.fileName = nil;
        return;
    }    
}


- (void) setTopImage {
    self.isTop = true;
    
}

- (void) setBottomImage {
    self.isLast = true;
}


- (void) clearTheBorders {
    UIView *theTop = [self viewWithTag:788];
    if (theTop != nil){
        CGRect theShadowBack = self.backgroundShadow.frame;
        theShadowBack.origin.y = 0;
        self.backgroundShadow.frame = theShadowBack;
        [theTop removeFromSuperview];
    }
    
    UIView *theBottom = [self viewWithTag:789];
    if (theBottom != nil){
        isLast = false;
        self.lineSeparator.hidden = false;
        [theBottom removeFromSuperview];
    }
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
   
    CGRect backFrame = self.backgroundView.frame;
    backFrame.origin.x = 11;
    self.backgroundView.frame = backFrame;
    
    CGRect theFrameText = centerTextView.frame;
    theFrameText.size.height = self.frame.size.height - 31;
    self.centerTextView.frame = theFrameText;
    
    CGRect theShadowBack = self.backgroundShadow.frame;
    theShadowBack.size.height = centerTextView.frame.size.height + 26;
    self.backgroundShadow.frame = theShadowBack;
    
    CGRect theShadowBack2 = self.backgroundShadow2.frame;
    theShadowBack2.size.height = centerTextView.frame.size.height + 28;
    self.backgroundShadow2.frame = theShadowBack2;
    
    if (!isLast) [[self viewWithTag:789] removeFromSuperview];
    
    //to change height of cell - change 4 variables plus the nib - theFrameText, the ShadowBack, theShadowBack2 and the sz in the HuntFeedController.
    
    learners.font = [UIFont fontWithName:@"Delicious-Heavy" size:16.0];
    learners.textColor = [UIColor colorWithRed:18/255.0 green:79/255.0 blue:103/255.0 alpha:1.0];
    self.theText.font = [UIFont fontWithName:@"Delicious-Heavy" size:16.0];
    self.theText.textColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    
}


- (IBAction) addMyselfAction:(id)sender {    
    
    bool selection = ((UIButton *)sender).selected;
    //NSString *cellText = self.theHeaderText.text;
    if (((UIButton *)sender).selected) {//delete to array
        ((UIButton *)sender).selected = NO;
        /*[sender setBackgroundImage:[UIImage imageNamed:@"photo_button.png"] forState:UIControlStateNormal];
         [sender setBackgroundImage:[UIImage imageNamed:@"pressed_photo_button.png"] forState:UIControlStateHighlighted];*/
    } else {//add to array
        ((UIButton *)sender).selected = YES;
        /*[sender setBackgroundImage:[UIImage imageNamed:@"minus_photo.png"] forState:UIControlStateSelected];
         [sender setBackgroundImage:[UIImage imageNamed:@"minus_photo_pressed.png"] forState:UIControlStateSelected | UIControlStateHighlighted];*/
    }
    
    UITableView* table = (UITableView *)[self superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:self];
    [delegate addMyselfAction:pathOfTheCell isSelected:selection];    
}


- (void) huntButtonStateFind:(id)sender {    
    //normal
    //[sender setTitle:@"find" forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"wantUnpressed.png"] forState:UIControlStateNormal];
    
    //hightlighted
    //[sender setTitle:@"find" forState:UIControlStateHighlighted];
    //[sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //[sender setBackgroundImage:[UIImage imageNamed:@"wantUnpressed.png"] forState:UIControlStateHighlighted];
}

- (void)huntButtonStateScanning:(id)sender {
    
    //selected
    //[sender setTitle:@"scanning" forState:UIControlStateSelected];
    //[sender setTitleColor:[UIColor colorWithRed:255/255.0 green:27/255.0 blue:142/255.0 alpha:1] forState:UIControlStateSelected];
    //sender.shadowColor = [UIColor whiteColor].CGColor;
    //sender.shadowOffset = CGSizeMake(0.0, 1.0);
    [sender setBackgroundImage:[UIImage imageNamed:@"wantPressed.png"] forState:UIControlStateSelected];
    
    //Highlighted
    //[sender setTitle:@"scanning" forState:UIControlStateSelected | UIControlStateHighlighted];
    //[sender setTitleColor:[UIColor colorWithRed:255/255.0 green:27/255.0 blue:142/255.0 alpha:1] forState:UIControlStateSelected | UIControlStateHighlighted];
    [sender setBackgroundImage:[UIImage imageNamed:@"wantPressed.png"] forState:UIControlStateSelected];
}

- (IBAction) meetNow:(id)sender {
    
    if (((UIButton *)sender).selected) {
        //((UIButton *)sender).selected = NO;
        //[self huntButtonStateFind];
    } else {
        //((UIButton *)sender).selected = YES;
        //[self huntButtonStateScanning];
    }

    
    UITableView* table = (UITableView *)[self superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:self];
    [delegate meetNowCellSelected:pathOfTheCell sender:sender];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [learners release];
    [avatarOne release];
    [avatarTwo release];
    [avatarThree release];
    [centerTextView release];
    [bottomTextView release];
    
    [huntButton release];
    [characterImageNew release];
    [backgroundShadow release];
    [backgroundShadow2 release];
    [findText release];
    [integrationsText release];
    [imagesView release];
    [ribbon release];
    [super dealloc];
}


@end
