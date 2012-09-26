//
//  OptionsViewController.h
//  ZombieEscape
//
//  Created by Jochen on 26.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *edtIPAddress;
- (IBAction)btnReconnectOnClick:(id)sender;

@end
