//
//  OptionsViewController.h
//  ZombieEscape
//
//  Created by Jochen on 26.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController{
    NSTimer *myTimer;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *sgNetworkConnection;
@property (weak, nonatomic) IBOutlet UITextField *edtIPAddress;
@property (weak, nonatomic) IBOutlet UILabel *txtConnecting;
- (IBAction)btnReconnectOnClick:(id)sender;
- (IBAction)sgNetworkConnectionValueChanged:(id)sender;

- (IBAction)startMyTimer:(id)sender;
- (IBAction)stopMyTimer:(id)sender;

@end
