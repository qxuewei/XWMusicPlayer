//
//  ViewController.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

// 忽略前缀
#define MAS_SHORTHAND

// 集中装箱  基本数据类型转换成对象
#define MAS_SHORTHAND_GLOBALS

#import "ViewController.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "XWMusic.h"
#import "XWPlayManager.h"
#import "XWTimeTool.h"
#import "XWLyricParser.h"
#import "XWLyric.h"
#import "XWColorLabel.h"
#import "XWLyricView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>

@interface ViewController ()<XWLyricViewDelegate>

#pragma mark 私有属性
@property (nonatomic,strong) NSArray *musics;
@property (nonatomic,assign) NSInteger currentMusicIndex;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *lyrics;
@property (nonatomic,assign) NSInteger currentLyricIndex;
//@property (weak, nonatomic) IBOutlet XWLyricView *lyricView;

#pragma mark 共用的属性
// 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
// 当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
// 歌曲总时间
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *slider;


#pragma mark 竖屏
// 歌词
@property (strong, nonatomic) IBOutletCollection(XWColorLabel) NSArray *lyricsLabel;
@property (strong, nonatomic) IBOutletCollection(XWColorLabel) NSArray *lyricsLabel2;

// 播放
- (IBAction)play;

@end

@implementation ViewController
- (NSArray *)musics {
    if (!_musics) {
        _musics = [XWMusic mj_objectArrayWithFilename:@"mlist.plist"];
    }
    return _musics;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 切歌
    [self changeMusic];
//    self.lyricView.delegate = self;
}

- (IBAction)play {
    XWPlayManager *playManager = [XWPlayManager sharedPlayManager];
    if (self.playBtn.selected == NO) {
        [self startUpdateProgress];
        XWMusic *music = self.musics[self.currentMusicIndex];
        [playManager playMusicWithFileName:music.mp3 didComplete:^{
            NSLog(@"歌曲播放完毕");
        }];
        self.playBtn.selected = YES;
    }else{
        self.playBtn.selected = NO;
        [playManager pause];
        [self stopUpdateProgress];
    }
    
}

/**
 *  切歌
 */
- (void)changeMusic {
    // 防止切歌时歌词数组越界
    
    self.currentLyricIndex = 0;
    // 切歌时销毁当前的定时器
    [self stopUpdateProgress];
    
    XWPlayManager *pm = [XWPlayManager sharedPlayManager];
    
    XWMusic *music = self.musics[self.currentMusicIndex];
    // 歌词
    // 解析歌词
    self.lyrics = [XWLyricParser parserLyricWithFileName:music.lrc];
    
    // 给竖直歌词赋值
//    self.lyricView.lyrics = self.lyrics;
    
    self.playBtn.selected = NO;
    self.navigationItem.title = music.name;
    [self play];
    self.durationLabel.text = [XWTimeTool stringWithTime:pm.duration];
}

- (void)startUpdateProgress {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
}

- (void)stopUpdateProgress {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateProgress {
    
    XWPlayManager *pm = [XWPlayManager sharedPlayManager];
    self.currentTimeLabel.text = [XWTimeTool stringWithTime:pm.currentTime];
    self.slider.progress = pm.currentTime / pm.duration;
    //  更新歌词
    [self updateLyric];
    
}

- (void)updateLyric {
    
    XWPlayManager *pm = [XWPlayManager sharedPlayManager];
    XWLyric *lyric = self.lyrics[self.currentLyricIndex];
    XWLyric *nextLyric = nil;
    if (self.currentLyricIndex >= self.lyrics.count - 1) {
        nextLyric = [[XWLyric alloc] init];
        nextLyric.time = pm.duration;
    }else{
        nextLyric = self.lyrics[self.currentLyricIndex + 1];;
    }
    
    if (pm.currentTime < lyric.time && self.currentLyricIndex > 0) {
        self.currentLyricIndex --;
        [self updateLyric];
    }else if(pm.currentTime >= nextLyric.time && self.currentLyricIndex < self.lyrics.count - 1){
        self.currentLyricIndex ++;
        [self updateLyric];
    }
    
    [self setNextLyric];
    
    // 设置歌词内容
    [self.lyricsLabel setValue:lyric.content forKey:@"text"];
    // 设置歌词颜色
    CGFloat progress = (pm.currentTime - lyric.time) / (nextLyric.time - lyric.time);
    [self.lyricsLabel setValue:@(progress) forKey:@"progress"];
//    self.lyricView.currentLyricIndex = self.currentLyricIndex;
//    self.lyricView.lyricProgress = progress;
}

- (void)setNextLyric {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger nextIndex = self.currentLyricIndex + 1;
        //$
        for (NSInteger i = nextIndex; i < self.lyrics.count - 2; i++) {
            XWLyric *lyric2 = self.lyrics[i];
            if (lyric2 && lyric2.content.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.lyricsLabel2 setValue:lyric2.content forKey:@"text"];
                });
                break;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.lyricsLabel2 setValue:@"" forKey:@"text"];
                });
                continue;
            }
        }
    });
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    /*
     UIEventSubtypeRemoteControlPlay                 播放
     UIEventSubtypeRemoteControlPause                暂停
     UIEventSubtypeRemoteControlStop                 停止
     UIEventSubtypeRemoteControlTogglePlayPause      从暂停到播放
     UIEventSubtypeRemoteControlNextTrack            下一曲
     UIEventSubtypeRemoteControlPreviousTrack        上一曲
     UIEventSubtypeRemoteControlBeginSeekingBackward 开始快退
     UIEventSubtypeRemoteControlEndSeekingBackward   结束快退
     UIEventSubtypeRemoteControlBeginSeekingForward  开始快进
     UIEventSubtypeRemoteControlEndSeekingForward    结束快进
     */
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self play];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            
            break;
            
        default:
            break;
    }
}
@end
