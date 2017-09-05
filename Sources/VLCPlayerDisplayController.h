/*****************************************************************************
 * VLCPlayerDisplayController.h
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Tobias Conradi <videolan # tobias-conradi.de>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

@class VLCPlaybackController;

typedef NS_ENUM(NSUInteger, VLCPlayerDisplayControllerDisplayMode) {
    VLCPlayerDisplayControllerDisplayModeFullscreen,
    VLCPlayerDisplayControllerDisplayModeMiniplayer,
};

@interface VLCPlayerDisplayController : UIViewController

+ (VLCPlayerDisplayController *)sharedInstance;

@property (nonatomic, strong) UIViewController *childViewController;

@property (nonatomic, assign) VLCPlayerDisplayControllerDisplayMode displayMode;
@property (nonatomic, weak) VLCPlaybackController *playbackController;

- (void)showFullscreenPlayback;
- (void)closeFullscreenPlayback;

- (void)pushPlaybackView;
- (void)dismissPlaybackView;

@end
