//
//  AudioPlayer.m
//  ZombieEscape
//
//  Created by moco on 30.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

+ (id)getAudioPlayer {
    static AudioPlayer *audPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audPlayer = [[self alloc] init];
    });
    return audPlayer;
}

- (id)init {
    if (self = [super init]) {
        [self loadSong];
    }
    return self;
}

-(void) loadSong{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/02 Braineating Zombies from Area 51.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
		NSLog(@"%@",[error description]);
    
}

-(void) pausePlaying{
    [audioPlayer pause];
}
-(void) startPlaying{
    if (![audioPlayer isPlaying]) {
        [audioPlayer play];        
    }
}

@end
