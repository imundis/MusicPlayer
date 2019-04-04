//
//  GSMPImportViewController.m
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSMPImportViewController.h"
#import "GSHTTPTool.h"
#import "GSHTTPConnection.h"

#import <HTTPServer.h>

@interface GSMPImportViewController () {
    HTTPServer *httpServer;
}

@property (weak, nonatomic) IBOutlet UILabel *successHintLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *failHintLable;

@end

@implementation GSMPImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initServer {
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    // webPath是server搜寻HTML等文件的路径
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    [httpServer setDocumentRoot:webPath];
    [httpServer setConnectionClass:[GSHTTPConnection class]];
    NSError *error;
    if ([httpServer start:&error]) {
        [self.successHintLabel setHidden:false];
        [self.addressTextField setHidden:false];
        [self.failHintLable setHidden:true];
        NSLog(@"http://%@:%hu", [GSHTTPTool getIPAddress:YES], [httpServer listeningPort]);
        [self.addressTextField setText:[NSString stringWithFormat:@"http://%@:%hu", [GSHTTPTool getIPAddress:YES], [httpServer listeningPort]]];
    }else {
        [self.successHintLabel setHidden:true];
        [self.addressTextField setHidden:true];
        [self.failHintLable setHidden:false];
        NSLog(@"%@", error);
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
