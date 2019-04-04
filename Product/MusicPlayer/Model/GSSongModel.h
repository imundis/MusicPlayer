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

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) UIImage *coverImage;

@end
