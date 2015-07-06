//
//  OSCObjsViewController.m
//  iosapp
//
//  Created by chenhaoxiang on 10/27/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OSCObjsViewController.h"
#import "TTConstant.h"
#import "BaseObject.h"

#import <MBProgressHUD.h>

@interface OSCObjsViewController ()

@property(nonatomic, assign) BOOL refreshInProgress;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end


@implementation OSCObjsViewController


- (instancetype)init {
    self = [super init];

    if (self) {
        _objects = [NSMutableArray new];
        _page = 0;
        _needRefreshAnimation = YES;
        _shouldFetchDataAfterLoaded = YES;
    }

    return self;
}

- (void)dawnAndNightMode:(NSNotification *)center {
    _lastCell.textLabel.backgroundColor = [UIColor themeColor];
    _lastCell.textLabel.textColor = [UIColor titleColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationTheme object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:kNSNotificationTheme object:nil];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.tableView.backgroundColor = [UIColor themeColor];

    _lastCell = [[LastCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchMore)]];
    self.tableView.tableFooterView = _lastCell;

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];

    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont boldSystemFontOfSize:14];
    _lastCell.textLabel.textColor = [UIColor titleColor];

    _manager = [AFHTTPRequestOperationManager OSCManager];

    if (!_shouldFetchDataAfterLoaded) {return;}
    if (_needRefreshAnimation) {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl.frame.size.height)
                                animated:YES];
    }

    if (_needCache) {
        _manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    [self fetchObjectsOnPage:0 refresh:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.separatorColor = [UIColor separatorColor];

    return _objects.count;
}

/*
// 这个方法会导致reloadData时，tableview自动滑动到底部
// 暂时还没发现好的解决方法，只好不用这个方法了
// http://stackoverflow.com/questions/22753858/implementing-estimatedheightforrowatindexpath-causes-the-tableview-to-scroll-do
 
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
*/




#pragma mark - 刷新

- (void)refresh {
    _refreshInProgress = NO;

    if (!_refreshInProgress) {
        _refreshInProgress = YES;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            [self fetchObjectsOnPage:0 refresh:YES];
            _refreshInProgress = NO;
        });

        //刷新时，增加另外的网络请求功能
        if (self.anotherNetWorking) {
            self.anotherNetWorking();
        }
    }
}


#pragma mark - 上拉加载更多

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))) {
        [self fetchMore];
    }
}

- (void)fetchMore {
    if (!_lastCell.shouldResponseToTouch) {return;}

    _lastCell.status = LastCellStatusLoading;
    _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self fetchObjectsOnPage:++_page refresh:NO];
}


#pragma mark - 请求数据

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh {
    [_manager GET:self.generateURL(page)
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseDocument) {
              Boolean success = [[responseDocument valueForKeyPath:@"success"] boolValue];
              if (!success) {
                  return;
              }

              _allCount = [[responseDocument valueForKeyPath:@"allCount"] intValue];
              //NSArray *array;
              NSArray *array = [self parseXML:responseDocument];//[self getArray:responseDocument];
              //

              if (refresh) {
                  _page = 0;
                  [_objects removeAllObjects];
                  if (_didRefreshSucceed) {_didRefreshSucceed();}
              }


              if (_parseExtraInfo) {_parseExtraInfo(responseDocument);}

              [self addObjects:array];

              dispatch_async(dispatch_get_main_queue(), ^{
                  if (self.tableWillReload) {self.tableWillReload(array.count);}
                  else {
                      if (_page == 0 && array.count == 0) {
                          _lastCell.status = LastCellStatusEmpty;
                      } else if (array.count == 0 || (_page == 0 && array.count < 20)) {
                          _lastCell.status = LastCellStatusFinished;
                      } else {
                          _lastCell.status = LastCellStatusMore;
                      }
                  }

                  if (self.refreshControl.refreshing) {
                      [self.refreshControl endRefreshing];
                  }

                  [self.tableView reloadData];
              });
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              MBProgressHUD *HUD = [Utils createHUD];
              HUD.mode = MBProgressHUDModeCustomView;
              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
              HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];

              [HUD hide:YES afterDelay:1];

              _lastCell.status = LastCellStatusError;
              if (self.refreshControl.refreshing) {
                  [self.refreshControl endRefreshing];
              }
              [self.tableView reloadData];
          }
    ];
}

- (void)addObjects:(NSArray *)array {

    NSAssert(false, @"");
}

//- (NSArray *)getArray:(id)responseDocument {
//    NSArray *array = [responseDocument objectForKey:@"data"];
//    return array;
//}


- (NSArray *)parseXML:(id)responseDocument{
    NSAssert(false, @"Over ride in subclasses");
    return nil;
}


@end
