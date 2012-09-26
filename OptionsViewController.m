//
//  OptionsViewController.m
//  ZombieEscape
//
//  Created by Jochen on 26.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "OptionsViewController.h"
#import "PlistHandler.h"
#import "NetWorkCom.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController
@synthesize edtIPAddress;

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
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v3.png"]];
}

- (void)viewDidUnload
{
    [self setEdtIPAddress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    edtIPAddress.text = [[PlistHandler getPlistHandler] getServerIPAddress];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)btnReconnectOnClick:(id)sender {
    [[PlistHandler getPlistHandler] setServerIPAddress:edtIPAddress.text];
    [[NetWorkCom getNetWorkCom] reconnect];
    
}
@end
