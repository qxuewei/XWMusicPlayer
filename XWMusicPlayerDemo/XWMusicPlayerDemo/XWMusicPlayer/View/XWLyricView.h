//
//  XWLyricView.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  歌词展示界面

#import <UIKit/UIKit.h>
@class XWLyricView;

@protocol XWLyricViewDelegate  <NSObject>

@optional

- (void)lyricView:(XWLyricView *)lyricView withProgress:(CGFloat)progress;
@end

@interface XWLyricView : UIView

@property (nonatomic,weak) id <XWLyricViewDelegate> delegate;

/** 歌词模型数组 */
@property (nonatomic,strong) NSArray *lyrics;

/** 每行歌词行高 */
@property (nonatomic,assign) NSInteger rowHeight;

/** 当前正在播放的歌词索引 */
@property (nonatomic,assign) NSInteger currentLyricIndex;

/** 歌曲播放进度 */
@property (nonatomic,assign) CGFloat lyricProgress;

/** 竖直滚动的view，即歌词View */
@property (nonatomic,weak) UIScrollView *vScrollerView;


@end
