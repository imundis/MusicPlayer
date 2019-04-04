//
//  GSMusicPlayerTool.m
//  Product
//
//  Created by guo on 2018/8/27.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSMusicPlayerTool.h"
#import "GSSongModel.h"
#import "GSSongMessageModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface GSMusicPlayerTool() {
    AVAudioPlayer *_player;
}

@property (strong, nonatomic) GSSongMessageModel *songMessageModel;
@property (strong, nonatomic) NSMutableArray *playingMenu;
@property (assign, nonatomic) GSMPPlayingMode playingMode;

@end

@implementation GSMusicPlayerTool

- (instancetype)init {
    self = [super init];
    if (self) {
        // 1.获取音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        // 2.设置音频会话类别
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            NSLog(@"error1:%@", error);
            return nil;
        }
        // 3.激活会话
        [session setActive:YES error:&error];
        if (error) {
            NSLog(@"error2:%@", error);
            return nil;
        }
    }
    return self;
}   

static GSMusicPlayerTool *_instance = nil;
+ (instancetype)sharedPlayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.playingMode = GSMPPlayingModeListLoop;
    });
    
    return _instance ;
}

- (void)setPlayingSongModel:(GSSongModel *)playingSongModel {
    _playingSongModel = playingSongModel;
    self.songMessageModel = [[GSSongMessageModel alloc] init];
    self.songMessageModel.songModel = playingSongModel;
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:playingSongModel.songPath] error:&error];
    if (_player) {
        [_player prepareToPlay];
        [self play];
        self.playing = YES;
    } else {
        self.playing = NO;
        NSLog(@"error:%@", error);
        NSLog(@"%@", playingSongModel.songPath);
    }
}

- (void)setLockScreenInfo {
    // 1.获取当前正在播放的歌曲
    GSSongMessageModel *songMessageModel = [self getSongMessageModel];
    // 2.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 3.设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    
    playingInfo[MPMediaItemPropertyAlbumTitle] = songMessageModel.songModel.title;
    playingInfo[MPMediaItemPropertyArtist] = songMessageModel.songModel.artist;
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:songMessageModel.songModel.coverImage];
    playingInfo[MPMediaItemPropertyArtwork] = artwork;
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(songMessageModel.totalTime);
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(songMessageModel.costTime);
    
    playingCenter.nowPlayingInfo = playingInfo;
}

- (GSSongMessageModel *)getSongMessageModel {
    self.songMessageModel.costTime = _player.currentTime;
    self.songMessageModel.totalTime = _player.duration;
    self.songMessageModel.songModel = self.playingSongModel;
    
    return self.songMessageModel;
}

- (void)play {
    [_player play];
    self.playing = YES;
}

- (void)pause {
    [_player pause];
    self.playing = NO;
}

- (void)replay {
    [_player playAtTime:0.0];
    self.playing = YES;
}

- (void)seekTo:(NSTimeInterval)time {
    _player.currentTime = time;
}

- (void)preMusic {
    switch (self.playingMode) {
        case GSMPPlayingModeRandomPlay: {
            self.playingIndex = arc4random() % self.playingMenu.count;
        }
            break;
            
        default: {
            self.playingIndex -= 1;
            if (self.playingIndex < 0) {
                self.playingIndex = self.playingMenu.count - 1;
            }
        }
            break;
    }
    
    GSSongModel *songModel = [[GSSongModel alloc] init];
    songModel.songPath = self.playingMenu[self.playingIndex];
    self.playingSongModel = songModel;
}

- (void)nextMusic {
    switch (self.playingMode) {
        case GSMPPlayingModeRandomPlay: {
            self.playingIndex = arc4random() % self.playingMenu.count;
        }
            break;
            
        default: {
            self.playingIndex += 1;
            if (self.playingIndex >= self.playingMenu.count) {
                self.playingIndex = 0;
            }
        }
            break;
    }
    
    GSSongModel *songModel = [[GSSongModel alloc] init];
    songModel.songPath = self.playingMenu[self.playingIndex];
    self.playingSongModel = songModel;
}

- (void)resetPlayingMenu:(NSArray *)songModelArr {
    [self.playingMenu removeAllObjects];
    for (NSString *songPath in songModelArr) {
        [self.playingMenu addObject:songPath];
    }
    NSLog(@"%@", self.playingMenu);
}

- (void)addPlayingMenu:(NSArray *)songModelArr {
    for (NSString *songPath in songModelArr) {
        [self.playingMenu addObject:songPath];
    }
}

- (GSMPPlayingMode)changePlayingMode {
    switch (self.playingMode) {
        case GSMPPlayingModeRandomPlay:
            self.playingMode = GSMPPlayingModeListLoop;
            break;
        
        case GSMPPlayingModeListLoop:
            self.playingMode = GSMPPlayingModeSingleLoop;
            break;
            
        case GSMPPlayingModeSingleLoop:
            self.playingMode = GSMPPlayingModeRandomPlay;
            break;
            
        default:
            break;
    }
    
    return self.playingMode;
}

- (GSMPPlayingMode)getPlayingMode {
    return self.playingMode;
}

- (NSMutableArray<GSSongModel *> *)playingMenu {
    if (!_playingMenu) {
        _playingMenu = [[NSMutableArray alloc] init];
    }
    
    return _playingMenu;
}

@end
