//
// Created by yangjiandong on 15/7/4.
// Copyright (c) 2015 tt.org. All rights reserved.
//

#import "MainTabBarController.h"
#import "TTConstant.h"
#import "UIColor+Util.h"


@implementation MainTabBarController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:kNSNotificationTheme object:nil];
}

- (void)dawnAndNightMode:(NSNotification *)center {
    //myTweetViewCtl.view.backgroundColor = [UIColor themeColor];

    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor titleBarColor]];

    [self.viewControllers enumerateObjectsUsingBlock:^(UINavigationController *nav, NSUInteger idx, BOOL *stop) {

    }
    ];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationTheme object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end