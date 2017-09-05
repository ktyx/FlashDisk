/*****************************************************************************
 * MLURLConnection.m
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

#import "MLURLConnection.h"


@implementation MLURLConnection
@synthesize data=_data;
@synthesize delegate=_delegate;
@synthesize userObject=_userObject;

+ (id)runConnectionWithURL:(NSURL *)url delegate:(id<MLURLConnectionDelegate>)delegate userObject:(id)userObject
{
    MLURLConnection *obj = [[[self class] alloc] init];
    obj.delegate = delegate;
    obj.userObject = userObject;
    [obj loadURL:url];
    return obj;
}

- (void)loadURL:(NSURL *)url
{
    _data = [[NSMutableData alloc] init];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [_connection cancel];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

    // Make sure we are around during the request
}



- (void)cancel
{
    [_connection cancel];
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate urlConnection:self didFinishWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    [_delegate urlConnection:self didFinishWithError:nil];
}

@end
