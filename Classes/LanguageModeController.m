//
//  LanguageModeController.m
//  PeopleHunt
//
//  Created by Adrian Avendano on 5/13/14.
//  Copyright (c) 2014 crowdscanner. All rights reserved.
//

#import "LanguageModeController.h"
#import "MessageConfirmationController.h"

@interface LanguageModeController ()

@end

@implementation LanguageModeController
@synthesize delegate, mode, theMessage, overView, checkList, helpMode;


- (void)addCardView {
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *topCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    topCard.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *coverSearch = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 28)];
    coverSearch.image = [UIImage imageNamed:@"cardback_top.png"];
    
    UIImageView *middleCard;
    UIImageView *bottomImage;
    UIView* middleView;
    
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f){
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 548)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 472)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 472)];
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 495, 297.5, 28)];
        
    }else{
        //background = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 0, 297.5, 460)];
        middleCard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 297.5, 384)];
        middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, 297.5, 384)];
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 405, 297.5, 28)];
    }
    
    
    middleCard.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"cardback_middle.png"]];
    bottomImage.image = [UIImage imageNamed:@"cardback_bottom.png"];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(244.75, 117.5, 42, 42)];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refreshNew.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(rotateElements) forControlEvents:UIControlEventTouchUpInside];
    //levels view
    UIImageView *levels = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levels.png"]];
    levels.frame = CGRectMake(123, 185, 152, 24);
    
    CGRect underScrollFrame = self.overView.frame;
    underScrollFrame.size.width = 297.5;
    overView.frame = underScrollFrame;
    
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
    topview.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:95/255.0 blue:95.0/255.0 alpha:1];
    
    [self.overView addSubview:topCard];
    [self.overView addSubview:middleView];
    [self.overView addSubview:bottomImage];
    
    [middleView addSubview:middleCard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.overView.backgroundColor = [UIColor clearColor];
    
    if (mode == 0) {
        [self addCardView];
        //add languageHunt logo
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 35, 236, 68)];
        logoImage.image = [UIImage imageNamed:@"languageHunt_logo.png"];
        [self.overView addSubview:logoImage];
        
        //add welcome message image
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        UIImageView *welcomImage = [[UIImageView alloc] initWithFrame:CGRectMake(26, 175, 250, 156)];
        welcomImage.image = [UIImage imageNamed:@"manifesto_practiceLanguage.png"];
        [self.overView addSubview:welcomImage];
        //add button image
        UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 420, 267, 45)];
        [chooseBtn setImage:[UIImage imageNamed:@"choose_language.png"] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(doLearn) forControlEvents:UIControlEventTouchUpInside];
        [self.overView addSubview:chooseBtn];
        
        //[self addProficiencyView:@"Spanish"];
        
    } else {
        
        /*UIView* aView = [[UIView alloc] init];
        aView.tag = 333;
        aView.frame = self.view.frame;
        aView.backgroundColor = [UIColor blackColor];
        aView.alpha = 0.8;
        [self.view addSubview:aView];
        if (mode == 1) [self continueLearn];
        if (mode == 2) {
            self.theMessage = [[MessageConfirmationController alloc] initWithNibName:@"MessageConfirmationController" bundle:nil];
            self.theMessage.checkList = self.checkList;
            self.theMessage.helpMode = self.helpMode;
            [[NSNotificationCenter defaultCenter] addObserverForName:@"connection_info" object:self.theMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
                [self.view removeFromSuperview];
                [self doHelp];
            }];
            [[NSNotificationCenter defaultCenter] addObserverForName:@"go_inbox" object:self.theMessage queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *data) {
                [self.view removeFromSuperview];
                [self goInbox];
            }];
            [self.view addSubview:self.theMessage.view];
        }*/
    }
}


