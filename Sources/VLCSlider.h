/*****************************************************************************
 * VLCSlider.h
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2013 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne # videolan.org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "OBSlider.h"

@interface VLCOBSlider : OBSlider

@end

@interface VLCSlider : UISlider

@end

@interface VLCResettingSlider : VLCSlider
@property (nonatomic) IBInspectable float defaultValue;
@property (nonatomic) IBInspectable BOOL resetOnDoubleTap;
@end