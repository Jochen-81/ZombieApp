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
@property BOOL gamerStatus;
@property (strong,nonatomic) NSString* GameName;

+(id)getGameOrganizer;
-(void)reset;
-(void)startWithpollingMode:(BOOL)pol andDelegate:(UIViewController*)cont;
-(void)stop;
-(void)createAnotioansFromString:(NSString*)stream;
-(void)handleInputFromNetwork:(NSString*)stream;
-(void)updateMyLocation:(CLLocation*)newLocation;

@end
