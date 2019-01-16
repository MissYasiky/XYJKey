//
//  main.m
//  key
//
//  Created by MissYasiky on 2018/11/2.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYJAppDelegate.h"
#import <FBAllocationTracker/FBAllocationTracker.h>

int main(int argc, char * argv[]) {
    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
    [[FBAllocationTrackerManager sharedManager] enableGenerations];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([XYJAppDelegate class]));
    }
}
