//
//  Socket_GameOverview.h
//  ZombieGuiTest
//
//  Created by moco on 17.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializable.h"

@interface Socket_GameOverview : NSObject <JsonSerializable>

@property(nonatomic) int gameID;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) int amountGamers;
@property(nonatomic) double longitude;
@property(nonatomic) double latitude;

- (id)initWithGameID:(int) g_id name:(NSString*) n amountGamers:(int) am_ga longitude:(double) longi latitude:(double) lati;



@end
