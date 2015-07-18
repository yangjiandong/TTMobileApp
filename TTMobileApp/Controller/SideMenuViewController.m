//
//  SideMenuViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 1/31/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "SideMenuViewController.h"
#import "Config.h"
#import "Utils.h"

#import "AppDelegate.h"

#import <RESideMenu.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <ReactiveCocoa.h>

@interface SideMenuViewController ()

//@property (nonatomic, strong) UIViewController *reservedViewController;


@end

@implementation SideMenuViewController

static BOOL isNight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"userRefresh" object:nil];
    
    self.tableView.bounces = NO;
    
    self.tableView.backgroundColor = [UIColor titleBarColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];

}

- (void)dawnAndNightMode:(NSNotification *)center
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *usersInformation = [Config getUsersInformation];
    UIImage *portrait = [Config getPortrait];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *portraitView = [UIImageView new];
    portraitView.contentMode = UIViewContentModeScaleAspectFit;
    [portraitView setCornerRadius:30];
    portraitView.userInteractionEnabled = YES;
    portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:portraitView];
    
    if (portrait == nil) {
        portraitView.image = [UIImage imageNamed:@"default-portrait"];
    } else {
        portraitView.image = portrait;
    }
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = usersInformation[0];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        nameLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    } else {
        nameLabel.textColor = [UIColor colorWithHex:0x696969];
    }
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(portraitView, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[portraitView(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[portraitView(60)]" options:0 metrics:metrics views:views]];
    
    portraitView.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
        
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *selectedBackground = [UIView new];
        selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
        [cell setSelectedBackgroundView:selectedBackground];
        
        cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_QA", @"sidemenu-software", @"sidemenu_blog", @"sidemenu_setting", @"sidemenu-night"][indexPath.row]];
        cell.textLabel.text = @[@"技术问答", @"开源软件", @"博客区", @"设置", @"夜间模式", @"注销"][indexPath.row];
        
        if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
            cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
            if (indexPath.row == 4) {
                cell.textLabel.text = @"日间模式";
                cell.imageView.image = [UIImage imageNamed:@"sidemenu-day"];
            }
        } else {
            cell.textLabel.textColor = [UIColor colorWithHex:0x555555];
            if (indexPath.row == 4) { 
                cell.textLabel.text = @"夜间模式";
                cell.imageView.image = [UIImage imageNamed:@"sidemenu-night"];
            }
        }
        cell.textLabel.font = [UIFont systemFontOfSize:19];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {

            
            break;
        }
        case 1: {


            
            break;
        }
        case 2: {


            
            break;
        }
        case 3: {


            break;
        }
        case 4: {
            isNight = [Config getMode];
            if (isNight) {
                ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = NO;
            } else {
                ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = YES;
            }
            self.tableView.backgroundColor = [UIColor titleBarColor];
            [Config saveWhetherNightMode:!isNight];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dawnAndNight" object:nil];
//            isNight = !isNight;
        }
        default: break;
    }
}


- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    //UIViewController *vc = nav.viewControllers[0];
    //vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [nav pushViewController:viewController animated:NO];
    
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - 点击登录

- (void)pushLoginPage
{
    if ([Config getOwnID] == 0) {
        //[self setContentViewController:[LoginViewController new]];
    } else {
        return;
    }
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
