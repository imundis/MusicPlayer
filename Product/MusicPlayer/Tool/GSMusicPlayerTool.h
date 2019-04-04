//
//  GSMusicPlayerTool.h
//  Product
//
//  Created by guo on 2018/8/27.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSSongModel;
@class GSSongMessageModel;

typedef NS_ENUM(NSUInteger, GSMPPlayingMode) {
    GSMPPlayingModeRandomPlay,
    GSMPPlayingModeListLoop,
    GSMPPlayingModeSingleLoop
};

@interface GSMusicPlayerTool : NSObject

+ (instancetype)sharedPlayer;

@property (assign, nonatomic) NSInteger playingIndex;
@property (strong, nonatomic) GSSongModel *playingSongModel;
@property (assign, nonatomic, getter=isPlaying) BOOL playing;

- (void)play;
- (void)pause;
- (void)replay;
- (void)seekTo:(NSTimeInterval)time;
- (void)preMusic;
- (void)nextMusic;
- (void)setLockScreenInfo;

- (GSSongMessageModel *)getSongMessageModel;
- (void)resetPlayingMenu:(NSArray *)songModelArr;
- (void)addPlayingMenu:(NSArray *)songModelArr;
- (GSMPPlayingMode)changePlayingMode;
- (GSMPPlayingMode)getPlayingMode;

@end
