/*****************************************************************************
 * VLCLocalNetworkServiceVLCMedia.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Tobias Conradi <videolan # tobias-conradi.de>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "VLCLocalNetworkServiceVLCMedia.h"

@interface VLCLocalNetworkServiceVLCMedia()
@property (nonatomic) VLCMedia *mediaItem;
@end

@implementation VLCLocalNetworkServiceVLCMedia
- (instancetype)initWithMediaItem:(VLCMedia *)mediaItem
{
    self = [super init];
    if (self) {
        _mediaItem = mediaItem;
    }
    return self;
}
- (NSString *)title {
    return [self.mediaItem metadataForKey:VLCMetaInformationTitle];
}
- (UIImage *)icon {
    return nil;
}
@end
