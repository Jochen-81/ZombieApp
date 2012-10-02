//
//  FightViewController.h
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FightViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayForOpponentsTable;
    NSMutableArray *arrayForAlliesTable;
}

@property (strong, nonatomic) IBOutlet UITableView *OpponentTableView;
@property (strong, nonatomic) IBOutlet UITableView *AlliesTableView;

-(void)updateFight:(NSArray*)fightingGamers;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end
