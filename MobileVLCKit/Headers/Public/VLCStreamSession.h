/*****************************************************************************
 * VLCStreamSession.h: VLCKit.framework VLCStreamSession header
 *****************************************************************************
 * Copyright (C) 2008 Pierre d'Herbemont
 * Copyright (C) 2008 VLC authors and VideoLAN
 * $Id$
 *
 * Authors: Pierre d'Herbemont <pdherbemont # videolan.org>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

//#import <VLCKit/VLCStreamOutput.h>
//#import <VLCKit/VLCMediaPlayer.h>
//#import <VLCKit/VLCMedia.h>
#import "VLCStreamOutput.h"
#import "VLCMediaPlayer.h"
#import "VLCMedia.h"


@interface VLCStreamSession : VLCMediaPlayer

+ (instancetype)streamSession;

@property (nonatomic, strong) VLCStreamOutput * streamOutput;
@property (nonatomic, readonly) BOOL isComplete;
@property (nonatomic, readonly) NSUInteger reattemptedConnections;

- (void)startStreaming;
- (void)stopStreaming;

@end
