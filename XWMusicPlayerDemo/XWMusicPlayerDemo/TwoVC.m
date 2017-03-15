//
//  TwoVC.m
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/15.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "TwoVC.h"

#import "XWMusicPlayer.h"
#import "Masonry.h"

#import "XWMusic.h"
#import "MJExtension.h"

@interface TwoVC () {
    
    XWMusic *music;
}
@property (strong, nonatomic) XWMusicPlayer *musicPlayer;
@property (nonatomic,strong) NSArray *musics;
@end

@implementation TwoVC


- (NSArray *)musics {
    if (!_musics) {
        _musics = [XWMusic mj_objectArrayWithFilename:@"mlist.plist"];
    }
    return _musics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.musicPlayer = [[NSBundle mainBundle] loadNibNamed:@"XWMusicPlayer" owner:nil options:nil].lastObject;
    self.musicPlayer.frame = CGRectMake(30, 200, [UIScreen mainScreen].bounds.size.width - 60, 221);
    [self.view addSubview:self.musicPlayer];
    self.musicPlayer.hidden = YES;
    [self.musicPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@221);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.musicPlayer stopPlayMusic:music];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    music = [self.musics objectAtIndex:arc4random_uniform(6)];
    [self.musicPlayer startShowMusic:music];
    self.musicPlayer.hidden = NO;
}



@end
