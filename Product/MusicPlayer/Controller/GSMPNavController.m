//
//  GSMPNavController.m
//  Product
//
//  Created by guo on 2018/8/24.
//  Copyright © 2018年 guoshuai. All rights reserved.
//

#import "GSMPNavController.h"

@implementation GSMPNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIViewController *viewController = self.topViewController;
    viewController.navigationItem.backBarButtonItem = backItem;
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回键"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回键"];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ([NSStringFromClass([self topViewController].class) isEqualToString:@"GSMPImportViewController"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSongMenuNotification" object:nil];
    }
    
    return [super popViewControllerAnimated:animated];
}

@end
