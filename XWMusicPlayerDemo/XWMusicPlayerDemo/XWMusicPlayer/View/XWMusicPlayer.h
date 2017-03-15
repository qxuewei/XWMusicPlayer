//
//  XWMusicPlayer.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/15.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWMusic;
@interface XWMusicPlayer : UIView

/// 播放某歌曲
- (void)startShowMusic:(XWMusic *)music;
/// 停止播放某歌曲
- (void)stopPlayMusic:(XWMusic *)music;

@end
