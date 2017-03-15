//
//  XWMusic.h
//  XWMusicPlayerDemo
//
//  Created by 邱学伟 on 2017/3/14.
//  Copyright © 2017年 邱学伟. All rights reserved.
//  一首歌

#import <Foundation/Foundation.h>

typedef enum
{
    WPFMusicTypeLocal,
    WPFMusicTypeRemote
}WPFMusicType;

@interface XWMusic : NSObject

/** 图片 */
@property (nonatomic,copy) NSString *image;

/** 歌词 */
@property (nonatomic,copy) NSString *lrc;

/** 歌曲 */
@property (nonatomic,copy) NSString *mp3;

/** 歌曲名 */
@property (nonatomic,copy) NSString *name;

/** 歌手 */
@property (nonatomic,copy) NSString *singer;

/** 专辑 */
@property (nonatomic,copy) NSString *album;

/** 类型 */
@property (nonatomic,assign) WPFMusicType type;

@end
