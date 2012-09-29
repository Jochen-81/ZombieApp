//
//  Socket_AddGamer.h
//  ZombieEscape
//
//  Created by Jochen on 26.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializable.h"

@interface Socket_AddGamer : NSObject<JsonSerializable>

@property(nonatomic, copy) NSString *gameID;
@property(nonatomic) int state;

- (id)initWithGameID:(NSString*) g_id state:(int) s;

-(NSDictionary*) toJson;
+(id)FromJsonToObject:(NSObject*)obj;

@end
