//
//  Socket_AttackGamer.m
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "Socket_AttackGamer.h"

@implementation Socket_AttackGamer

@synthesize damage =_damage;
@synthesize gamerID = _gamerID;

-(id) initWithgamerID:(NSString*)gID andDamage:(int)dmg{
    _damage = dmg;
    _gamerID= gID;
    return self;
}

-(NSDictionary*) toJson{
    if( self.gamerID ==nil )
        @throw [NSException exceptionWithName:@"NilValueException" reason:@"gameID is nil" userInfo:nil];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: self.gamerID,@"IDofAttackedGamer",[NSNumber numberWithInt:self.damage],@"strength", nil ]; 
    return dict;
}

+(id)FromJsonToObject:(NSObject*)obj{
}



@end
