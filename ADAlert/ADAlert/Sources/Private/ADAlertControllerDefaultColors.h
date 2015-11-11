//
//  Created by Anton Dobkin on 01.11.15.
//  Copyright © 2015 Anton Dobkin. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifndef __BS_ALERT_CONTROLLER_COLORS_H__
#define __BS_ALERT_CONTROLLER_COLORS_H__

#import "UIColor+Hex.h"

#define kColorBackground \
    [[UIColor ad_colorWithHex:@"#000000"] colorWithAlphaComponent:0.4f]

#define kColorTitle \
    [UIColor ad_colorWithHex:@"#262B3B"]

#define kColorTitleBlurDark \
    [[UIColor ad_colorWithHex:@"#FFFFFF"] colorWithAlphaComponent:0.75f]

#define kColorTitleBlurLight \
    [[UIColor ad_colorWithHex:@"#FFFFFF"] colorWithAlphaComponent:0.85f]

#define kColorText kColorTitle
#define kColorTextBlurDark kColorTitleBlurDark
#define kColorTextBlurLight kColorTitleBlurLight

// Actions
#define kColorButtonDefaultBackground \
    [UIColor ad_colorWithHex:@"#298ACC"]

#define kColorButtonDefaultTitle \
    [UIColor ad_colorWithHex:@"#FFFFFF"]

#define kColorButtonDangerBackground \
    [UIColor ad_colorWithHex:@"#C35256"]

#define kColorButtonDangerTitle \
    [UIColor ad_colorWithHex:@"#FFFFFF"]

#define kColorButtonCancelTitle \
    [UIColor ad_colorWithHex:@"#292929"]

#define kColorButtonCancelBackground \
    [UIColor ad_colorWithHex:@"#BDC3C7"]

// Fields
#define kColorTextFieldPlaceholder \
    [UIColor ad_colorWithHex:@"#E9E9E9"]

#define kColorTextFieldFloatingActiveLabel \
    [UIColor ad_colorWithHex:@"#387EB9"]

#define kColorTextFieldInvalidText \
    [UIColor ad_colorWithHex:@"#FF2817"]

#define kColorTextFieldText \
    [UIColor ad_colorWithHex:@"#484848"]

#endif
