//
//  NetWorkCom.m
//  ZombieGuiTest
//
//  Created by HTWdS User on 19.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "NetWorkCom.h"
#import "SocketMessage.h"
#import "PlistHandler.h"
#import "Classes/SBJson.h"
#import "Socket_GameOverview.h"
#import "Socket_AddGamer.h"
#import "Socket_AttackGamer.h"



@implementation NetWorkCom

GameOrganizer* gameOrganizer;
int x ;

bool read_Ready ;


+ (id)getNetWorkCom {
    static NetWorkCom *netCom = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netCom = [[self alloc] init];
    });
    return netCom;
}

- (id)init {
    if (self = [super init]) {
        [self StopReadingInputStream];
        [self initNetworkComm];
        
    }
    return self;
}

-(void)startReadingInputStream{
    read_Ready=YES;
}

-(void)StopReadingInputStream{
    read_Ready=NO;
}

-(void)setDelegate:(id)gameOrg{
    gameOrganizer=gameOrg;
}

-(void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
   // NSLog(@"Ready : %i",x++);
    NSString *event;
    if (read_Ready && gameOrganizer != nil){
        switch(eventCode) {
        
            case NSStreamEventHasBytesAvailable:   
                event = @"Lese...";
               [gameOrganizer handleInputFromNetwork:inputStream.readLine];
                break;
            case NSStreamEventNone:
                event = @"NSStreamEventNone";
                break;
            case NSStreamEventOpenCompleted:
                event = @"NSStreamEventOpenCompleted";
                break;
            case NSStreamEventHasSpaceAvailable:
                event = @"NSStreamEventHasSpaceAvailable";
               break;
          case NSStreamEventErrorOccurred:
                event = @"NSStreamEventErrorOccurred"; 
                break;
            case NSStreamEventEndEncountered:
                event = @"NSStreamEventEndEncountered";break; 
            default:
                event = @"Unknown"; break;
                
        }
     //   NSLog(@"Event : %@",event);
    }
}



-(NSString*)readLineFromInputStream{
    return inputStream.readLine;
}


-(int) createNewPlayer:(NSString*)playerName {
    SocketMessage* msg = [SocketMessage createSocketMessageWithCommand:@"newGamer" andValue:playerName];               
    [self writeJson:msg.toJson ToStream:outputStream];
    int gamerID = [[inputStream readLine] intValue];
    NSLog(@"new gamerID = %d", gamerID);
    return gamerID;
}

-(int) createNewGame:(NSString*)gameName {
    SocketMessage* msg = [SocketMessage createSocketMessageWithCommand:@"newGame" andValue:gameName];               
   [self writeJson:msg.toJson ToStream:outputStream];
    //return the gameID received from the server
    return [[inputStream readLine] intValue];
}

-(BOOL) addPlayerToGame:(int)gameID{
    return [self addPlayerToGame:gameID withState:0];
}

-(BOOL) addPlayerToGame:(int)gameID withState:(int) state{
    NSString* str_id =[NSString stringWithFormat:@"%d",gameID];
    gameOrganizer.GameID=gameID;
    Socket_AddGamer *s_addGamer = [[Socket_AddGamer alloc] initWithGameID:str_id state:state];
    SocketMessage *msg = [SocketMessage createSocketMessageWithCommand:@"addGamer" andValue:s_addGamer];               
    [self writeJson:msg.toJson ToStream:outputStream];
    BOOL humanORzombie = [[inputStream readLine]  boolValue];
    if(humanORzombie ==0){
        gameOrganizer.gamerStatus = 1;
    }else {
        gameOrganizer.gamerStatus =2;
    }
    NSLog(@"Gamer is human: %d", humanORzombie);
    return humanORzombie;
}

