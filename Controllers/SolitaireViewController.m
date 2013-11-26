//
//  SolitaireViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 11/25/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "SolitaireViewController.h"

@interface SolitaireViewController ()
@property (weak, nonatomic) IBOutlet UIButton *diceButton0;
@property (weak, nonatomic) IBOutlet UIButton *diceButton1;
@property (weak, nonatomic) IBOutlet UIButton *diceButton2;
@property (weak, nonatomic) IBOutlet UIButton *diceButton3;
@property (weak, nonatomic) IBOutlet UIButton *diceButton4;
@property (weak, nonatomic) IBOutlet UIButton *diceButton5;
@end

@implementation SolitaireViewController

#pragma mark setup

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
    
    farkle = [[Farkle alloc] init];
//    NSLog(@"%@", farkle.)
    
    // we don't access Die.h directly, Farkle.h does
    /*
    die = [[Die alloc] init];
   //
    NSLog(@"%lu", (unsigned long)die.sideValue);

    NSLog(@"%lu", (unsigned long)die.sideUp);
    NSLog(@"%lu", (unsigned long)die.single);
    NSLog(@"%lu", (unsigned long)die.triple);
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Madness

- (IBAction)diceButtonTouchUpInside:(id)sender {
    NSLog(@"%@", sender);
    NSLog(@"%ld", (long)[sender tag]);
}

@end
