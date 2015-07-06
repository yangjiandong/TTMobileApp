//
// Created by yangjiandong on 15/7/4.
// Copyright (c) 2015 tt.org. All rights reserved.
//

#import "MainTabBarController.h"
#import "TTConstant.h"
#import "UIColor+Util.h"
#import "NewsViewController.h"
#import "SwipableViewController.h"
#import "SearchViewController.h"

#import <RESideMenu/RESideMenu.h>

@interface MainTabBarController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NewsViewController *nvst;
    NewsViewController *nvst2;
}

@property(nonatomic, strong) UIView *dimView;
@property(nonatomic, strong) UIImageView *blurView;
@property(nonatomic, assign) BOOL isPressed;
@property(nonatomic, strong) NSMutableArray *optionButtons;
@property(nonatomic, strong) UIDynamicAnimator *animator;

@property(nonatomic, assign) CGFloat screenHeight;
@property(nonatomic, assign) CGFloat screenWidth;
@property(nonatomic, assign) CGGlyph length;

@end

@implementation MainTabBarController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:kNSNotificationTheme object:nil];
}

- (void)dawnAndNightMode:(NSNotification *)center {
    nvst.view.backgroundColor = [UIColor themeColor];
    nvst2.view.backgroundColor = [UIColor themeColor];

    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor titleBarColor]];

    [self.viewControllers enumerateObjectsUsingBlock:^(UINavigationController *nav, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            SwipableViewController *newsVc = nav.viewControllers[0];
            [newsVc.titleBar setTitleButtonsColor];
            [newsVc.viewPager.controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UITableViewController *table = obj;
                [table.navigationController.navigationBar setBarTintColor:[UIColor navigationbarColor]];
                [table.tabBarController.tabBar setBarTintColor:[UIColor titleBarColor]];
                [table.tableView reloadData];
            }];

        } else if (idx == 1) {

        }
    }
    ];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationTheme object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    nvst = [[NewsViewController alloc] initWithNewsListType:NewsListTypeNews];
    nvst2 = [[NewsViewController alloc] initWithNewsListType:NewsListTypeNews];

    nvst.needCache = YES;
    nvst2.needCache = YES;

    SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"综合"
                                                                       andSubTitles:@[@"资讯", @"热点", @"博客", @"推荐"]
                                                                     andControllers:@[nvst, nvst2, nvst, nvst2]
                                                                        underTabbar:YES];

    self.tabBar.translucent = NO;
    self.viewControllers = @[
            [self addNavigationItemForViewController:newsSVC],
            [self addNavigationItemForViewController:newsSVC],
            [UIViewController new],
            [self addNavigationItemForViewController:newsSVC],
            [self addNavigationItemForViewController:newsSVC]
            //[[UINavigationController alloc] initWithRootViewController:myInfoVC]
    ];
}


#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];

    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-search"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(pushSearchViewController)];



    return navigationController;
}

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.selectedIndex <= 1 && self.selectedIndex == [tabBar.items indexOfObject:item]) {
        SwipableViewController *swipeableVC = (SwipableViewController *)((UINavigationController *)self.selectedViewController).viewControllers[0];
        OSCObjsViewController *objsViewController = (OSCObjsViewController *)swipeableVC.viewPager.childViewControllers[swipeableVC.titleBar.currentIndex];

        [UIView animateWithDuration:0.1 animations:^{
            [objsViewController.tableView setContentOffset:CGPointMake(0, -objsViewController.refreshControl.frame.size.height)];
        } completion:^(BOOL finished) {
            [objsViewController.refreshControl beginRefreshing];
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [objsViewController refresh];
        });
    }
}

#pragma mark - 处理左右navigationItem点击事件

- (void)pushSearchViewController
{
    [(UINavigationController *)self.selectedViewController pushViewController:[SearchViewController new] animated:YES];
}

@end