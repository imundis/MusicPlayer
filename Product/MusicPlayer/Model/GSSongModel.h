//
//  SongModel.h
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GSSongModel : NSObject

@property (copy, nonatomic) NSString *songPath;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *artist;
@property (strong, nonatomic) NSData *coverImageData;

@end
