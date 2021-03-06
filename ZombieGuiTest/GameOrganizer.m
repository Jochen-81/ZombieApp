//
//  GameOrganizer.m
//  ZombieEscape
//
//  Created by HTWdS User on 23.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "GameOrganizer.h"
#import "SBJsonParser.h"
#import "PlayerLocation.h"
#import "PlistHandler.h"
#import "Socket_Opponent.h"



@implementation GameOrganizer

@synthesize gamerName = _gamerName;
@synthesize gamerStatus = _gamerStatus;
@synthesize GameID =_GameID;
@synthesize oponentsList= _oponentsList;
@synthesize inFight =_inFight;
volatile bool inGame ;
NSMutableArray * gamerList;
NSLock *myLock = nil;
@synthesize myTurnToAttack= _myTurnToAttack;

NetWorkCom* netCom;
MapViewController* delegateMapView;
FightViewController* delegateFightView;

+ (id)getGameOrganizer {
    static GameOrganizer *gameOrg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameOrg = [[self alloc] init];
        
    });
    return gameOrg;
}

- (id)init{
    if (self = [super init]) {
        gamerList = [[NSMutableArray alloc] initWithCapacity:1];
        bool myTurnToAttack=false;
    }
    return self;
}


-(void)stopSendingMyLocation{
    inGame =false;
}

-(void)startSendingMyLocation{
     inGame=true;
 }

-(void)saveGameStatusAndStop{
    [netCom removePlayer];
    [netCom closeConnection];
    [netCom StopReadingInputStream];
    [[PlistHandler getPlistHandler] setGameID:_GameID];
    [[PlistHandler getPlistHandler] setGamerStatus: self.gamerStatus ];
    [self stopSendingMyLocation];
}

-(void)loadGameStatusAndRun{
    PlistHandler *plist =[PlistHandler getPlistHandler] ;
    [netCom reconnect];
    [netCom createNewPlayer:[plist getUsername]];
    int gameID = [plist getGameID];
    if( gameID != 0 ){
        [netCom addPlayerToGame:gameID withState:self.gamerStatus+1 ];
        [netCom startReadingInputStream];
        [self startSendingMyLocation];
    }
}

-(void)gamerLeavesGame{
    [netCom removePlayer];
    _GameID = 0;
}

-(void)updateMyLocation:(CLLocation*)newLocation{
    if(inGame){
        [netCom setLocation:[[GPSLocation alloc]initWithLong:[newLocation coordinate].longitude AndLat:[newLocation coordinate].latitude ]];
        [delegateMapView centerMapOnLocation:newLocation];
    }
}

-(void)startWithDelegate:(MapViewController*)cont{
    netCom =[NetWorkCom getNetWorkCom] ;
    if(cont!=nil){
        [self setdelegateMapView:cont];
    }
    [self startSendingMyLocation];
    [netCom startReadingInputStream];
    [ netCom setDelegate:self];
}


-(void) setdelegateMapView:(MapViewController*)viewController{
    delegateMapView = viewController;
}
-(void) setdelegateFightView:(FightViewController*)viewController{
    delegateFightView = viewController;
}

