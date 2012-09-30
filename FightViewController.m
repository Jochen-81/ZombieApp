//
//  FightViewController.m
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "FightViewController.h"
#import "Socket_Opponent.h"
#include <stdlib.h>
#import "GameOrganizer.h"


@interface FightViewController ()

@end

@implementation FightViewController

@synthesize opponentList=_opponentList;

bool fightOver;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        fightOver=false;
    }
    return self;
}



-(void)updateFight:(NSArray*)oponents{
    _opponentList = oponents;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v3.png"]];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    if(_opponentList==nil)
        return 0;
    else 
        return _opponentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(_opponentList==nil){
        return cell;
    }else {
        Socket_Opponent  *op = [self.opponentList objectAtIndex:indexPath.row];
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
        nameLabel.text = op.gamerName;
        UILabel *healthLabel = (UILabel *)[cell viewWithTag:2];
        healthLabel.text = [[NSString alloc] initWithFormat:@"%d",op.health];
    }
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Socket_Opponent *op = [self.opponentList objectAtIndex:indexPath.row];
    int randomStrength = arc4random() % 100;
    NSLog(@"Selected to Attack: %@ with strength %d", op.gamerName,randomStrength );
    
    [[GameOrganizer getGameOrganizer] attackGamerWithID:op.gamerName andDamage:randomStrength];   

}



@end
