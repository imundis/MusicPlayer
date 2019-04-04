//
//  SongModel.m
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSSongModel.h"

#import <AVFoundation/AVFoundation.h>

@interface GSSongModel() {
    AVURLAsset *_asset;
}

@end

@implementation GSSongModel

- (void)setSongPath:(NSString *)songPath {
    _songPath = songPath;
    NSURL *songUrl = [NSURL fileURLWithPath:songPath];
    _asset = [[AVURLAsset alloc] initWithURL:songUrl options:nil];
    for (NSString *format in [_asset availableMetadataFormats]){
        for (AVMetadataItem *metadata in [_asset metadataForFormat:format]){
            if ([metadata.commonKey isEqualToString:@"title"]){
                self.title = (NSString *)metadata.value;//提取歌曲名
            }
            if ([metadata.commonKey isEqualToString:@"artist"]){
                self.artist = (NSString *)metadata.value;//提取歌手名
            }
            if ([metadata.commonKey isEqualToString:@"artwork"]) {
//                NSLog(@"%@", metadata.value);
                self.coverImageData = (NSData *)metadata.value;//提取图片信息
            }
        }
    }
}

@end
