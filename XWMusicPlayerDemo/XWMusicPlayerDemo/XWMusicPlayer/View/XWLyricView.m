//
//  XWLyricView.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

// 忽略前缀
#define MAS_SHORTHAND

// 集中装箱  基本数据类型转换成对象
#define MAS_SHORTHAND_GLOBALS

#import "XWLyricView.h"
#import "Masonry.h"
#import "XWColorLabel.h"
#import "XWLyric.h"
#import "XWSliderView.h"

@interface XWLyricView () <UIScrollViewDelegate>
/** 定位播放的View */
@property (nonatomic,weak) XWSliderView *sliderView;

@end

@implementation XWLyricView
@synthesize currentLyricIndex = _currentLyricIndex;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    // 创建竖直滚动的scrollerView
    UIScrollView *vScrollerView = [[UIScrollView alloc] init];
    [self addSubview:vScrollerView];
    vScrollerView.delegate = self;
    self.vScrollerView = vScrollerView;
    
    // 添加sliderView
    XWSliderView *sliderView = [[XWSliderView alloc] init];
    [self addSubview:sliderView];
    sliderView.hidden = YES;
    self.sliderView = sliderView;
    
    [sliderView makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self);
        make.height.equalTo(self.rowHeight);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.vScrollerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.left.equalTo(self);
    }];
    
    self.vScrollerView.contentSize = CGSizeMake(0, self.lyrics.count * self.rowHeight);
#warning 必须使用self.bounds.size.height  不能使用self.vScrollerView.bounds.size.height   这个layoutSubviews只作用于self   所以self.vScrollerView可能还没有布局完成
    CGFloat top = (self.bounds.size.height - self.rowHeight) * 0.5;
    CGFloat bottom = top;
    self.vScrollerView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
}

#pragma mark UIScrollerView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self vScrollerViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.vScrollerView) {
        self.sliderView.hidden = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.vScrollerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.vScrollerView.isDragging == YES) {
                return ;
            }
            self.sliderView.hidden = YES;
        });
    }
}

- (void)vScrollerViewDidScroll {
    CGFloat offy = self.vScrollerView.contentOffset.y + self.vScrollerView.contentInset.top;
    NSInteger currentIndex = offy / self.rowHeight;
    if (currentIndex < 0) {
        currentIndex = 0;
    }else if(currentIndex > self.lyrics.count - 1){
        currentIndex = self.lyrics.count - 1;
    }
    XWLyric *lyric = self.lyrics[currentIndex];
    self.sliderView.time = lyric.time;
}


#pragma mark setter和getter
- (void)setLyrics:(NSArray *)lyrics {
    
    _lyrics = lyrics;
    [self.vScrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i =0; i < lyrics.count; i ++) {
        
        XWColorLabel *colorLabel = [[XWColorLabel alloc] init];
        colorLabel.textColor = [UIColor whiteColor];
        colorLabel.font = [UIFont systemFontOfSize:14.0];
        XWLyric *lyric = lyrics[i];
        colorLabel.text = lyric.content;
        [self.vScrollerView addSubview:colorLabel];
        
        // 添加约束
        [colorLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.vScrollerView);
            make.top.equalTo(self.rowHeight * i);
            make.height.equalTo(self.rowHeight);
        }];
    }
}

- (NSInteger)rowHeight {
    if (_rowHeight == 0) {
        _rowHeight = 30;
    }
    return _rowHeight;
}


- (void)setCurrentLyricIndex:(NSInteger)currentLyricIndex {
    
    // 切歌时数组越界
    XWColorLabel *preLabel = self.vScrollerView.subviews[self.currentLyricIndex];
    preLabel.progress = 0;
    preLabel.font = [UIFont systemFontOfSize:14.0];
    _currentLyricIndex = currentLyricIndex;
    XWColorLabel *colorLabel = self.vScrollerView.subviews[currentLyricIndex];
    colorLabel.font = [UIFont systemFontOfSize:20.0];
    NSInteger offY = currentLyricIndex * self.rowHeight - self.vScrollerView.contentInset.top;
    self.vScrollerView.contentOffset = CGPointMake(0, offY);
    [self.vScrollerView setContentOffset:CGPointMake(0, offY) animated:YES];
}

- (NSInteger)currentLyricIndex {
    
    if (_currentLyricIndex <0) {
        _currentLyricIndex = 0;
    }else if(_currentLyricIndex >= self.lyrics.count - 1){
        _currentLyricIndex = self.lyrics.count - 1;
    }
    return _currentLyricIndex;
}

- (void)setLyricProgress:(CGFloat)lyricProgress {
    
    _lyricProgress = lyricProgress;
    XWColorLabel *colorLabel = self.vScrollerView.subviews[self.currentLyricIndex];
    colorLabel.progress = lyricProgress;
}




@end
