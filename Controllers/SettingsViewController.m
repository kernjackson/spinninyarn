//
//  SettingsViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 11/25/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *MultiplayerStealingSwitch;

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
    stealing = [defaults boolForKey:@"stealing"];
//    [defaults setBool:stealing forKey:@"stealing"];
    [self checkSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIControls

- (IBAction)MultiplayerStealingSwitched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (stealing) {
        stealing = NO;
        [defaults setBool:stealing forKey:@"stealing"];
        NSLog(@"Switched to FALSE");
    } else {
        stealing = YES;
        [defaults setBool:stealing forKey:@"stealing"];
        NSLog(@"Switched to TRUE");
    }
}

- (void)checkSettings {
    if (stealing) {
        [self.MultiplayerStealingSwitch setOn:YES animated:YES];
        NSLog(@"checkSettings: TRUE");
    } else {
        [self.MultiplayerStealingSwitch setOn:NO animated:YES];
        NSLog(@"checkSettings: FALSE");
    }
}

@end
