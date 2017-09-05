/*****************************************************************************
 * VLCNetworkServerBrowserVLCMedia.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2015 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Tobias Conradi <videolan # tobias-conradi.de>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "VLCNetworkServerBrowserVLCMedia.h"

@interface VLCNetworkServerBrowserVLCMedia () <VLCMediaListDelegate, VLCMediaDelegate>
{
    BOOL _needsNotifyDelegate;
}

@property (nonatomic) VLCMedia *rootMedia;
@property (nonatomic) VLCMediaList *mediaList;
@property (nonatomic) NSMutableArray<id<VLCNetworkServerBrowserItem>> *mutableItems;
@property (nonatomic, readonly) NSDictionary *mediaOptions;

@end
@implementation VLCNetworkServerBrowserVLCMedia
@synthesize delegate = _delegate;

- (instancetype)initWithMedia:(VLCMedia *)media options:(nonnull NSDictionary *)mediaOptions
{
    self = [super init];
    if (self) {
        _mutableItems = [[NSMutableArray alloc] init];
        _rootMedia = media;
        _rootMedia.delegate = self;
        [media parseWithOptions:VLCMediaParseNetwork];
        _mediaList = [_rootMedia subitems];
        _mediaList.delegate = self;
        _mediaOptions = [mediaOptions copy];
        [self _addMediaListRootItemsToList];
    }
    return self;
}

- (void)_addMediaListRootItemsToList
{
    VLCMediaList *rootItems = _rootMedia.subitems;
    [rootItems lock];
    NSUInteger count = rootItems.count;
    for (NSUInteger i = 0; i < count; i++) {
        VLCMedia *media = [rootItems mediaAtIndex:i];
        VLCMedia *newMedia = [VLCMedia mediaWithURL:media.url];
        newMedia.delegate = self;
        [newMedia addOptions:self.mediaOptions];
        [newMedia parseWithOptions:VLCMediaParseNetwork];
        [self.mutableItems addObject:[[VLCNetworkServerBrowserItemVLCMedia alloc] initWithMedia:newMedia options:self.mediaOptions]];
    }
    [rootItems unlock];
}

- (void)update {
    int ret = [self.rootMedia parseWithOptions:VLCMediaParseNetwork];
    if (ret == -1) {
        [self.delegate networkServerBrowserDidUpdate:self];
    }
}

- (NSString *)title {
    if (self.rootMedia.isParsed)
        return [self.rootMedia metadataForKey:VLCMetaInformationTitle];
    return @"";
}

- (NSArray<id<VLCNetworkServerBrowserItem>> *)items {
    return self.mutableItems.copy;
}

#pragma mark - media list delegate

- (void)mediaList:(VLCMediaList *)aMediaList mediaAdded:(VLCMedia *)media atIndex:(NSInteger)index
{
    [media addOptions:self.mediaOptions];
    [self.mutableItems addObject:[[VLCNetworkServerBrowserItemVLCMedia alloc] initWithMedia:media options:self.mediaOptions]];
    [self.delegate networkServerBrowserDidUpdate:self];
}

- (void)mediaList:(VLCMediaList *)aMediaList mediaRemovedAtIndex:(NSInteger)index
{
    [self.mutableItems removeObjectAtIndex:index];
    [self.delegate networkServerBrowserDidUpdate:self];
}

#pragma mark - media delegate

- (void)mediaDidFinishParsing:(VLCMedia *)aMedia
{
    [self setNeedsNotifyDelegateForDidUpdate];
}
- (void)mediaMetaDataDidChange:(VLCMedia *)aMedia
{
    [self setNeedsNotifyDelegateForDidUpdate];
}

- (void)setNeedsNotifyDelegateForDidUpdate
{
    if (_needsNotifyDelegate) {
        return;
    }
    _needsNotifyDelegate = YES;

    double amountOfSeconds = 0.1;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(amountOfSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        _needsNotifyDelegate = NO;
        [self.delegate networkServerBrowserDidUpdate:self];
    });
}

@end

@interface VLCNetworkServerBrowserItemVLCMedia () <VLCMediaDelegate>
@property (nonatomic, readonly) NSDictionary *mediaOptions;

@end
@implementation VLCNetworkServerBrowserItemVLCMedia
@synthesize name = _name, container = _container, fileSizeBytes = _fileSizeBytes, URL = _URL, media = _media, downloadable = _downloadable;

- (instancetype)initWithMedia:(VLCMedia *)media options:(NSDictionary *)mediaOptions;
{
    self = [super init];
    if (self) {
        _media = media;
        _container = media.mediaType == VLCMediaTypeDirectory;
        NSString *title;
        if (media.isParsed) {
            title = [media metadataForKey:VLCMetaInformationTitle];
        }
        if (!title) {
            title = media.url.lastPathComponent;
        }
        if (!title) {
            title = media.url.absoluteString;
        }
        _name = title;
        _URL = media.url;
        _mediaOptions = [mediaOptions copy];
        _downloadable = NO;
    }
    return self;
}

- (id<VLCNetworkServerBrowser>)containerBrowser {
    return [[VLCNetworkServerBrowserVLCMedia alloc] initWithMedia:self.media options:self.mediaOptions];
}

@end
