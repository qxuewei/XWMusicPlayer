//
//  XWPlayManager.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWPlayManager.h"
#import <AVFoundation/AVFoundation.h>

@interface XWPlayManager () <AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) void(^complete)();
@end

@implementation XWPlayManager
static XWPlayManager *_playManger;

+ (instancetype)sharedPlayManager {
    
    if (!_playManger) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _playManger = [[self alloc] init];
        });
    }
    return _playManger;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_playManger) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _playManger = [super allocWithZone:zone];
        });
    }
    return _playManger;
}


- (instancetype)init {
    self = [super init];
    if (self) {
         // 监听音频被打断的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)audioSessionInterruptionNotification:(NSNotification *)noti {
    
    //    NSLog(@"%@",noti.userInfo[AVAudioSessionInterruptionTypeKey]);
    AVAudioSessionInterruptionType type = [noti.userInfo[AVAudioSessionInterruptionTypeKey] integerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self.player pause];
    }else if(type == AVAudioSessionInterruptionTypeEnded){
        [self.player play];
    }
}

- (void)playMusicWithFileName:(NSString *)fileName didComplete:(void(^)())complete {
    if (_fileName != fileName) {
        // 播放音乐
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        self.player = player;
        [player prepareToPlay];
        
        player.delegate = self;
        self.fileName = fileName;
        self.complete = complete;
    }
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.complete();
}
#pragma mark setters 和getters方法
- (NSTimeInterval)currentTime {
    return self.player.currentTime;
}

- (NSTimeInterval)duration {
    return self.player.duration;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    self.player.currentTime = currentTime;
}


@end
