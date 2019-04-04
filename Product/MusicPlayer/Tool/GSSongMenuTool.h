//
//  SongMenuTool.h
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSongMenuTool : NSObject

+ (instancetype)defaultTool;

- (BOOL)createDefaultDir;
- (NSMutableArray *)getSongMenuArr;

@end
