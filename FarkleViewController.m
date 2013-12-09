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

#define TURNS 12

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
    Farkle *sharedManager = [Farkle sharedManager];
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
    
    
    // change progress bar
    [self.turnsProgress setProgress:((float)([sharedManager.turns integerValue] -1) / 10) animated:YES];
    NSLog(@"%f", ((float)[sharedManager.turns integerValue] / 10));
    
    [self isGameOver];
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

- (IBAction)pass:(id)sender {
    
    [self endTurn];
    
    // debug
    Farkle *sharedManager = [Farkle sharedManager];
    NSLog(@"pass, turns == %@", sharedManager.turns);
}

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
    for (int i = 0; i <= 5; i++) {
        [self flipDiceButtons:i];
    }
}

- (void)rollDice {
    Farkle *sharedManager = [Farkle sharedManager];
    [sharedManager rollDice];
	for (int i = 0; i <= 5; i++) {
		if ([[sharedManager.rolled objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setAlpha:.1];
            [[self.diceButtons objectAtIndex:i] setEnabled:NO];
			
		} else {
            [self flipDiceButtons:i];
		}
	}
    //	[self setFarkles: [self farkled]];
}

- (IBAction)selectDice:(UIButton *)sender {
//    Farkle *sharedManager = [Farkle sharedManager];
	
	if ([sender isSelected]) {
		[self enableDie:sender];
//		self.subtotal = [farkle score:rolled]; // returns an integer for all locked & !scored dice
//		self.subtotal = ([farkle score:rolled] + [self memory]); // this somehow appears to work
        NSLog(@"enable %ld", (long)[sender tag]);
	} else {
        
		[self disableDie:sender];
//		self.subtotal = [farkle score:rolled]; // returns an integer for all locked & !scored dice
//		self.subtotal += self.memory; // memory allows for a persistent total between rolls
        NSLog(@"disable %ld", (long)[sender tag]);
	}
//	self.total = self.subtotal;
//	NSLog(@"subtotal: %d", [self subtotal]);

//	if (self.memory <= 0) {
//		NSLog(@"memory: %d", [self memory]);
//	}
	[self updateUI];
}

- (void)enableDie:(UIButton *)sender {
	[sender setSelected:NO];
	[sender setAlpha:1];
    // call animation here
//	[[rolled objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:NO];
}

- (void)disableDie:(UIButton *)sender {
    
	[sender setSelected:YES];
	[UIView animateWithDuration:0.10 animations:^{sender.alpha = 0.4;}];
    
    // [self diableDie];
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
    Farkle *sharedManager = [Farkle sharedManager];
   
    if ([sharedManager.turns integerValue] == TURNS) {
        // decrement turns by 1
        NSNumber *temp = [NSNumber numberWithInt:[sharedManager.turns intValue] -1];
        sharedManager.turns = temp;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
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


- (void)updateUI {
    NSLog(@"updateUI");
}

@end
