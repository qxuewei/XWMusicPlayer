//
//  XWLyricParser.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  歌词解析 返回 XWLyric 数组

#import <Foundation/Foundation.h>

@interface XWLyricParser : NSObject
+ (NSArray *)parserLyricWithFileName:(NSString *)fileName;
@end
