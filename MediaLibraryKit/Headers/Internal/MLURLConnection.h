/*****************************************************************************
 * MLURLConnection.h
 * MobileMediaLibraryKit
 *****************************************************************************
 * Copyright (C) 2010 Pierre d'Herbemont
 * Copyright (C) 2010-2013 VLC authors and VideoLAN
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

@protocol MLURLConnectionDelegate;
@class MLURLConnection;
@interface MLURLConnection : NSObject {
    NSMutableData *_data;
    NSURLConnection *_connection;
    id<MLURLConnectionDelegate> _delegate;
    id _userObject;
}

@property (readonly, strong) NSData *data;
@property (readwrite, strong) id userObject;
@property (readwrite, strong) id<MLURLConnectionDelegate> delegate;


+ (id)runConnectionWithURL:(NSURL *)url delegate:(id<MLURLConnectionDelegate>)delegate userObject:(id)userObject;
- (void)loadURL:(NSURL *)url;
- (void)cancel;

@end


@protocol MLURLConnectionDelegate <NSObject>
- (void)urlConnection:(MLURLConnection *)connection didFinishWithError:(NSError *)error;
@end
