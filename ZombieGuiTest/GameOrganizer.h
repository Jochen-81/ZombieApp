//
//  GameOrganizer.h
//  ZombieEscape
//
//  Created by HTWdS User on 23.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"



@interface GameOrganizer : NSObject
@property (strong,nonatomic) NSString* gamerName;
@property int gamerStatus;
@property int GameID;

+(id)getGameOrganizer;
-(void)startWithDelegate:(UIViewController*)cont;

-(void)handleInputFromNetwork:(NSString*)stream;
-(void)updateMyLocation:(CLLocation*)newLocation;

-(void)saveGameStatusAndStop;
-(void)loadGameStatusAndRun;
@end
