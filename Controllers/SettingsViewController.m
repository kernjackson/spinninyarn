//
//  SettingsViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 11/25/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    BOOL penalty;
    BOOL minimum;
    BOOL hotdice;
    BOOL stealing;
    
    NSNumber *playTo;
    NSNumber *minimumScore;
    NSNumber *difficulty;
}

@property (weak, nonatomic) IBOutlet UISwitch *penaltySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hotDiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *minimumScoreSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stealingSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *playToSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *minimumSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegment;
@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
/*
    if (![defaults objectForKey:@"firstRun"])
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
    [NSUserDefaults standardUserDefaults];
 */
    penalty = [defaults boolForKey:@"penalty"];
    minimum = [defaults boolForKey:@"minimum"];
    stealing = [defaults boolForKey:@"stealing"];
    hotdice = [defaults boolForKey:@"hotdice"];
    
    playTo = [defaults objectForKey:@"playTo"];
    minimumScore = [defaults objectForKey:@"minimumScore"];
    difficulty = [defaults objectForKey:@"difficulty"];
/*
    if([defaults objectForKey:@"firstRun"])
    {
        [self factoryDefaults];
    }
 */
    [self updateControls];
}
/*
- (void)viewDidAppear:(BOOL)animated
{
    [self updateControls];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Switches

- (IBAction)penaltySwitched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (penalty) {
        penalty = NO;
        [defaults setBool:penalty forKey:@"penalty"];
        NSLog(@"penalty to FALSE");
    } else {
        penalty = YES;
        [defaults setBool:penalty forKey:@"penalty"];
        NSLog(@"penalty to TRUE");
    }
}

- (IBAction)hotDiceSwitched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (hotdice) {
        hotdice = NO;
        [defaults setBool:hotdice forKey:@"hotdice"];
        NSLog(@"hotdice to FALSE");
    } else {
        hotdice = YES;
        [defaults setBool:hotdice forKey:@"hotdice"];
        NSLog(@"hotdice to TRUE");
    }
}

- (IBAction)minimumScoreSwitched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (minimum) {
        minimum = NO;
        [defaults setBool:minimum forKey:@"minimum"];
        NSLog(@"minimum to FALSE");
    } else {
        minimum = YES;
        [defaults setBool:minimum forKey:@"minimum"];
        NSLog(@"minimum to TRUE");
    }
}


- (IBAction)stealingSwitched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (stealing) {
        stealing = NO;
        [defaults setBool:stealing forKey:@"stealing"];
        NSLog(@"stealing to FALSE");
    } else {
        stealing = YES;
        [defaults setBool:stealing forKey:@"stealing"];
        NSLog(@"stealing to TRUE");
    }
}

#pragma mark Segments

- (IBAction)playToSegmentChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (self.playToSegment.selectedSegmentIndex) {
        case 0:
            playTo = @0;
            break;
        case 1:
            playTo = @1;
            break;
        case 2:
            playTo = @2;
            break;
        default:
            break;
    }
    NSLog(@"playTo: %@",playTo);
    [defaults setValue:playTo forKey:@"playTo"];
}

- (IBAction)minimumScoreSegmentChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (self.minimumSegment.selectedSegmentIndex) {
        case 0:
            minimumScore = @0;
            break;
        case 1:
            minimumScore = @1;
            break;
        case 2:
            minimumScore = @2;
            break;
        case 3:
            minimumScore = @3;
            break;
        default:
            break;
    }
    NSLog(@"minimumScore: %@",minimumScore);
    [defaults setValue:minimumScore forKey:@"minimumScore"];
}

- (IBAction)difficultySegmentChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (self.difficultySegment.selectedSegmentIndex) {
        case 0:
            difficulty = @0;
            break;
        case 1:
            difficulty = @1;
            break;
        case 2:
            difficulty = @2;
            break;
        default:
            break;
    }
    NSLog(@"diffculty: %@",difficulty);
    [defaults setValue:difficulty forKey:@"difficulty"];
}

#pragma mark UpdateSettings

- (IBAction)ClearSettings:(id)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Reset to Defaults"
                                                    otherButtonTitles:nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self factoryDefaults];
        [self updateControls];
    }
 }

- (void)factoryDefaults {
    // reset all settings to factory default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    penalty = NO;
    minimum = YES;
    hotdice = YES;
    stealing = YES;
    
    playTo = @2;
    minimumScore = @1;
    difficulty = @1;
    
    [defaults setBool:penalty forKey:@"penalty"];
    [defaults setBool:minimum forKey:@"minimum"];
    [defaults setBool:hotdice forKey:@"hotdice"];
    [defaults setBool:stealing forKey:@"stealing"];
    
    [defaults setObject:playTo forKey:@"playTo"];
    [defaults setObject:minimumScore forKey:@"minimumScore"];
    [defaults setObject:difficulty forKey:@"difficulty"];
}

- (void)updateControls {
    
    // Switches
    
    if (penalty) {
        [self.penaltySwitch setOn:YES animated:YES];
        NSLog(@"penalty is TRUE");
    } else {
        [self.penaltySwitch setOn:NO animated:YES];
        NSLog(@"penalty is FALSE");
    }
    
    if (minimum) {
        [self.minimumScoreSwitch setOn:YES animated:YES];
        NSLog(@"minimum is TRUE");
    } else {
        [self.minimumScoreSwitch setOn:NO animated:YES];
        NSLog(@"minimum is FALSE");
    }
    
    if (hotdice) {
        [self.hotDiceSwitch setOn:YES animated:YES];
        NSLog(@"hotdice is TRUE");
    } else {
        [self.hotDiceSwitch setOn:NO animated:YES];
        NSLog(@"hotdice is FALSE");
    }

    if (stealing) {
        [self.stealingSwitch setOn:YES animated:YES];
        NSLog(@"stealing is TRUE");
    } else {
        [self.stealingSwitch setOn:NO animated:YES];
        NSLog(@"stealing is FALSE");
    }
    
    // Segments
    
    // playTo
    self.playToSegment.selectedSegmentIndex = [playTo integerValue];
    if ([playTo isEqual:@0])
    {
        self.playToSegment.selectedSegmentIndex = 0;
    }
    if ([playTo isEqual:@1])
    {
        self.playToSegment.selectedSegmentIndex = 1;
    }
    if ([playTo isEqual:@2])
    {
        self.playToSegment.selectedSegmentIndex = 2;
    } else NSLog(@"playTo: %@",playTo);
    
    // minimumScore
    self.minimumSegment.selectedSegmentIndex = [minimumScore integerValue];
    if ([minimumScore isEqual:@0])
    {
        self.minimumSegment.selectedSegmentIndex = 0;
    }
    if ([minimumScore isEqual:@1])
    {
        self.minimumSegment.selectedSegmentIndex = 1;
    }
    if ([minimumScore isEqual:@2])
    {
        self.minimumSegment.selectedSegmentIndex = 2;
    }
    if ([minimumScore isEqual:@3])
    {
        self.minimumSegment.selectedSegmentIndex = 3;
    }else NSLog(@"minimumScore: %@",minimumScore);
    
    // difficulty
    self.difficultySegment.selectedSegmentIndex = [difficulty integerValue];
    if ([difficulty isEqual:@0])
    {
        self.difficultySegment.selectedSegmentIndex = 0;
    }
    if ([difficulty isEqual:@1])
    {
        self.difficultySegment.selectedSegmentIndex = 1;
    }
    if ([difficulty isEqual:@2])
    {
        self.difficultySegment.selectedSegmentIndex = 2;
    } else NSLog(@"difficulty: %@",difficulty);
 
}

@end
