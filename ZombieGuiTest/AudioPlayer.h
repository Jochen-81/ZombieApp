//
//  AudioPlayer.h
//  ZombieEscape
//
//  Created by moco on 30.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayer : NSObject{
    AVAudioPlayer *audioPlayer;
}

-(void) pausePlaying;
-(void) startPlaying;


+ (id)getAudioPlayer;

@end
