//
//  RuleCardViewController.m
//  spinninyarn
//
//  Created by Kern Jackson on 12/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "RuleCardViewController.h"

@interface RuleCardViewController ()

@end

@implementation RuleCardViewController

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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
