//
//  FarkleViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 12/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "FarkleViewController.h"
#import "Farkle.h"
#import "Settings.h"

@interface FarkleViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *diceButtons;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self updateUI];
	// Do any additional setup after loading the view.

//    farkle.total = @1;
    
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

#pragma mark Actions

- (IBAction)rolled:(id)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    // need to check the state of newGame, and then change it so that we don't get a crash or a bunch of deactivated controls here
    
	[self rollDice];
    [farkle gameLoop];
	[self updateUI];
}


- (IBAction)selectDice:(UIButton *)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    if ([sender isSelected]) {
		[self enableDie:sender];
	} else {
        [self disableDie:sender];
	}
    [farkle gameLoop];
	[self updateUI];
}

- (IBAction)passed:(id)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    [self disablePassButton];
    // possible way to move more to the model
    //farkle.canPass = NO;
    // not sure where else to put this logic. Is it possible or even recommended to put it in the model?
    farkle.scoredPoints += farkle.lockedPoints;
    farkle.lockedPoints = 0;
    
    [self endTurn]
    
    /*
     // decrement turns
     NSNumber *temp = [NSNumber numberWithInt:[farkle.turns intValue] - 1];
     farkle.turns = temp;
     */
    ;
    // set passButton to @"0"
    // disable passButton
    // [farkle gameLoop:@"passed"];
    
    //[farkle gameLoop];
    
    NSLog(@"turns: %@", farkle.turns);
}

#pragma mark not sure if controller or model

- (void)newGame {
    Farkle *farkle = [Farkle sharedManager];
    //farkle.turns = @TURNS;
//    [self.turnsProgress setProgress:1.0 animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)endTurn {
    Farkle *farkle = [Farkle sharedManager];
    
    // [Farkle score:rolled] here
    
    // decrement turns by 1
    NSNumber *temp = [NSNumber numberWithInt:[farkle.turns intValue] -1];
    farkle.turns = temp;
    
    [farkle gameLoop];
    [self updateUI];
}

- (void)farkled {
    Farkle *farkle = [Farkle sharedManager];
    
    // Farkle.m will return 0 if player farkles
    
    // decrement turns by 1
    NSNumber *temp = [NSNumber numberWithInt:[farkle.turns intValue] -1];
    farkle.turns = temp;
}

- (void)didWin {
    // is score > 10,000?
}
/*
- (void)isGameOver {
    Farkle *farkle = [Farkle sharedManager];
    if (([farkle.turns integerValue] < TURNS) &&
        ([farkle.turns integerValue] > 0)) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        // game over
        [self newGame];
    }
}
*/
#pragma mark Pass



