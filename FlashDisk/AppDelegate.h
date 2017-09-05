//
//  AppDelegate.h
//  FlashDisk
//
//  Created by daxin on 16/2/26.
//  Copyright © 2016年 bitlight. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VLCMenuTableViewController.h"
//#import "VLCDownloadViewController.h"

@class VLCLibraryViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) VLCLibraryViewController* libraryViewController;

@property (nonatomic, readonly) BOOL    passcodeValidated;

@end

