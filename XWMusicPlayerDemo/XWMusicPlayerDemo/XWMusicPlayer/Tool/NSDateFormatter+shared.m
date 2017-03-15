//
//  NSDateFormatter+shared.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "NSDateFormatter+shared.h"

@implementation NSDateFormatter (shared)
+ (instancetype)sharedDateFormatter {
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[self alloc]  init];
    });
    return _dateFormatter;
}
@end
