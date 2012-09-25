//
//  MainMenuCiewControllerViewController.m
//  ZombieEscape
//
//  Created by moco on 25.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "MainMenuCiewControllerViewController.h"

@interface MainMenuCiewControllerViewController ()

@end

@implementation MainMenuCiewControllerViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v1.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
