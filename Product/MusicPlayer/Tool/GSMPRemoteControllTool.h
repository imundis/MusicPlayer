//
//  GSMPRemoteControllTool.h
//  Product
//
//  Created by guo on 2018/8/29.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GSMPRemoteControllToolEvent) {
    GSMPRemoteControllToolEventPlay,
    GSMPRemoteControllToolEventPause,
    GSMPRemoteControllToolEventPreMusic,
    GSMPRemoteControllToolEventNextMusic
};

@interface GSMPRemoteControllTool : NSObject

+ (instancetype)defaultInstance;

- (void)startUpdateLockScreenInfo;
- (void)remoteCotrollerWithEvent:(GSMPRemoteControllToolEvent)event;

@end
