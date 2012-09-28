//
//  PlayerLocation.h
//  ZombieEscape
//
//  Created by HTWdS User on 22.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface PlayerLocation : NSObject <MKAnnotation> 


@property (copy) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property int gamerStatus;
@property BOOL decomission;

- (id)initWithName:(NSString*)name status:(int)status coordinate:(CLLocationCoordinate2D)coordinate;


@end
