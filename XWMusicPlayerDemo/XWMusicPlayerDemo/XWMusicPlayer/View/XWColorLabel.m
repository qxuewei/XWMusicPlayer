//
//  XWColorLabel.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWColorLabel.h"

@implementation XWColorLabel

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    // 设置颜色
    [self.currentColor set];
    rect.size.width *= self.progress;
    
    // 图形混合模式
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

- (UIColor *)currentColor {
    
    if (_currentColor == nil) {
        _currentColor = [UIColor greenColor];
    }
    return _currentColor;
}


@end
