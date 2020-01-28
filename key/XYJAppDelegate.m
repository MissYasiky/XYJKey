//
//  XYJAppDelegate.m
//  key
//
//  Created by MissYasiky on 2018/11/2.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "XYJAppDelegate.h"
#import "XYJSecrecyManager.h"
#import "XYJPasswordViewController.h"
#import "XYJViewController.h"
#import "RetainCycleLoggerPlugin.h"
#import <FBMemoryProfiler/FBMemoryProfiler.h>

@implementation XYJAppDelegate {
    FBMemoryProfiler *_memoryProfiler;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#if XYJ_PassWord_Necessary
    XYJPasswordViewController *vctrl = [[XYJPasswordViewController alloc] init];
    self.window.rootViewController = vctrl;
#else
    XYJViewController *vctrl = [[XYJViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vctrl];
    self.window.rootViewController = navi;
#endif
    [self.window makeKeyAndVisible];
    
    FBObjectGraphConfiguration *configuration = [[FBObjectGraphConfiguration alloc] initWithFilterBlocks:@[] shouldInspectTimers:NO];
    _memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[RetainCycleLoggerPlugin new]]
                               retainCycleDetectorConfiguration:configuration];
    [_memoryProfiler enable];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self lockApp];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self lockApp];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private

- (void)lockApp {
    #if XYJ_PassWord_Necessary
        if ([self.window.rootViewController isKindOfClass:[XYJPasswordViewController class]] ||
            [XYJSecrecyManager sharedManager].unlock) {
            return;
        }
        XYJPasswordViewController *vctrl = [[XYJPasswordViewController alloc] init];
        self.window.rootViewController = vctrl;
    #endif
}

@end
