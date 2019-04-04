//
//  SongMenuTool.m
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSSongMenuTool.h"

#define SONG_DIR [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"MusicPlayer"]

@implementation GSSongMenuTool

static GSSongMenuTool *_instance = nil;
+ (instancetype)defaultTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance ;
}

- (BOOL)createDefaultDir {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL isDirExist = [fileManager fileExistsAtPath:SONG_DIR isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:SONG_DIR withIntermediateDirectories:YES attributes:nil error:nil];
        return bCreateDir;
    }
    return true;
}

- (NSMutableArray *)getSongMenuArr {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:SONG_DIR];
    NSString *fileName;
    NSMutableArray *songMenuArr = [[NSMutableArray alloc] init];
    while (fileName = [dirEnum nextObject]) {
        if ([[fileName pathExtension] isEqualToString:@"mp3"]) {
            [songMenuArr addObject:[SONG_DIR stringByAppendingPathComponent:fileName]];
        }
    }
    
    return songMenuArr;
}

@end
