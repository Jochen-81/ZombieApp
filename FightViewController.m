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

GameOrganizer* gameOrg;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}



-(void)updateFight:(NSArray*)opponents{
    _opponentList = opponents;
    [self.tableView reloadData];
  
    UIAlertView *alert;
    if (gameOrg.gamerStatus == 0)
        alert = [[UIAlertView alloc] initWithTitle:@"Your Turn, choose Opponent" message:@"BRAAAIINNZZZ!!" delegate:self cancelButtonTitle:@"Ready" otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:@"Your Turn, choose Opponent" message:@"Aim for the Head!!" delegate:self cancelButtonTitle:@"Ready" otherButtonTitles:nil];

    [alert show];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v3.png"]];
}


-(void)viewWillAppear:(BOOL)animated{
    gameOrg = [GameOrganizer getGameOrganizer];
    [gameOrg setdelegateFightView:self];
    if(gameOrg.inFight)
    _opponentList=  gameOrg.oponentsList;
    self.navigationItem.hidesBackButton=YES;
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
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
    if(_opponentList==nil)
        return 0;
    else 
        return _opponentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Socket_Opponent  *op = [self.opponentList objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = op.gamerName;
    UILabel *healthLabel = (UILabel *)[cell viewWithTag:2];
    NSLog(@"Health : %d",op.health);
    healthLabel.text = [[NSString alloc] initWithFormat:@"%i",op.health];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Socket_Opponent *op = [self.opponentList objectAtIndex:indexPath.row];
    int randomStrength = arc4random() % 100;
    NSLog(@"Selected to Attack: %@ with strength %d", op.gamerID,randomStrength );
    
    [[GameOrganizer getGameOrganizer] attackGamerWithID:op.gamerID andDamage:randomStrength];   
}



@end