- (void) continueLearn {
    
    //add proficiecy level
    UIView* proficiency = [[UIView alloc] initWithFrame:CGRectMake(28, 600, 265, 210)];
    proficiency.alpha = 1.0;
    proficiency.tag = 727198;
    //proficiency.alpha = 0;
    UIImageView *noteBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"note_large.png"]];
    noteBack.frame = CGRectMake(0, 0, 265, 210);
    
    UILabel *profLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 23, 200, 60)];
    profLabel.backgroundColor = [UIColor clearColor];
    profLabel.lineBreakMode = UILineBreakModeWordWrap;
    profLabel.textAlignment = NSTextAlignmentCenter;
    profLabel.numberOfLines = 0;
    profLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
    profLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:23];
    profLabel.text = [NSString stringWithFormat:@"Please tell us how you can help others"];
    
    
    
    UILabel *moreHelp = [[UILabel alloc] initWithFrame:CGRectMake(20, 128, 250, 60)];
    moreHelp.backgroundColor = [UIColor clearColor];
    moreHelp.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    moreHelp.font = [UIFont fontWithName:@"FreightSans Bold" size:14];
    moreHelp.text = [NSString stringWithFormat:@"others who want to speak a language"];
    
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(65, 100, 146, 50)];
    helpBtn.tag = 2;
    [helpBtn setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(doHelp) forControlEvents:UIControlEventTouchUpInside];
    
    
    [proficiency addSubview:noteBack];
    [proficiency addSubview:profLabel];
    [proficiency addSubview:helpBtn];
    [proficiency addSubview:moreHelp];
    //[proficiency addSubview:btnNovice];
    //[proficiency addSubview:btnProficient];
    [self.view addSubview:proficiency];
    [UIView animateWithDuration:0.6 animations:^(void) {
        //proficiency.alpha = 1;
        CGRect aFrame = proficiency.frame;
        aFrame.origin.y = 160;
        proficiency.frame = aFrame;
    }];

}


- (void)addProficiencyView:(NSString*) element {
    //add proficiecy level
    UIView* proficiency = [[UIView alloc] initWithFrame:CGRectMake(17, 400, 265, 296)];
    proficiency.alpha = 1.0;
    proficiency.tag = 727198;
    //proficiency.alpha = 0;
    UIImageView *noteBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"note_large.png"]];
    noteBack.frame = CGRectMake(0, 0, 265, 296);
    
    UILabel *profLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 60)];
    profLabel.backgroundColor = [UIColor clearColor];
    profLabel.lineBreakMode = UILineBreakModeWordWrap;
    profLabel.textAlignment = NSTextAlignmentCenter;
    profLabel.numberOfLines = 0;
    profLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
    profLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:23];
    profLabel.text = [NSString stringWithFormat:@"Do you want to"];
    
    UIButton *learnBtn = [[UIButton alloc] initWithFrame:CGRectMake(65, 60, 146, 50)];
    learnBtn.tag = 1;
    [learnBtn setImage:[UIImage imageNamed:@"learn.png"] forState:UIControlStateNormal];
    [learnBtn addTarget:self action:@selector(doLearn) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 126, 60, 60)];
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textColor = [UIColor colorWithRed:25/255.0 green:179/255.0 blue:239/255.0 alpha:1];
    orLabel.font = [UIFont fontWithName:@"FreightSans Bold" size:32];
    orLabel.text = [NSString stringWithFormat:@"or"];
    
    
    UILabel *moreLearn = [[UILabel alloc] initWithFrame:CGRectMake(30, 91, 250, 60)];
    moreLearn.backgroundColor = [UIColor clearColor];
    moreLearn.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    moreLearn.font = [UIFont fontWithName:@"FreightSans Bold" size:14];
    moreLearn.text = [NSString stringWithFormat:@"how to speak spanish, french etc."];
   
    
    UILabel *moreHelp = [[UILabel alloc] initWithFrame:CGRectMake(20, 222, 220, 60)];
    moreHelp.backgroundColor = [UIColor clearColor];
    moreHelp.numberOfLines = 0;
    moreHelp.lineBreakMode = NSLineBreakByWordWrapping;
    moreHelp.textAlignment = NSTextAlignmentCenter;
    moreHelp.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    moreHelp.font = [UIFont fontWithName:@"FreightSans Bold" size:14];
    moreHelp.text = [NSString stringWithFormat:@"your language knowledge with the local community"];
    
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(65, 185, 146, 50)];
    helpBtn.tag = 2;
    [helpBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(doHelp) forControlEvents:UIControlEventTouchUpInside];
   
    
    [proficiency addSubview:noteBack];
    [proficiency addSubview:profLabel];
    [proficiency addSubview:learnBtn];
    [proficiency addSubview:helpBtn];
    [proficiency addSubview:orLabel];
    [proficiency addSubview:moreLearn];
    [proficiency addSubview:moreHelp];
    //[proficiency addSubview:btnNovice];
    //[proficiency addSubview:btnProficient];
    [self.overView addSubview:proficiency];
    [UIView animateWithDuration:0.6 animations:^(void) {
        //proficiency.alpha = 1;
        CGRect aFrame = proficiency.frame;
        aFrame.origin.y = 120;
        proficiency.frame = aFrame;
    }];
}


- (void) doLearn {  
    [delegate learnSelected];
}

- (void) goInbox {
    [delegate goInbox];
}

- (void) doHelp {
    [delegate helpSelected:298 scrollValue:0];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