- (void)enablePassButton {
    Farkle *farkle = [Farkle sharedManager];
	[self.passButton setEnabled:YES];
	[self.passButton setAlpha:1.0];
    [self.passButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//	[self.passButton setTitle:[NSString stringWithFormat:@"+ %ld", (long)[farkle totalPoints]] // was %d
 //                    forState:UIControlStateNormal];
 //   NSLog(@"+ %ld", (long)[farkle totalPoints]);
}

- (void)disablePassButton {
    Farkle *farkle = [Farkle sharedManager];
	[self.passButton setEnabled:NO];
    [self.passButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//	[self.passButton setTitle:[NSString stringWithFormat:@"%ld", (long)[farkle totalPoints]] // was %d
//                     forState:UIControlStateNormal];
	self.passButton.alpha = .4;
//    NSLog(@"%ld", (long)[farkle totalPoints]);
}

#pragma mark Dice

- (void)newDice {
    // was called sixDice
    Farkle *farkle = [Farkle sharedManager];
    [farkle newDice];
    for (int i = 0; i <= 5; i++) {
        [self flipDiceButtons:i];
        //        NSLog(@"flipping: %d", i);
    }
}

- (void)rollDice {
    Farkle *farkle = [Farkle sharedManager];
    //[self newDice];
    [farkle rollDice];
	for (int i = 0; i <= 5; i++) {
		if ([[farkle.rolledDice objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setAlpha:.1];
            [[self.diceButtons objectAtIndex:i] setEnabled:NO];
			
		} else {
            [self flipDiceButtons:i];
            //            NSLog(@"flipping: %d", i);
		}
	}
    //	[self setFarkles: [self farkled]];
}

- (void)enableDie:(UIButton *)sender {
    
    Farkle *farkle = [Farkle sharedManager];

    [[farkle.rolledDice objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:NO];
	[sender setSelected:NO];
	[sender setAlpha:1];
    // call animation here?
}

- (void)disableDie:(UIButton *)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    [[farkle.rolledDice objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:YES];
	[sender setSelected:YES];
	[UIView animateWithDuration:0.10 animations:^{sender.alpha = 0.4;}];
}

- (void)clearDice {
    Farkle *farkle = [Farkle sharedManager];
	[farkle.rolledDice removeAllObjects];
	for (int i = 0; i <= 5; i++) {
		[[_diceButtons objectAtIndex:i] setAlpha:1];
		[[self.diceButtons objectAtIndex:i] setEnabled:YES];
		[[self.diceButtons objectAtIndex:i] setSelected:FALSE];
		[[self.diceButtons objectAtIndex:i] setTitle:@""
                                            forState:UIControlStateNormal];
		[[self.diceButtons objectAtIndex:i] setEnabled:NO]; // ???
	}
}


// possbily change this to flip just the labels. This should probably be a switch statement, but I plan on eventually replacing this anyway. Either flip just the labels, replace it with 3d cubes behind, etc...
- (void)flipDiceButtons:(int)index {
	if (index == 0) {

        [UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromBottom |
         UIViewAnimationOptionAllowUserInteraction animations:^{
         } completion:nil];
        //NSLog(@"index: %d", index);
	}
	if (index == 1) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromTop |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
        //NSLog(@"index: %d", index);
	}
	if ((index == 2) || (index == 3)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromLeft |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
        //NSLog(@"index: %d", index);
	}
	if ((index == 4) || (index == 5)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromRight |
		 UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                        } completion:nil];
        //NSLog(@"index: %d", index);
	} //else NSLog(@"flipDiceButtons: error %d", index);
}

#pragma mark Roll

- (void)disableRollButton {
	
	[self.rollButton setEnabled:NO];
	[self.rollButton setAlpha:0.0];
}

- (void)enableRollButton {
	
	[self.rollButton setEnabled:YES];
	[self.rollButton setAlpha:1.0];
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

- (void)clearScreen {
	[UIView animateWithDuration:0.6
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut |
	 UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.HUD.backgroundColor = [UIColor whiteColor];
                         self.HUD.alpha = 0.0;
                         //		 [self.HUD setTitle:[NSString stringWithFormat:@""]
                         //							 forState:UIControlStateNormal];
                     }
                     completion:nil];
}

- (void)deathScreen {
	[UIView animateWithDuration:1.6
                          delay:0.6
                        options: UIViewAnimationOptionCurveEaseIn |
     UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.HUD.backgroundColor = [UIColor redColor];
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
    
    Farkle *farkle = [Farkle sharedManager];
    
    // update Dice
    for (int i = 0; i <= 5; i++) {
        if (![[farkle.rolledDice objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setTitle:[[farkle.rolledDice objectAtIndex:i] sideUp]
                                                forState:UIControlStateNormal];
        }
        else if ([[farkle.rolledDice objectAtIndex:i] isLocked]) {
			[[farkle.rolledDice objectAtIndex:i] setScored:YES];
		}
    }

    // update progress bar with number of turns left
    [self.turnsProgress setProgress:((float)([farkle.turns integerValue] ) / 10) animated:YES];
    
    // toggle NavBar
    if ([farkle isNewGame] || [farkle isGameOver]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else [self.navigationController setNavigationBarHidden:YES animated:YES];

    // toggle PassButton
    if ([farkle canPass]) {
        [self enablePassButton];
    } else [self disablePassButton];

    // toggle RollButton, is this backwards?
    if (([farkle canRoll]) ||
        ([farkle isNewGame]))  {
        [self enableRollButton];
    } else [self disableRollButton];
    
    // is it a new game?
    if ([farkle isNewGame]) {
        [self clearScreen];
    }
    // is Game Over?
    if ([farkle isGameOver]) {
        [self deathScreen];
    }
    
    //  update scoreLabel with scoredPoints
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld", (long)[farkle scoredPoints]]];
    
    // update passButton with lockedPoints. Doesn't this label need to be both locked and scored?
    [self.passButton setTitle:[NSString stringWithFormat:@"%ld", (long)[farkle lockedPoints]] forState:UIControlStateNormal];
    
    
}
/*
#pragma mark Toggle Controls

- (void)toggleNavBar {
    Farkle *farkle = [Farkle sharedManager];
    
    // not working correctly
    if ([farkle isNewGame] || [farkle isGameOver]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)togglePassButton {
    
    Farkle *farkle = [Farkle sharedManager];
    
    if ([farkle canPass]) {
        [self enablePassButton];
    } else [self disablePassButton];
}

- (void)toggleRollButton {
    
    Farkle *farkle = [Farkle sharedManager];
    
    if (![farkle canRoll]) {
        [self disableRollButton];
    } else [self enableRollButton];
}
*/
@end
