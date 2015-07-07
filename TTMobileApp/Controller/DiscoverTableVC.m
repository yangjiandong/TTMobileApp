//
//  DiscoverTableVC.m
//  iosapp
//
//  Created by chenhaoxiang on 11/28/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "DiscoverTableVC.h"
#import "UIColor+Util.h"
//#import "EventsViewController.h"
//#import "PersonSearchViewController.h"
//#import "ScanViewController.h"
//#import "ShakingViewController.h"
#import "SearchViewController.h"
//#import "ActivitiesViewController.h"
#import "Config.h"

@interface DiscoverTableVC ()

@end

@implementation DiscoverTableVC

- (void)dawnAndNightMode
{
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"发现";
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.clearsSelectionOnViewWillAppear = NO;
//    self.tableView.separatorColor = [UIColor colorWithHex:0xDDDDDD];
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    
    //self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:  return 1;
        case 1:  return 2;
        case 2:  return 2;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    cell.backgroundColor = [UIColor cellsColor];
    cell.textLabel.textColor = [UIColor titleColor];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"好友圈";
            cell.imageView.image = [UIImage imageNamed:@"discover-events"];
            break;
        case 1:
            cell.textLabel.text = @[@"找人", @"活动"][indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@[@"discover-search", @"discover-activities"][indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = @[@"扫一扫", @"摇一摇"][indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@[@"discover-scan", @"discover-shake"][indexPath.row]];
            break;
        default: break;
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}



@end
