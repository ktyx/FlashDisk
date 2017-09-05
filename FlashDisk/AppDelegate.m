//
//  AppDelegate.m
//  FlashDisk
//
//  Created by daxin on 16/2/26.
//  Copyright © 2016年 bitlight. All rights reserved.
//

#import "AppDelegate.h"
#import "VLCMediaFileDiscoverer.h"
#import "VLCKeychainCoordinator.h"
#import "VLCLibraryViewController.h"
#import "VLCPlayerDisplayController.h"
#import "VLCHTTPUploaderController.h"
#import "VLCMigrationViewController.h"

@interface AppDelegate () <VLCMediaFileDiscovererDelegate>
{
    BOOL _passcodeValidated;
    BOOL _isRunningMigration;
    BOOL _isComingFromHandoff;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* listen to validation notification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(passcodeWasValidated:)
                                                 name:VLCPasscodeValidated
                                               object:nil];
    
    // Change the keyboard for UISearchBar
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    // For the cursor
    [[UITextField appearance] setTintColor:[UIColor VLCOrangeTintColor]];
    // Don't override the 'Cancel' button color in the search bar with the previous UITextField call. Use the default blue color
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]} forState:UIControlStateNormal];
    // For the edit selection indicators
    [[UITableView appearance] setTintColor:[UIColor VLCOrangeTintColor]];
    
    [[UISwitch appearance] setOnTintColor:[UIColor VLCOrangeTintColor]];
    
    // Init the HTTP Server and clean its cache
    [[VLCHTTPUploaderController sharedInstance] cleanCache];
    [[VLCHTTPUploaderController sharedInstance] changeHTTPServerState:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // enable crash preventer
    
    void (^setupBlock)() = ^{
        _libraryViewController = [[VLCLibraryViewController alloc] init];
        VLCSidebarController *sidebarVC = [VLCSidebarController sharedInstance];
        VLCNavigationController *navCon = [[VLCNavigationController alloc] initWithRootViewController:_libraryViewController];
        sidebarVC.contentViewController = navCon;
        
        self.window.rootViewController = sidebarVC.fullViewController;
        [self.window makeKeyAndVisible];
        
        [self validatePasscode];
        
        BOOL spotlightEnabled = ![[VLCKeychainCoordinator defaultCoordinator] passcodeLockEnabled];
        [[MLMediaLibrary sharedMediaLibrary] setSpotlightIndexingEnabled:spotlightEnabled];
        [[MLMediaLibrary sharedMediaLibrary] applicationWillStart];
        
        VLCMediaFileDiscoverer *discoverer = [VLCMediaFileDiscoverer sharedInstance];
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        discoverer.directoryPath = [searchPaths firstObject];
        [discoverer addObserver:self];
        [discoverer startDiscovering];
    };
    
    setupBlock();
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    _passcodeValidated = NO;
    [self.libraryViewController setEditing:NO animated:NO];
    [self validatePasscode];
    [[MLMediaLibrary sharedMediaLibrary] applicationWillExit];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[MLMediaLibrary sharedMediaLibrary] applicationWillStart];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    _passcodeValidated = NO;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - pass code validation

- (void)passcodeWasValidated:(NSNotification *)aNotifcation
{
    _passcodeValidated = YES;
    [self.libraryViewController updateViewContents];
//    if ([VLCPlaybackController sharedInstance].isPlaying)
//        [[VLCPlayerDisplayController sharedInstance] pushPlaybackView];
}

- (BOOL)passcodeValidated
{
    return _passcodeValidated;
}

- (void)validatePasscode
{
    VLCKeychainCoordinator *keychainCoordinator = [VLCKeychainCoordinator defaultCoordinator];
    
    if (!_passcodeValidated && [keychainCoordinator passcodeLockEnabled]) {
        [[VLCPlayerDisplayController sharedInstance] dismissPlaybackView];
        
        [keychainCoordinator validatePasscode];
    } else {
        _passcodeValidated = YES;
        [self passcodeValidated];
    }
}

#pragma mark - media discovering


- (void)mediaFileAdded:(NSString *)fileName loading:(BOOL)isLoading
{
    NSLog(@"file added:%@",fileName);
    if (!isLoading) {
        MLMediaLibrary *sharedLibrary = [MLMediaLibrary sharedMediaLibrary];
        [sharedLibrary addFilePaths:@[fileName]];
        
        // exclude media files from backup (QA1719)
        NSURL *excludeURL = [NSURL fileURLWithPath:fileName];
        [excludeURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
        
        // TODO Should we update media db after adding new files?
        [sharedLibrary updateMediaDatabase];
        [_libraryViewController updateViewContents];
    }
}

- (void)mediaFileDeleted:(NSString *)name
{
    NSLog(@"file del:%@",name);
    [[MLMediaLibrary sharedMediaLibrary] updateMediaDatabase];
    [_libraryViewController updateViewContents];
}

- (void)mediaFilesFoundRequiringAdditionToStorageBackend:(NSArray<NSString *> *)foundFiles
{
    NSLog(@"file found:%@",foundFiles);
    [[MLMediaLibrary sharedMediaLibrary] addFilePaths:foundFiles];
    [[(AppDelegate *)[UIApplication sharedApplication].delegate libraryViewController] updateViewContents];
}
@end