-(BOOL) removePlayer{
    SocketMessage *msg = [SocketMessage createSocketMessageWithCommand:@"removeGamer" andValue:nil];               
    [self writeJson:msg.toJson ToStream:outputStream];
    NSString* s;
    do{
        s = [inputStream readLine];
    }   while(!([s compare:@"true"]== 0 || [s compare:@"false"]== 0));
    NSLog(@"nach remove player : %@",s);
    return [s boolValue];
}

-(void) setLocation:(GPSLocation*)loc{
    SocketMessage *msg = [SocketMessage createSocketMessageWithCommand:@"setLocation" andValue: loc];               
    [self writeJson:msg.toJson ToStream:outputStream];
}

-(NSMutableArray*) getGamelist{
    SocketMessage *msg = [SocketMessage createSocketMessageWithCommand:@"listGames" andValue: nil];
    [self writeJson:msg.toJson ToStream:outputStream];
    NSString* json = [inputStream readLine];
    NSLog(@"from server lsgames %@", json);
    
    // Create SBJSON object to parse JSON
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *id_array = [parser objectWithString:json];
    
    NSMutableArray *gameArray = [[NSMutableArray alloc] initWithCapacity:[id_array count]];
    
    for (int i = 0; i < [id_array count];i++) {
        NSDictionary *d = [id_array objectAtIndex:i];
        int gameID = [[d objectForKey:@"gameID"] intValue];
        NSString* name = [d objectForKey:@"name"];
        double amount = [[d objectForKey:@"amountGamers"] doubleValue];
        double longi = [[d objectForKey:@"longitude"] doubleValue];
        double lati = [[d objectForKey:@"latitude"] doubleValue];
        
        
        Socket_GameOverview *s = [[Socket_GameOverview alloc] initWithGameID:gameID name:name amountGamers:amount longitude:longi latitude:lati];
        
        [gameArray addObject:s];
        
    }

    return gameArray;
    
}


//TODO still the old JSON class
-(void)writeJson:(NSDictionary*)dict ToStream:(NSOutputStream*)stream{
    
    NSError *error = nil; 
    
    if (![NSJSONSerialization isValidJSONObject:dict])
        @throw [NSException exceptionWithName:@"NotJsonConfirm" reason:@"NotJsonConfirm" userInfo:nil];
       
    NSInteger err = [NSJSONSerialization writeJSONObject: dict toStream:stream options:kNilOptions  error:&error];
    
    // sendinge newline 
    uint8_t newline = 0x0A;  
    
    [outputStream write: &newline maxLength:1];
    
}

- (void)initNetworkComm {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStringRef ipAddress = (__bridge CFStringRef)([[PlistHandler getPlistHandler] getServerIPAddress]);
    
    CFStreamCreatePairWithSocketToHost(NULL, ipAddress, 2004, &readStream, &writeStream);
    NSInputStream* input =(__bridge NSInputStream *)readStream;
    inputStream = [[MDBufferedInputStream alloc] initWithInputStream:input bufferSize:1024 encoding:NSUTF8StringEncoding];
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream.stream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream.stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [inputStream open];
    [outputStream open];
}

- (BOOL) isConnected {
    if (inputStream.streamStatus == NSStreamStatusOpen){
        return YES;
    } else {
        return NO;
    }
}

-(void) closeConnection{
    if([self isConnected]){
        SocketMessage *msg = [SocketMessage createSocketMessageWithCommand:@"bye" andValue: nil];               
        [self writeJson:msg.toJson ToStream:outputStream];
    }
    [inputStream close];
    [inputStream.stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
   
    [outputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void) reconnect{
    [self closeConnection];
    [self initNetworkComm];
}

-(void)attackGamerWithID:(NSString*)gID andDmg:(int)dmg{
    Socket_AttackGamer* sok_att = [[Socket_AttackGamer alloc]initWithgamerID:gID andDamage:dmg];
    SocketMessage *msg = [SocketMessage createSocketMessageWithCommand:@"attack" andValue: sok_att];
    [self writeJson:msg.toJson ToStream:outputStream];

}

@end
