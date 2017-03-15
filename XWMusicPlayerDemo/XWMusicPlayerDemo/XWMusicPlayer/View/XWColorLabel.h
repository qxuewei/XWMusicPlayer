//
//  XWColorLabel.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  正在播放的歌词label

#import <UIKit/UIKit.h>

@interface XWColorLabel : UILabel

/** 歌词播放进度 */
@property (nonatomic,assign) CGFloat progress;

/** 歌词颜色 */
@property (nonatomic,strong) UIColor *currentColor;

@end
