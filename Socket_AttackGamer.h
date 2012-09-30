//
//  Socket_AttackGamer.h
//  ZombieEscape
//
//  Created by HTWdS User on 29.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializable.h"

@interface Socket_AttackGamer : NSObject <JsonSerializable>

@property NSString* gamerID;
@property int damage;

-(Socket_AttackGamer*) initWithgamerID:(NSString*)gID andDamage:(int)dmg;

-(NSDictionary*) toJson;
+(id)FromJsonToObject:(NSObject*)obj;

@end
