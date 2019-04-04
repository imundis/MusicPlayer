//
//  GSMPRemoteControllTool.m
//  Product
//
//  Created by guo on 2018/8/29.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSMPRemoteControllTool.h"
#import "GSMusicPlayerTool.h"
#import "GSSongMessageModel.h"
#import "GSSongModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GSMPRemoteControllTool() <NSCopying, NSMutableCopying> {
    NSTimer *_timer;
}

@end

@implementation GSMPRemoteControllTool

static GSMPRemoteControllTool *_instance;
+ (instancetype)defaultInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [GSMPRemoteControllTool defaultInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [GSMPRemoteControllTool defaultInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [GSMPRemoteControllTool defaultInstance];
}

- (void)startUpdateLockScreenInfo {
    _timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        GSMusicPlayerTool *playerTool = [GSMusicPlayerTool sharedPlayer];
        if (playerTool.playingSongModel) {
            GSSongMessageModel *songMessageModel = [playerTool getSongMessageModel];
            MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
            NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
            playingInfo[MPMediaItemPropertyAlbumTitle] = songMessageModel.songModel.title;
            playingInfo[MPMediaItemPropertyArtist] = songMessageModel.songModel.artist;
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:songMessageModel.songModel.coverImage];
            playingInfo[MPMediaItemPropertyArtwork] = artwork;
            playingInfo[MPMediaItemPropertyPlaybackDuration] = @(songMessageModel.totalTime);
            playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(songMessageModel.costTime);
            playingCenter.nowPlayingInfo = playingInfo;
        }
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)remoteCotrollerWithEvent:(GSMPRemoteControllToolEvent)event {
    GSMusicPlayerTool *playerTool = [GSMusicPlayerTool sharedPlayer];
    if (playerTool.playingSongModel) {
        switch (event) {
            case GSMPRemoteControllToolEventPlay:
                [playerTool play];
                break;
                
            case GSMPRemoteControllToolEventPause:
                [playerTool pause];
                break;
                
            case GSMPRemoteControllToolEventPreMusic:
                [playerTool preMusic];
                break;
                
            case GSMPRemoteControllToolEventNextMusic:
                [playerTool nextMusic];
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupDataByRemoteControll" object:nil];
    }
}

@end
