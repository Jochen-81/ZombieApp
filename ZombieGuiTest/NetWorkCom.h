//
//  NetWorkCom.h
//  ZombieGuiTest
//
//  Created by HTWdS User on 19.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSLocation.h"
#import "MDBufferedInputStream.h"
#import "MapViewController.h"





@interface NetWorkCom : NSObject{
    MDBufferedInputStream *inputStream;
    NSOutputStream *outputStream;
}


-(int) createNewPlayer:(NSString*)playerName ;
-(int) createNewGame:(NSString*)gameName ;
-(BOOL) addPlayerToGame:(int)gameID;
-(BOOL) addPlayerToGame:(int)gameID state:(int) state;
-(BOOL) removePlayer;
-(void) setLocation:(GPSLocation*)loc;
-(NSMutableArray*) getGamelist;

-(BOOL) isConnected;
-(void) closeConnection;
-(void) reconnect;
-(void) initNetworkComm ;

+ (id)getNetWorkCom;

-(void)startReadingInputStream;
-(void)StopReadingInputStream;
-(NSString*)readLineFromInputStream;
-(void)setDelegate:(id)gameOrg;



@end
