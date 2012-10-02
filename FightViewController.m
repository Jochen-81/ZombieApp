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

@synthesize OpponentTableView;
@synthesize AlliesTableView;

GameOrganizer* gameOrg;
bool gamerStatus;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        gameOrg = [GameOrganizer getGameOrganizer];
    }
    return self;
}



-(void)updateFight:(NSArray*)fightingGamers{
    NSLog(@"UpdateFight");
    
    bool isZombie = ! gameOrg.gamerStatus;
    NSString* name = gameOrg.gamerName;
    
    arrayForAlliesTable = [NSMutableArray array];
    arrayForOpponentsTable =  [NSMutableArray array] ;
    
    for (Socket_Opponent* s in fightingGamers){
        if ( !(s.isZombie ^ isZombie) ){
           if( [s.gamerName compare:name] != 0){
               [arrayForAlliesTable addObject:s];
           }else {
               //TODO eigene HEalth aktualisieren
           }
        }
        else {
            [arrayForOpponentsTable addObject:s];
        }
    }
    
    [OpponentTableView reloadData];
    [AlliesTableView reloadData];
  
    UIAlertView *alert;
    if (gameOrg.gamerStatus == 0)
        alert = [[UIAlertView alloc] initWithTitle:@"Your Turn, choose Opponent" message:@"BRAAAIINNZZZ!!" delegate:self cancelButtonTitle:@"Ready" otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:@"Your Turn, choose Opponent" message:@"Aim for the Head!!" delegate:self cancelButtonTitle:@"Ready" otherButtonTitles:nil];

    [alert show];
}


- (void)viewDidLoad{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v3.png"]];
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear1");
    [OpponentTableView setDelegate:self];
    [AlliesTableView setDelegate:self];
    [OpponentTableView setDataSource:self];
    [AlliesTableView setDataSource:self];
    NSLog(@"viewWillAppear2");
    if(gameOrg.myTurnToAttack)
        [self updateFight:gameOrg.oponentsList];
    [gameOrg setdelegateFightView:self];
    NSLog(@"viewWillAppear3");
    self.navigationItem.hidesBackButton=YES;
    
}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
}


- (void)viewDidUnload{
    [self setOpponentTableView:nil];
    [self setAlliesTableView:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag==11) {
        return arrayForOpponentsTable.count;
    }else {
        return  arrayForAlliesTable.count;  
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellforRow");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc]init];
    Socket_Opponent  *op ;
        
    if (tableView.tag==11) {
        op = [arrayForOpponentsTable objectAtIndex:indexPath.row];
    } else {
        op = [arrayForAlliesTable objectAtIndex:indexPath.row];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = op.gamerName;
    UILabel *healthLabel = (UILabel *)[cell viewWithTag:2];
    NSLog(@"Health : %d",op.health);
    healthLabel.text = [[NSString alloc] initWithFormat:@"%i",op.health];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 11){
        Socket_Opponent *op = [arrayForOpponentsTable objectAtIndex:indexPath.row];
        int randomStrength = arc4random() % 100;
        NSLog(@"Selected to Attack: %@ with strength %d", op.gamerID,randomStrength );
        
        [[GameOrganizer getGameOrganizer] attackGamerWithID:op.gamerID andDamage:randomStrength];   
    }
    else {
        
    }

}



@end
