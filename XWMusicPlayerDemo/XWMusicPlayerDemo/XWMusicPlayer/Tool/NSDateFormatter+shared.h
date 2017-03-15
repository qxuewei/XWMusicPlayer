//
//  NSDateFormatter+shared.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  单例时间解析器

#import <Foundation/Foundation.h>

@interface NSDateFormatter (shared)
+ (instancetype)sharedDateFormatter;
@end
