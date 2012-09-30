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

-(void) initWithgamerID:(NSString*)gID andDamage:(int)dmg{
    _damage = dmg;
    _gamerID= gID;
}

-(NSDictionary*) toJson{
    if( self.gamerID ==nil )
        @throw [NSException exceptionWithName:@"NilValueException" reason:@"gameID is nil" userInfo:nil];
    NSDictionary* dict=nil;
    dict = [NSDictionary dictionaryWithObjectsAndKeys: self.gamerID,@"gameID",self.damage,@"strength", nil ]; 
    return dict;
}

+(id)FromJsonToObject:(NSObject*)obj{
}



@end
