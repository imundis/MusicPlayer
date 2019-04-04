//
//  GSTimeTool.m
//  Product
//
//  Created by guo on 2018/8/27.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSTimeTool.h"

@implementation GSTimeTool

+ (NSString *)getFormatTime:(NSTimeInterval)time{
    
    // time 123
    // 03:12
    
    NSInteger min = time / 60;
    NSInteger second = time - min * 60;
    
    NSString *result = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)second];
    
    return result;
}

+ (NSTimeInterval)getTimeInterval:(NSString *)formatTime {
    
    // 00:00.89  -> 多少秒
    NSArray *minAndSec = [formatTime componentsSeparatedByString:@":"];
    if (minAndSec.count == 2) {
        
        // 分钟
        NSTimeInterval min = [minAndSec[0] doubleValue];
        // 秒数
        NSTimeInterval sec = [minAndSec[1] doubleValue];
        
        return min * 60 + sec;
    }
    
    return 0;
}

@end
