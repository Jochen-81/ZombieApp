//
//  Socket_Opponent.h
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket_Opponent : NSObject
@property NSString* gamerName;
@property NSString* gamerID;
@property bool isZombie;
@property int health;
-(Socket_Opponent*)initWithName:(NSString*)name ID:(NSString*)id status:(bool)status health:(int)heal;
@end
