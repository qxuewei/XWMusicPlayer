//
//  XWMusicPlayer.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/15.
//  Copyright © 2017年 邱学伟. All rights reserved.
//
// 集中装箱  基本数据类型转换成对象
#define MAS_SHORTHAND_GLOBALS
#import "XWMusicPlayer.h"
#import "MJExtension.h"
#import "XWMusic.h"
#import "XWPlayManager.h"
#import "XWTimeTool.h"
#import "XWLyricParser.h"
#import "XWLyric.h"
#import "XWColorLabel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>
#import "XWLyricView.h"
@interface XWMusicPlayer ()
#pragma mark 私有属性
@property (nonatomic,strong) NSArray *musics;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *lyrics;
@property (nonatomic,assign) NSInteger currentLyricIndex;

@property (weak, nonatomic) IBOutlet UIView *leftBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *rightBackgroundView;

#pragma mark 共用的属性
// 当前播放的歌曲
@property (nonatomic, strong) XWMusic *music;
// 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
// 当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
// 歌曲总时间
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
// 播放进度
@property (weak, nonatomic) IBOutlet UIProgressView *slider;
// 歌词
@property (strong, nonatomic) IBOutletCollection(XWColorLabel) NSArray *lyricsLabelLeft;
@property (strong, nonatomic) IBOutletCollection(XWColorLabel) NSArray *lyricsLabelRight;
// 播放
- (IBAction)play;
@property (weak, nonatomic) IBOutlet XWLyricView *lyricView;
@end

@implementation XWMusicPlayer

- (void)startShowMusic:(XWMusic *)music {
    [self changeMusic:music];
}


- (IBAction)play {
    XWPlayManager *playManager = [XWPlayManager sharedPlayManager];
    if (self.playBtn.selected == NO) {
        [self startUpdateProgress];
        [playManager playMusicWithFileName:_music.mp3 didComplete:^{
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
- (void)changeMusic:(XWMusic *)music {
    if (_music == music) {
        return;
    }
    _music = music;
    // 防止切歌时歌词数组越界
    self.currentLyricIndex = 0;
    // 切歌时销毁当前的定时器
    [self stopUpdateProgress];
    XWPlayManager *pm = [XWPlayManager sharedPlayManager];
    // 解析歌词
    self.lyrics = [XWLyricParser parserLyricWithFileName:music.lrc];
    // 歌词
    self.lyricView.lyrics = self.lyrics;
    self.playBtn.selected = NO;
    [self play];
    self.durationLabel.text = [XWTimeTool stringWithTime:pm.duration];
}

- (void)stopPlayMusic:(XWMusic *)music {
    XWPlayManager *playManager = [XWPlayManager sharedPlayManager];
    [playManager pause];
    [self stopUpdateProgress];
    music = NULL;
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
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNextLyric];
        
        // 设置歌词内容
        XWColorLabel *colorLable = [self.lyricsLabelLeft firstObject];
        if (![colorLable.text isEqualToString:lyric.content]) {
            [self.lyricsLabelLeft setValue:lyric.content forKey:@"text"];
        }
        // 设置歌词颜色
        CGFloat progress = (pm.currentTime - lyric.time) / (nextLyric.time - lyric.time);
        [self.lyricsLabelLeft setValue:@(progress) forKey:@"progress"];
        
        self.lyricView.currentLyricIndex = self.currentLyricIndex;
        self.lyricView.lyricProgress = progress;
        NSLog(@"%.4f",progress);
        if (progress > 1.0) {
            [XWMusicPlayer replaceView:self.leftBackgroundView rightView:self.rightBackgroundView];
        }
    }];
}

- (void)setNextLyric {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger nextIndex = self.currentLyricIndex + 1;
        //$
        for (NSInteger i = nextIndex; i < self.lyrics.count - 2; i++) {
            XWLyric *lyric2 = self.lyrics[i];
            if (lyric2 && lyric2.content.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.lyricsLabelRight setValue:lyric2.content forKey:@"text"];
                });
                break;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.lyricsLabelRight setValue:@"" forKey:@"text"];
                });
                continue;
            }
        }
    });
}

+ (void)replaceView:(UIView *)leftView rightView:(UIView *)rightView {
    CGPoint tempCenter = rightView.center;
    rightView.center = leftView.center;
    leftView.center = tempCenter;
}

@end
