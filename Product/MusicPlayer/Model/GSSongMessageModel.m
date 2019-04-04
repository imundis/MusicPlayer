//
//  GSSongMessageModel.m
//  Product
//
//  Created by guo on 2018/8/27.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSSongMessageModel.h"
#import "GSTimeTool.h"

@implementation GSSongMessageModel

- (NSString *)costTimeFormat{
    
    return [GSTimeTool getFormatTime:self.costTime];
}

- (NSString *)totalTimeFormat{
    
    return [GSTimeTool getFormatTime:self.totalTime];
}


@end
