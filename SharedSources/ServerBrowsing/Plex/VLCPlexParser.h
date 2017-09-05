/*****************************************************************************
 * VLCPlexParser.h
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2014-2015 VideoLAN. All rights reserved.
 *
 * Authors: Pierre Sagaspe <pierre.sagaspe # me.com>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import <UIKit/UIKit.h>
@interface VLCPlexParser : NSObject

- (NSArray *)PlexMediaServerParser:(NSString *)adress port:(NSNumber *)port navigationPath:(NSString *)navPath authentification:(NSString *)auth error:(NSError *__autoreleasing *)error;
- (NSArray *)PlexExtractDeviceInfo:(NSData *)data;

@end