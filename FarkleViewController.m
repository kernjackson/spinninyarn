//
//  FarkleViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 12/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "FarkleViewController.h"
#import "Farkle.h"

@interface FarkleViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *diceButtons;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *farklesLabel;
@property (weak, nonatomic) IBOutlet UIButton *HUD;
@property (weak, nonatomic) IBOutlet UIProgressView *turnsProgress;
@end

#define TURNS 10

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
    [self updateUI];
    
    
    
	// Do any additional setup after loading the view.
    
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
    Farkle *sharedManager = [Farkle sharedManager];
    
    sharedManager.turns = @TURNS;
    [self.turnsProgress setProgress:1.0 animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)endTurn {
    Farkle *sharedManager = [Farkle sharedManager];
    
    // [Farkle score:rolled] here
    
    // decrement turns by 1
    NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] -1];
    sharedManager.turns = temp;
    
    [sharedManager gameLoop];
    [self updateUI];
}

- (void)farkled {
    Farkle *sharedManager = [Farkle sharedManager];
    
    // Farkle.m will return 0 if player farkles
    
    // decrement turns by 1
    NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] -1];
    sharedManager.turns = temp;
}

- (void)didWin {
    // is score > 10,000?
}

- (void)isGameOver {
    Farkle *sharedManager = [Farkle sharedManager];
    if (([sharedManager.turns integerValue] < TURNS) &&
        ([sharedManager.turns integerValue] > 0)) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        // game over
        [self newGame];
    }
}

#pragma mark Pass



- (void)enablePassButton {
    Farkle *sharedManager = [Farkle sharedManager];
	[self.passButton setEnabled:YES];
	[self.passButton setAlpha:1.0];
	[self.passButton setTitle:[NSString stringWithFormat:@"+ %@", [sharedManager total]] // was %d
                     forState:UIControlStateNormal];
}

- (void)disablePassButton {
    Farkle *sharedManager = [Farkle sharedManager];
	[self.passButton setEnabled:NO];
	[self.passButton setTitle:[NSString stringWithFormat:@"%@", [sharedManager total]] // was %d
                     forState:UIControlStateNormal];
	self.passButton.alpha = .4;
}

#pragma mark Dice

- (void)newDice {
    // was called sixDice
    Farkle *sharedManager = [Farkle sharedManager];
    [sharedManager newDice];
    for (int i = 0; i <= 5; i++) {
        [self flipDiceButtons:i];
        NSLog(@"flipping: %d", i);
    }
}

- (void)rollDice {
    Farkle *sharedManager = [Farkle sharedManager];
    //[self newDice];
    [sharedManager rollDice];
	for (int i = 0; i <= 5; i++) {
		if ([[sharedManager.rolledDice objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setAlpha:.1];
            [[self.diceButtons objectAtIndex:i] setEnabled:NO];
			
		} else {
            [self flipDiceButtons:i];
            NSLog(@"flipping: %d", i);
		}
	}
    //	[self setFarkles: [self farkled]];
}

#pragma mark Actions

- (IBAction)rolled:(id)sender {
    
    Farkle *farkle = [Farkle sharedManager];

	[self rollDice];
    [farkle gameLoop];
	[self updateUI];
}


- (IBAction)selectDice:(UIButton *)sender {
		
	if ([sender isSelected]) {
		[self enableDie:sender];
	} else {
        [self disableDie:sender];
	}
	[self updateUI];
}

- (IBAction)passed:(id)sender {
    Farkle *sharedManager = [Farkle sharedManager];
    
    // [self disablePass];
    [self endTurn]
    
/*
    // decrement turns
    NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] - 1];
    sharedManager.turns = temp;
*/
    ;
    // set passButton to @"0"
    // disable passButton
    // [sharedManager gameLoop:@"passed"];
    
    //[sharedManager gameLoop];
    
    NSLog(@"passed() turns: %@", sharedManager.turns);
}

- (void)enableDie:(UIButton *)sender {
    
    Farkle *sharedManager = [Farkle sharedManager];

    [[sharedManager.rolledDice objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:NO];
	[sender setSelected:NO];
	[sender setAlpha:1];
    // call animation here?
}

- (void)disableDie:(UIButton *)sender {
    
    Farkle *sharedManager = [Farkle sharedManager];
    
    [[sharedManager.rolledDice objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:YES];
	[sender setSelected:YES];
	[UIView animateWithDuration:0.10 animations:^{sender.alpha = 0.4;}];
}

- (void)clearDice {
    Farkle *sharedManager = [Farkle sharedManager];
	[sharedManager.rolledDice removeAllObjects];
	for (int i = 0; i <= 5; i++) {
		[[_diceButtons objectAtIndex:i] setAlpha:1];
		[[self.diceButtons objectAtIndex:i] setEnabled:YES];
		[[self.diceButtons objectAtIndex:i] setSelected:FALSE];
		[[self.diceButtons objectAtIndex:i] setTitle:@""
                                            forState:UIControlStateNormal];
		[[self.diceButtons objectAtIndex:i] setEnabled:NO]; // ???
	}
}


// possbily change this to flip just the labels
- (void)flipDiceButtons:(int)index {
	if (index == 0) {

        [UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromBottom |
         UIViewAnimationOptionAllowUserInteraction animations:^{
         } completion:nil];
        NSLog(@"index: %d", index);
	}
	if (index == 1) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromTop |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
        NSLog(@"index: %d", index);
	}
	if ((index == 2) || (index == 3)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromLeft |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
        NSLog(@"index: %d", index);
	}
	if ((index == 4) || (index == 5)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromRight |
		 UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                        } completion:nil];
        NSLog(@"index: %d", index);
	} else NSLog(@"flipDiceButtons: error %d", index);
}


#pragma mark Roll

- (void)disableRollButton {
	
	[self.rollButton setEnabled:NO];
	[self.rollButton setAlpha:0.0];
    
    //[self.rollButton setEnabled:YES];
	//[self.rollButton setAlpha:1.0];
}

#pragma mark Navigation Bar

- (void)toggleNavBar {
    Farkle *sharedManager = [Farkle sharedManager];
    
    // not working correctly
    if ([sharedManager isNewGame] || [sharedManager isGameOver]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else [self.navigationController setNavigationBarHidden:YES animated:YES];
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


- (void)updateUI {
    
    // old updateUI code
    Farkle *sharedManager = [Farkle sharedManager];
    for (int i = 0; i <= 5; i++) {
        if (![[sharedManager.rolledDice objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setTitle:[[sharedManager.rolledDice objectAtIndex:i] sideUp]
                                        forState:UIControlStateNormal];
            NSLog(@"sideUp: %@", [[sharedManager.rolledDice objectAtIndex:i] sideUp]);
        }
        else if ([[sharedManager.rolledDice objectAtIndex:i] isLocked]) {
			[[sharedManager.rolledDice objectAtIndex:i] setScored:YES];
		}
    NSLog(@"updateUI");
    }
    
    // new code
    [self toggleNavBar];
    
    // change progress bar
    [self.turnsProgress setProgress:((float)([sharedManager.turns integerValue] ) / 10) animated:YES];
    NSLog(@"%f", ((float)[sharedManager.turns integerValue] / 10));
    
}

@end
