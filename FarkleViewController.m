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
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)popView {
    // Pop this view off the stack
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Actions

- (IBAction)rolled:(id)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    // need to check the state of newGame, and then change it so that we don't get a crash or a bunch of deactivated controls here
    
	[self rollDice];
    [farkle rolled];
    [self showDice];
    
    //[farkle gameLoop];
	[self updateUI];
}

// change the name of this to toggleDie...
- (IBAction)selectDice:(UIButton *)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    if ([sender isSelected]) {
		[self enableDie:sender];
	} else {
        [self disableDie:sender];
	}
    //[farkle gameLoop];
    [farkle toggleDie];
	[self updateUI];
}

- (IBAction)passed:(id)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    [farkle passed];
    
    NSLog(@"turns: %@", farkle.turns);
    
    //[self clearDice];
    [self updateUI];
}

// Don't really like this method name
- (IBAction)startedNewGame:(id)sender {
    
	[self.HUD setTitle:[NSString stringWithFormat:@"new game"]
              forState:UIControlStateNormal];
	[self newGame];
}

#pragma mark not sure if controller or model

- (void)newGame {
    Farkle *farkle = [Farkle sharedManager];
    
	[self.HUD setEnabled:NO];
	[self.HUD setTitle:[NSString stringWithFormat:@""]
              forState:UIControlStateNormal];
    [self.rollButton setSelected:NO];
	[self.rollButton setEnabled:YES];
	[self clearScreen];
	self.scoreLabel.textColor = [UIColor blackColor];
	[self clearDice];
    
    [farkle newGame];
    
	[self updateUI]; // hotDice causes a crash because there is nothing in the array
}

#pragma mark Pass

