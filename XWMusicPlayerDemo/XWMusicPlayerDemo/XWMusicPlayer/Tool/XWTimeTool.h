//
//  XWTimeTool.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  获取当前播放时间 格式 02:22

#import <Foundation/Foundation.h>

@interface XWTimeTool : NSObject
+ (NSString *)stringWithTime:(NSTimeInterval)time;
@end
