//
//  XWLyric.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  一句歌词

#import <Foundation/Foundation.h>

@interface XWLyric : NSObject

/** 歌词开始时间 */
@property (nonatomic,assign) NSTimeInterval time;

/** 歌词内容 */
@property (nonatomic,copy) NSString *content;

@end
