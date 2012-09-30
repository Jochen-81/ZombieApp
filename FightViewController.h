//
//  FightViewController.h
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FightViewController : UITableViewController

@property NSArray* opponentList;

-(void)updateFight:(NSArray*)oponents;

@end