-(void)handleInputFromNetwork:(NSString*)stream{
   
    NSLog(@"handleInputFromNetwork %@", [NSThread currentThread]);
    
    [myLock lock];
    // Create SBJSON object to parse JSON
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [parser objectWithString:stream];
   
    NSMutableArray* deletionArray = [[NSMutableArray alloc] initWithArray: gamerList]; // clone gameList , everyone is know up for deletion
    
  //  NSLog(@"Von Server : %@",[dic description]);
    NSString* commandString = [ dic objectForKey:@"command"];
    NSMutableArray* gamerLocations = [[NSMutableArray alloc] initWithCapacity:1];
    
    if ([commandString compare:@"listGamers"] ==0 && !_inFight){
        
        NSArray* gamerDescription = [dic valueForKey:@"value"];
        
        for (NSDictionary* dictionary in gamerDescription ){
            CLLocationCoordinate2D location = [[[CLLocation alloc] init ] coordinate];
                        
            double longi = [[dictionary valueForKey:@"longitude"]doubleValue ];
            double lat = [[dictionary valueForKey:@"latitude"]doubleValue ];
            location.longitude = longi ;
            location.latitude =lat;
            NSString* gamerName =[dictionary valueForKey:@"gamername"];
            
            if( [deletionArray containsObject:gamerName]){ // Already known Gamer
                [deletionArray removeObject:gamerName]; // remove from Deletion list 
            }else { // newGamer 
                [gamerList addObject:gamerName]; // add to gamerList
            }
            
            int gamerStatus = [[dictionary valueForKey:@"isZombie"] intValue ];
            int health = [[dictionary valueForKey:@"health"] intValue ];
            PlayerLocation* gamerloc = [[PlayerLocation alloc] initWithName:gamerName status:gamerStatus coordinate:location health:health];
            [gamerLocations addObject:gamerloc];
        }
        for (NSString* s in deletionArray){
            [gamerList removeObject:s]; // Player that are no longer in the game are deleted from the list
            [delegateMapView removeAnnotationOfPlayer:s]; // pins are removed from the map
        }
        [delegateMapView drawGamers:gamerLocations];
        
    }else if ([commandString compare:@"fight"]==0){
        
        NSLog (@" ATTACKE !! !! ! !!");
        _inFight=true;
        while(![ delegateMapView returnViewStatus]) {
            ;
        }
            [delegateMapView changetoFightView];
        
    }
    else if ([commandString compare:@"listFightingGamers"]==0 && _inFight){
        _myTurnToAttack=true;
        NSLog(@"listOpponents ");
        
        NSArray* oponentsDescription = [dic valueForKey:@"value"];
        
        NSLog(@"%@",oponentsDescription);
        NSMutableArray* opList = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (NSDictionary* dictionary in oponentsDescription ){
            NSString* oponentName =[dictionary valueForKey:@"gamerName"];
            NSString* gamerID = [dictionary valueForKey:@"gamerID"];
            bool isZombie = [[dictionary valueForKey:@"isZombie"]boolValue];
            int health = [[dictionary valueForKey:@"health"]intValue];
            Socket_Opponent* op = [[Socket_Opponent alloc] initWithName:oponentName ID:gamerID status:isZombie health:health];
            [opList addObject: op ];
        }
        _oponentsList = opList ;
        [delegateFightView updateFight:_oponentsList];  
        
    }else if ([commandString compare:@"listOponents"]==0 && !_inFight){
        
        NSLog(@"listOponents ,aber da LIEF WAS SCHIEFFFFFFF!!");
        
    }else if ([commandString compare:@"fightOver"]==0 && _inFight){
        _inFight=false;
        NSLog(@"Fight OVER %@", [[dic valueForKey:@"value"] description]);
        NSString* stillAlive = [[dic valueForKey:@"value"] description];
        if([stillAlive compare:@"0"] != 0){
            NSLog(@"I am still alive.");
            [[delegateFightView navigationController] popViewControllerAnimated:YES];
        } else {
            NSLog(@"I am dead.");
            [delegateFightView performSegueWithIdentifier: @"segFightViewToMainMenu" sender: self];
        }
        

        
    }else if ([commandString compare:@"fightOver"]==0 && !_inFight){
        NSLog(@"Fight OVER , aber da lief was schieff!");
        
    }else{
        
        NSLog(@"unbekanntes commando : %@", commandString);
    }
    [myLock unlock];
}

-(bool)attackGamerWithID:(NSString*)id andDamage:(int)dmg{
    if(_myTurnToAttack){
        [netCom attackGamerWithID:id andDmg:dmg];
        _myTurnToAttack=false;
        return true;
    }else {
        return false;
    }
}

@end
