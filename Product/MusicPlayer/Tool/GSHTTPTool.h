//
//  GSHTTPTool.h
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSHTTPTool : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSDictionary *)getIPAddresses;

@end
