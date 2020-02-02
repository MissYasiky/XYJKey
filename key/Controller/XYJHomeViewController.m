//
//  XYJHomeViewController.m
//  key
//
//  Created by MissYasiky on 2020/1/31.
//  Copyright © 2020 netease. All rights reserved.
//

#import "XYJHomeViewController.h"
#import "XYJSettingViewController.h"
#import "XYJCardListViewController.h"
#import "XYJAccountListViewController.h"
#import "XYJHomeTabBar.h"

@interface XYJHomeViewController () <
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
XYJHomeTabBarDelegate
>

@property (nonatomic, strong) XYJHomeTabBar *tabBar;

/// 翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;

/// 子视图控制器数组
@property (nonatomic, strong) NSMutableArray <UIViewController *> *vctrlArray;

/// 选中 tab 索引
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation XYJHomeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    [self initTabBar];
    [self initViewControllers];
    [self initPageViewControllers];
    [self initAddButton];
}

#pragma mark - Initialization

- (void)initNavigationBar {
    self.title = @"MY KEY";
    
    // 菜单页按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"nav_btn_menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *menuItem =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = menuItem;

    // 返回按钮统一配置
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIImage *backImage = [UIImage imageNamed:@"nav_btn_back"];
    self.navigationController.navigationBar.backIndicatorImage = backImage;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage;
    
    // 设置手势返回上一页
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initTabBar {
    CGFloat originY = self.navigationController.navigationBar.frame.origin.y +  self.navigationController.navigationBar.frame.size.height;
    self.tabBar = [[XYJHomeTabBar alloc] initWithFrame:CGRectMake(0, originY, XYJScreenWidth(), 35)];
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
}

- (void)initViewControllers {
    self.vctrlArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    XYJCardListViewController *vctrl1 = [[XYJCardListViewController alloc] init];
    [self.vctrlArray addObject:vctrl1];
    
    XYJAccountListViewController *vctrl2 = [[XYJAccountListViewController alloc] init];
    [self.vctrlArray addObject:vctrl2];
}

- (void)initPageViewControllers {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                  options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    float originX = 0;
    float originY = self.tabBar.frame.origin.y + self.tabBar.frame.size.height;
    float width = XYJScreenWidth();
    float height = XYJScreenHeight() - originY;
    self.pageViewController.view.frame = CGRectMake(originX, originY, width, height);
    
    NSArray *initControllers = @[self.vctrlArray[0]];
    [self.pageViewController setViewControllers:initControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    
    self.pageViewController.view.clipsToBounds = NO;
    for (UIView *subview in self.pageViewController.view.subviews) {
        subview.clipsToBounds = NO;
    }
}

- (void)initAddButton {
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"home_btn_add"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    CGFloat width = 55;
    CGFloat delta = 25 + width;
    self.addButton.frame = CGRectMake(XYJScreenWidth() - delta, XYJScreenHeight() - delta, width, width);
}

#pragma mark - Action

- (void)menuButtonAction {
    XYJSettingViewController *vctrl = [[XYJSettingViewController alloc] init];
    [self.navigationController pushViewController:vctrl animated:YES];
}

- (void)addButtonAction {
    NSLog(@"add %@", self.selectedIndex == 0 ? @"card" : @"account");
}

#pragma mark - Private

#pragma mark Private - ViewCtrollers Related

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.vctrlArray.count ) {
        return nil;
    }
    return self.vctrlArray[index];
}

-(NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.vctrlArray indexOfObject:viewController];
}

#pragma mark - XYJHomeTabBar Delegate

- (void)selectTabBarAtIndex:(NSInteger)index {
    if (index < 0 || index >= [self.vctrlArray count]) {
        return;
    }
    
    self.selectedIndex = index;
    // 跳转到指定页面
    NSArray *showController = @[self.vctrlArray[self.selectedIndex]];
    [self.pageViewController setViewControllers:showController direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewController DataSource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index --;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound ) {
        return nil;
    }
    
    index ++;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewController Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSUInteger index = [self indexOfViewController:pendingViewControllers.firstObject];
    self.selectedIndex = index;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        [self.tabBar selectedAtIndex:self.selectedIndex];
    }
}


@end
