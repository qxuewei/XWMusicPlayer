//
//  XWTimeTool.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWTimeTool.h"

@implementation XWTimeTool
+ (NSString *)stringWithTime:(NSTimeInterval)time {
    
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
@end
