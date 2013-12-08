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
    NSLog(@"%@", farkle);
    
    
    // Setup gesture recoginizer, and pop this view off the stack
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(popView)];
    
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
}

#pragma mark HideNavigationBar

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popView {
    // Pop this view off the stack
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Button Madness

- (IBAction)diceButtonTouchUpInside:(id)sender {
    NSLog(@"%@", sender);
    NSLog(@"%ld", (long)[sender tag]);
}

@end
