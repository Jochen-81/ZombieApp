//
//  PlayerLocation.m
//  ZombieEscape
//
//  Created by HTWdS User on 22.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "PlayerLocation.h"

@implementation PlayerLocation

@synthesize name = _name;
@synthesize coordinate = _coordinate;
@synthesize decomission=_decomission;
@synthesize gamerStatus;
@synthesize title = _title;


- (id)initWithName:(NSString*)name status:(int)status coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        gamerStatus =status;
        _coordinate = coordinate;
        _decomission=NO;
        _title=name;
    }
    return self;
}


- (NSString *)description{
    return _name ;
}

-(CLLocationCoordinate2D)coordinate{
    return _coordinate;
}

-(NSString *)title {
    return _name;
}
-(NSString *)address{
    if (gamerStatus==0)
        return @"BRAINZ!!";
    else 
        return @"RUN!!";
}

@end
