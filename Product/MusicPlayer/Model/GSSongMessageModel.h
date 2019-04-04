//
//  GSSongMessageModel.h
//  Product
//
//  Created by guo on 2018/8/27.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSSongModel;
@interface GSSongMessageModel : NSObject

@property (strong, nonatomic) GSSongModel *songModel;

@property (assign, nonatomic) NSTimeInterval costTime;
@property (assign, nonatomic) NSTimeInterval totalTime;

/** 当前播放时长 字符串格式*/
@property (nonatomic, strong, readonly) NSString *costTimeFormat;
/** 歌曲总时长 字符串格式*/
@property (nonatomic, strong, readonly) NSString *totalTimeFormat;

@end
