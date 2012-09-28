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


@implementation GameOrganizer

@synthesize gamerName = _gamerName;
@synthesize gamerStatus = _gamerStatus;
@synthesize GameID =_GameID;
bool inGame ;

NetWorkCom* netCom;
MapViewController* delegate;

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
        [netCom addPlayerToGame:gameID ];
        [netCom startReadingInputStream];
        [self startSendingMyLocation];
    }
}

-(void)gamerLeavesGame{
    [netCom removePlayer];
    _GameID = 0;
}

-(void)updateMyLocation:(CLLocation*)newLocation{
    if(inGame)
        [netCom setLocation:[[GPSLocation alloc]initWithLong:[newLocation coordinate].longitude AndLat:[newLocation coordinate].latitude ]];
}

-(void)startWithDelegate:(MapViewController*)cont{
    netCom =[NetWorkCom getNetWorkCom] ;
     
    NSLog(@"Non Polling Mode, waiting for Networkevents");
    if(cont!=nil){
        [self setdelegate:cont];
    }
    [self startSendingMyLocation];
    [netCom startReadingInputStream];
    [ netCom setDelegate:self];
}


-(void) setdelegate:(MapViewController*)viewController {
    delegate = viewController;
}

-(void)handleInputFromNetwork:(NSString*)stream{
    
    // Create SBJSON object to parse JSON
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [parser objectWithString:stream];
   
    NSLog(@"Von Server : %@",[dic description]);
    NSString* commandString = [ dic objectForKey:@"command"];
    NSMutableArray* gamerLocations = [[NSMutableArray alloc] initWithCapacity:1];
    
    if ([commandString compare:@"listGamers"] ==0){
        
        NSArray* gamerDescription = [dic valueForKey:@"value"];
        for (NSDictionary* dictionary in gamerDescription ){
            CLLocationCoordinate2D location = [[[CLLocation alloc] init ] coordinate];
                        
            double longi = [[dictionary valueForKey:@"longitude"]doubleValue ];
            double lat = [[dictionary valueForKey:@"latitude"]doubleValue ];
            location.longitude = longi ;
            location.latitude =lat;
            NSString* gamerName =[dictionary valueForKey:@"gamername"];
            int gamerStatus = [[dictionary valueForKey:@"isZombie"] intValue ];
            PlayerLocation* gamerloc = [[PlayerLocation alloc] initWithName:gamerName status:gamerStatus coordinate:location];
                [gamerLocations addObject:gamerloc];
        }
        [delegate drawGamers:gamerLocations];
        
    }else if ([commandString compare:@"fight"]==0){
        NSLog (@" ATTACKE !! !! ! !!");
    }
    else {
        NSLog(@"unbekanntes commando : %@", commandString);
    }
     
}

@end
