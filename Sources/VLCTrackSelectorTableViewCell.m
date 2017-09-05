/*****************************************************************************
 * VLCTrackSelectorTableViewCell.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2014-2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "VLCTrackSelectorTableViewCell.h"

@implementation VLCTrackSelectorTableViewCell

- (void)setShowsCurrentTrack:(BOOL)value
{
    if (value) {
        self.backgroundColor = [UIColor VLCLightTextColor];
        self.textLabel.textColor = [UIColor VLCDarkBackgroundColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor VLCLightTextColor];
    }
}

@end
