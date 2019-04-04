//
//  GSHTTPConnection.h
//  Product
//
//  Created by guo on 2018/8/22.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "HTTPConnection.h"
@class MultipartFormDataParser;

@interface GSHTTPConnection : HTTPConnection {
    MultipartFormDataParser *parser;
    NSFileHandle *storeFile;
    NSMutableArray *uploadedFiles;
}

@end
