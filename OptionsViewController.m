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
@synthesize sgNetworkConnection;
@synthesize edtIPAddress;
@synthesize txtConnecting;

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
    [self setSgNetworkConnection:nil];
    [self setTxtConnecting:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    edtIPAddress.text = [[PlistHandler getPlistHandler] getServerIPAddress];
    [self setSelectionAccordingToNetworkStatus];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)btnReconnectOnClick:(id)sender {
    [[PlistHandler getPlistHandler] setServerIPAddress:edtIPAddress.text];
    [[NetWorkCom getNetWorkCom] reconnect];
    
}

- (IBAction)sgNetworkConnectionValueChanged:(id)sender {
    if(sgNetworkConnection.selectedSegmentIndex == UISegmentedControlNoSegment || onlySwitchSegment){
        return;
    } else if(sgNetworkConnection.selectedSegmentIndex == 0){ //"Connected" is pressed
        sgNetworkConnection.selectedSegmentIndex = UISegmentedControlNoSegment;
        txtConnecting.hidden = NO;
        [self.view setNeedsDisplay];	
        [[NetWorkCom getNetWorkCom] reconnect];
        [self startMyTimer:self];
    } else if(sgNetworkConnection.selectedSegmentIndex == 1){ //"Unconnected" is pressed
        [[NetWorkCom getNetWorkCom] closeConnection];
        [self setSelectionAccordingToNetworkStatus];
        [self stopMyTimer:self];
    }
}

BOOL onlySwitchSegment = NO;
-(void) setSelectionAccordingToNetworkStatus: (NSTimer *)theTimer{
    return [self setSelectionAccordingToNetworkStatus];
}


-(void) setSelectionAccordingToNetworkStatus{
    onlySwitchSegment = YES;
    txtConnecting.hidden = YES;
    if([[NetWorkCom getNetWorkCom] isConnected]){
        sgNetworkConnection.selectedSegmentIndex = 0;
    } else {
        sgNetworkConnection.selectedSegmentIndex = 1;
    }
    onlySwitchSegment = NO;
}


- (IBAction)startMyTimer:(id)sender
{
    [myTimer invalidate];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 5 target:self selector:
               @selector(setSelectionAccordingToNetworkStatus:) userInfo:nil repeats:YES];
    
            
}

- (IBAction)stopMyTimer:(id)sender
{
    [myTimer invalidate];
    myTimer = nil;
}

@end
