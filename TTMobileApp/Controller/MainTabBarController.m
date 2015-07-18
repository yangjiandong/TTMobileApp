#import "MainTabBarController.h"
#import "TTConstant.h"
#import "UIColor+Util.h"
#import "NewsViewController.h"
#import "SwipableViewController.h"
#import "SearchViewController.h"
#import "DiscoverTableVC.h"
#import "MyInfoViewController.h"
#import "OptionButton.h"

#import <RESideMenu/RESideMenu.h>

@interface MainTabBarController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NewsViewController *nvst;
    NewsViewController *nvst2;
    NewsViewController *nvst3;
    NewsViewController *nvst4;
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
    nvst3.view.backgroundColor = [UIColor themeColor];
    nvst4.view.backgroundColor = [UIColor themeColor];

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
    nvst2 = [[NewsViewController alloc] initWithNewsListType:NewsListTypeSynthesis];
    nvst3 = [[NewsViewController alloc] initWithNewsListType:NewsListTypeSoftwareRenew];
    nvst4 = [[NewsViewController alloc] initWithNewsListType:NewsListTypeNews];

    nvst.needCache = YES;
    nvst2.needCache = YES;

    SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"综合"
                                                                       andSubTitles:@[@"资讯", @"热点", @"推荐"]
                                                                     andControllers:@[nvst, nvst2, nvst3]
                                                                        underTabbar:YES];

    SwipableViewController *newsSVC2 = [[SwipableViewController alloc] initWithTitle:@"ff"
                                                                        andSubTitles:@[@"博客"]
                                                                      andControllers:@[nvst4]
                                                                         underTabbar:YES];

    DiscoverTableVC *discoverTableVC = [[DiscoverTableVC alloc] initWithStyle:UITableViewStyleGrouped];
    MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];

    self.tabBar.translucent = NO;
    self.viewControllers = @[
            [self addNavigationItemForViewController:newsSVC],
            [self addNavigationItemForViewController:newsSVC2],
            [UIViewController new],
            [self addNavigationItemForViewController:discoverTableVC],
            [[UINavigationController alloc] initWithRootViewController:myInfoVC]
    ];

    NSArray *titles = @[@"综合", @"动弹", @"", @"发现", @"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    [self.tabBar.items[2] setEnabled:NO];

    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];

    [self.tabBar addObserver:self
                  forKeyPath:@"selectedItem"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];

    // 功能键相关
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 60;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    NSArray *buttonTitles = @[@"文字", @"相册", @"拍照", @"语音", @"扫一扫", @"找人"];
    NSArray *buttonImages = @[@"tweetEditing", @"picture", @"shooting", @"sound", @"scan", @"search"];
    int buttonColors[] = {0xe69961, 0x0dac6b, 0x24a0c4, 0xe96360, 0x61b644, 0xf1c50e};

    for (int i = 0; i < 6; i++) {
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:buttonTitles[i]
                                                                   image:[UIImage imageNamed:buttonImages[i]]
                                                                andColor:[UIColor colorWithHex:buttonColors[i]]];

        optionButton.frame = CGRectMake((_screenWidth/6 * (i%3*2+1) - (_length+16)/2),
                _screenHeight + 150 + i/3*100,
                _length + 16,
                _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];

        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];

        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }
}


- (void)addCenterButtonWithImage:(UIImage *)buttonImage {
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];

    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);

    _centerButton.frame = CGRectMake(origin.x - buttonSize.height / 2, origin.y - buttonSize.height / 2, buttonSize.height, buttonSize.height);

    [_centerButton setCornerRadius:buttonSize.height / 2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.tabBar addSubview:_centerButton];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"selectedItem"]) {
        if (self.isPressed) {[self buttonPressed];}
    }
}


- (void)buttonPressed {
    [self changeTheButtonStateAnimatedToOpen:_isPressed];

    _isPressed = !_isPressed;
}


- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        [self removeBlurView];

        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];

            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                 _screenHeight + 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];

        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];

            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                 _screenHeight - 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}


- (void)addBlurView
{
    _centerButton.enabled = NO;

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 270, screenSize.width, screenSize.height);

    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];

    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
    _blurView.frame = cropRect;
    _blurView.userInteractionEnabled = YES;
    [self.view addSubview:_blurView];

    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
    [self.view insertSubview:_dimView belowSubview:self.tabBar];

    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];

    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if (finished) {_centerButton.enabled = YES;}
                     }];
}


- (void)removeBlurView
{
    _centerButton.enabled = NO;

    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             _dimView = nil;

                             [self.blurView removeFromSuperview];
                             self.blurView = nil;
                             _centerButton.enabled = YES;
                         }
                     }];
}


#pragma mark - 处理点击事件

- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 0: {
            break;
        }
        case 1: {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = NO;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

            [self presentViewController:imagePickerController animated:YES completion:nil];

            break;
        }
        case 2: {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Device has no camera"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];

                [alertView show];
            } else {
                UIImagePickerController *imagePickerController = [UIImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = NO;
                imagePickerController.showsCameraControls = YES;
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            break;
        }
        case 3: {

            break;
        }
        case 4: {
            break;
        }
        case 5: {
            break;
        }
        default: break;
    }

    [self buttonPressed];
}

#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController {

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self action:@selector(onClickMenuButton)];

    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-search"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(pushSearchViewController)];


    return navigationController;
}

- (void)onClickMenuButton {
    [self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (self.selectedIndex <= 1 && self.selectedIndex == [tabBar.items indexOfObject:item]) {
        SwipableViewController *swipeableVC = (SwipableViewController *) ((UINavigationController *) self.selectedViewController).viewControllers[0];
        OSCObjsViewController *objsViewController = (OSCObjsViewController *) swipeableVC.viewPager.childViewControllers[swipeableVC.titleBar.currentIndex];

        [UIView animateWithDuration:0.1 animations:^{
            [objsViewController.tableView setContentOffset:CGPointMake(0, -objsViewController.refreshControl.frame.size.height)];
        }                completion:^(BOOL finished) {
            [objsViewController.refreshControl beginRefreshing];
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [objsViewController refresh];
        });
    }
}

#pragma mark - 处理左右navigationItem点击事件

- (void)pushSearchViewController {
    [(UINavigationController *) self.selectedViewController pushViewController:[SearchViewController new] animated:YES];
}

@end