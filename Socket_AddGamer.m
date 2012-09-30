//
//  Socket_AddGamer.m
//  ZombieEscape
//
//  Created by Jochen on 26.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "Socket_AddGamer.h"

@implementation Socket_AddGamer

@synthesize gameID, state;

- (id)initWithGameID:(NSString*) g_id state:(int) s{
    self.gameID = g_id;
    self.state = s;
    return self;
}


-(NSDictionary*) toJson{
    if( self.gameID ==nil || ! (self.state == 0 || self.state == 1 || self.state == 2))
        @throw [NSException exceptionWithName:@"NilValueException" reason:@"gameID or state is nil" userInfo:nil];
    NSDictionary* dict=nil;
    dict = [NSDictionary dictionaryWithObjectsAndKeys: self.gameID,@"gameID",[NSNumber numberWithInt:self.state],@"state", nil ]; 
    return dict;
}

+(id)FromJsonToObject:(NSObject*)obj{
}

@end