- (void)enablePassButton {
	[self.passButton setEnabled:YES];
	[self.passButton setAlpha:1.0];
    [self.passButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void)disablePassButton {
	[self.passButton setEnabled:NO];
    [self.passButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	self.passButton.alpha = .4;
}

- (IBAction)pressedButton:(id)sender {
    [UIView transitionWithView:sender
                      duration:0.2
                       options:
     UIViewAnimationOptionAllowUserInteraction animations:^{
         [self.passButton setTransform:CGAffineTransformMakeScale(0.95, 0.95  )];
     } completion:nil];

}

- (IBAction)releasedButton:(id)sender {
    [UIView transitionWithView:sender
                      duration:0.2
                       options:
     UIViewAnimationOptionAllowUserInteraction animations:^{
         [self.passButton setTransform:CGAffineTransformMakeScale(1.0, 1.0  )];
     } completion:nil];
    
}

#pragma mark Dice

- (void)newDice {
    Farkle *farkle = [Farkle sharedManager];
    [farkle newDice];
    for (int i = 0; i <= 5; i++) {
        [self flipDiceButtons:i];
    }
}

- (void)rollDice {
    Farkle *farkle = [Farkle sharedManager];
    [farkle rollDice];
	for (int i = 0; i <= 5; i++) {
		if ([[farkle.dice objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setAlpha:.1];
            [[self.diceButtons objectAtIndex:i] setEnabled:NO];
			
		} else [self flipDiceButtons:i];
	}
}

- (void)enableDie:(UIButton *)sender {
    
    Farkle *farkle = [Farkle sharedManager];

    [[farkle.dice objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:NO];
	[sender setSelected:NO];
	[sender setAlpha:1];
    // call animation here?
}

- (void)disableDie:(UIButton *)sender {
    
    Farkle *farkle = [Farkle sharedManager];
    
    [[farkle.dice objectAtIndex:[self.diceButtons indexOfObject:sender]] setLocked:YES];
	[sender setSelected:YES];
	[UIView animateWithDuration:0.10 animations:^{sender.alpha = 0.4;}];
}

- (void)hideDice {
    
	for (int i = 0; i <= 5; i++) {
		[[_diceButtons objectAtIndex:i] setAlpha:0.0];
		[[self.diceButtons objectAtIndex:i] setEnabled:NO];
		[[self.diceButtons objectAtIndex:i] setSelected:NO];
		//[[self.diceButtons objectAtIndex:i] setTitle:@""
        //                                    forState:UIControlStateNormal];
	}
}

- (void)disableDice {
    for (int i = 0; i <= 5; i++) {
		[[_diceButtons objectAtIndex:i] setAlpha:.1];
		[[self.diceButtons objectAtIndex:i] setEnabled:NO];
		[[self.diceButtons objectAtIndex:i] setSelected:YES];
    }
}


- (void)showDice {
    Farkle *farkle = [Farkle sharedManager];
	for (int i = 0; i <= 5; i++) {
        if (![[farkle.dice objectAtIndex:i] isLocked]) {
            [[_diceButtons objectAtIndex:i] setAlpha:1];
            [[self.diceButtons objectAtIndex:i] setEnabled:YES];
            [[self.diceButtons objectAtIndex:i] setSelected:NO];
            [[self.diceButtons objectAtIndex:i] setTitle:@"s"
                                                forState:UIControlStateNormal];
        }
	}
}

- (void)clearDice {
    
	for (int i = 0; i <= 5; i++) {
		[[_diceButtons objectAtIndex:i] setAlpha:1];
		[[self.diceButtons objectAtIndex:i] setEnabled:NO];
		[[self.diceButtons objectAtIndex:i] setSelected:NO];
		[[self.diceButtons objectAtIndex:i] setTitle:@"c"
                                            forState:UIControlStateNormal];
		[[self.diceButtons objectAtIndex:i] setEnabled:NO]; // ???
	}
    
}

// replace this with 3d cubes behind, etc...
- (void)flipDiceButtons:(int)index {
	if (index == 0) {
        [UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromBottom |
         UIViewAnimationOptionAllowUserInteraction animations:^{
         } completion:nil];
	}
	if (index == 1) {
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromTop |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
	}
	if ((index == 2) || (index == 3)) {
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromLeft |
		 UIViewAnimationOptionAllowUserInteraction animations:^{
		 } completion:nil];
	}
	if ((index == 4) || (index == 5)) {
		
		[UIView transitionWithView:[self.diceButtons objectAtIndex:index]
                          duration:0.25
                           options:UIViewAnimationOptionTransitionFlipFromRight |
		 UIViewAnimationOptionAllowUserInteraction
                        animations:^{
                        } completion:nil];
	} else NSLog(@"flipDiceButtons: error %d", index);
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


- (IBAction)pressedRollButton:(id)sender {
    [UIView transitionWithView:sender
                      duration:0.2
                       options:
     UIViewAnimationOptionAllowUserInteraction animations:^{
         [self.rollButton setTransform:CGAffineTransformMakeScale(0.95, 0.95  )];
     } completion:nil];
    
}

- (IBAction)releasedRollButton:(id)sender {
    [UIView transitionWithView:sender
                      duration:0.2
                       options:
     UIViewAnimationOptionAllowUserInteraction animations:^{
         [self.rollButton setTransform:CGAffineTransformMakeScale(1.0, 1.0  )];
     } completion:nil];
    
}

#pragma mark HUD

- (void)flashScreen {
	[UIView animateWithDuration:0.4
                          delay:0.2 // otherwise we will see disabled die flip
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
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
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.HUD.backgroundColor = [UIColor redColor];
                         self.HUD.alpha = 1.0;
                         // self.HUD.tintColor = [UIColor whiteColor];
                         self.scoreLabel.textColor = [UIColor blackColor];
                     }
                     completion:nil];
}

- (void)gameOver {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
	[self.rollButton setEnabled:NO];
	[self.HUD setTitle:[NSString stringWithFormat:@"game over"]
              forState:UIControlStateNormal];
	[self deathScreen];
	// prevent the user from clicking the HUD for 1.6 seconds
	[NSTimer scheduledTimerWithTimeInterval:1.6
                                     target:self
                                   selector:@selector(enableHUD:)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)enableHUD:(id)sender {
	[self.HUD setEnabled:YES];
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
        if (![[farkle.dice objectAtIndex:i] isLocked]) {
            [[self.diceButtons objectAtIndex:i] setTitle:[[farkle.dice objectAtIndex:i] sideUp]
                                                forState:UIControlStateNormal];
        }
    }

    if ([farkle didFarkle]) {
        [self disableDice];
        [self flashScreen];
    }
    
    // is Game Over?
    if ([farkle isGameOver]) {
        
 //       [self hideDice];
        [self gameOver];
    }

    [self togglePassButton];
//    [self toggleRollButton];

    NSLog(@"%hhd", [farkle canRoll]);

    //[self toggleNavBar]; // we want to do this after the deathScreen Animation fires
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@", [farkle scoreTitle]]];
    
    [self.passButton setTitle:[NSString stringWithFormat:@"%@", [farkle passTitle]] forState:UIControlStateNormal];
    [self.passButton setTitle:[NSString stringWithFormat:@"%@", [farkle passTitle]] forState:UIControlStateDisabled];

    [self.turnsProgress setProgress:((float)([farkle.turns integerValue] ) / 10) animated:YES];
}

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

@end
