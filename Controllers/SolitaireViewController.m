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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
