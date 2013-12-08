//
//  FarkleViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 12/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "FarkleViewController.h"

@interface FarkleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *diceButton0;
@property (weak, nonatomic) IBOutlet UIButton *diceButton1;
@property (weak, nonatomic) IBOutlet UIButton *diceButton2;
@property (weak, nonatomic) IBOutlet UIButton *diceButton3;
@property (weak, nonatomic) IBOutlet UIButton *diceButton4;
@property (weak, nonatomic) IBOutlet UIButton *diceButton5;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *diceButtons;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *farklesLabel;
@property (weak, nonatomic) IBOutlet UIButton *HUD;
@end


@implementation FarkleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    Singleton *sharedManager = [Singleton sharedManager];
    if (sharedManager.turns < 0) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
//    sharedManager.total = @1;
    
    // Setup gesture recoginizer
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(popView)];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark Nav Bar

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
*/
- (void)popView {
    // Pop this view off the stack
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark not sure if controller or model

- (void)newGame {
    Singleton *sharedManager = [Singleton sharedManager];
    
    sharedManager.turns = @12;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)endTurn {
    Singleton *sharedManager = [Singleton sharedManager];
    
    // [Farkle score:rolled] here
    
    // decrement turns by 1
    NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] -1];
    sharedManager.turns = temp;
    [self isGameOver];
}

- (void)farkled {
    Singleton *sharedManager = [Singleton sharedManager];
    
    // Farkle.m will return 0 if player farkles
    
    // decrement turns by 1
    NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] -1];
    sharedManager.turns = temp;
}

- (void)didWin {
    // is score > 10,000?
}

- (void)isGameOver {
    Singleton *sharedManager = [Singleton sharedManager];
    if (([sharedManager.turns integerValue] < 11) &&
        ([sharedManager.turns integerValue] > 0)) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        // game over
        [self newGame];
    }
}

#pragma mark Pass

- (IBAction)pass:(id)sender {
    
    [self endTurn];
    
    // debug
    Singleton *sharedManager = [Singleton sharedManager];
    NSLog(@"pass, turns == %@", sharedManager.turns);
}

- (void)enablePassButton {
    Singleton *sharedManager = [Singleton sharedManager];
	[self.passButton setEnabled:YES];
	[self.passButton setAlpha:1.0];
	[self.passButton setTitle:[NSString stringWithFormat:@"+ %@", [sharedManager total]] // was %d
                     forState:UIControlStateNormal];
}

- (void)disablePassButton {
    Singleton *sharedManager = [Singleton sharedManager];
	[self.passButton setEnabled:NO];
	[self.passButton setTitle:[NSString stringWithFormat:@"%@", [sharedManager total]] // was %d
                     forState:UIControlStateNormal];
	self.passButton.alpha = .4;
}

#pragma mark Dice

- (IBAction)selectDice:(UIButton *)sender {
}

- (void)enableDie:(UIButton *)sender {
	[sender setSelected:NO];
	[sender setAlpha:1];
    // call animation here
//	[[rolled objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:NO];
}

- (void)flipDiceButtons:(int)index {
	if (index == 1) {
        
        [UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromBottom |
         UIViewAnimationOptionAllowUserInteraction animations:^{
         } completion:nil];
	}
	if (index == 2) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromTop |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
	}
	if ((index == 3) || (index == 4)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromLeft |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
	}
	if ((index == 5) || (index == 6)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromRight |
		 UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                        } completion:nil];
	}
}


#pragma mark Roll

- (IBAction)rolled:(id)sender {
    Singleton *sharedManager = [Singleton sharedManager];
   
    if ([sharedManager.turns integerValue] == 12) {
        // decrement turns by 1
        NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] -1];
        sharedManager.turns = temp;
    }
    
    /*
    // this is just to test SharedManager and showing/hiding the navbar
    NSLog(@"total: %@", [sharedManager total]);
    if ([sharedManager.total isEqual:@0]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        sharedManager.total = @1;
    } else {
        sharedManager.total = @0;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    */
    
    
}

#pragma mark HUD

- (void)flashScreen {
	[UIView animateWithDuration:0.4
                          delay:0.2 // otherwise we will see disabled die flip
                        options: UIViewAnimationOptionCurveEaseIn 									 animations:^{
                            self.HUD.backgroundColor = [UIColor redColor];
                            self.HUD.alpha = 1.0;
                            self.HUD.alpha = 0.0;
                        }
                     completion:nil];
}

- (void)clearScreen:(UIColor*)color {
	[UIView animateWithDuration:0.6
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut |
	 UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.HUD.backgroundColor = color;
                         self.HUD.alpha = 0.0;
                         //		 [self.HUD setTitle:[NSString stringWithFormat:@""]
                         //							 forState:UIControlStateNormal];
                     }
                     completion:nil];
}

- (void)deathScreen:(UIColor*)color {
	[UIView animateWithDuration:1.6
                          delay:0.6
                        options: UIViewAnimationOptionCurveEaseIn |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.HUD.backgroundColor = color;
                         self.HUD.alpha = 1.0;
                         // self.HUD.tintColor = [UIColor whiteColor];
                         self.scoreLabel.textColor = [UIColor blackColor];
                     }
                     completion:nil];
}

- (void)highScoreScreen {
	[UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn |
	 UIViewAnimationOptionRepeat |
	 UIViewAnimationOptionAutoreverse |
	 UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.HUD.backgroundColor = [UIColor whiteColor];
                         self.HUD.alpha = 1.0;
                         self.HUD.backgroundColor = [UIColor redColor];
                         self.HUD.backgroundColor = [UIColor blueColor];
                         self.HUD.backgroundColor = [UIColor yellowColor];
                         self.HUD.backgroundColor = [UIColor greenColor];
                         // self.scoreLabel.textColor = [UIColor blackColor];
                     }
                     completion:nil];
}

@end
