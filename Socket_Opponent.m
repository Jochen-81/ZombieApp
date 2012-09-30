//
//  Socket_Opponent.m
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "Socket_Opponent.h"

@implementation Socket_Opponent
@synthesize health =_health;
@synthesize gamerID = _gamerID;
@synthesize gamerName =_gamerName;
@synthesize isZombie = _isZombie;

-(Socket_Opponent*)initWithName:(NSString*)name ID:(NSString*)id status:(bool)status health:(int)heal{
    _health=heal;
    _gamerName =name;
    _gamerID =id;
    _isZombie =status;
    return self;
}

@end
