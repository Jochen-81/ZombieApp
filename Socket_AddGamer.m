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
}

@end
