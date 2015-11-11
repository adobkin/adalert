//
// Created by Anton Dobkin on 15.02.15.
// Copyright © 2015 Anton Dobkin. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (instancetype)ad_colorWithHex:(NSString *)hexColor alpha:(float)alpha {
    NSString *color = hexColor;
    if ('#' == [hexColor characterAtIndex:0]) {
        color = [hexColor stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([A-Fa-f0-9]{6})$" options:0 error:NULL];
    if ([regex numberOfMatchesInString:color options:NSMatchingReportCompletion range:NSMakeRange(0, [color length])]) {
        unsigned int rgb = 0;
        NSScanner *scanner = [NSScanner scannerWithString:color];
        [scanner scanHexInt:&rgb];

        float red = ((float) ((rgb & 0xFF0000) >> 16)) / 255.0f;
        float green = ((float) ((rgb & 0xFF00) >> 8)) / 255.0f;
        float blue = ((float) (rgb & 0xFF)) / 255.0f;
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return nil;
}

+ (instancetype)ad_colorWithHex:(NSString *)hexColor {
    return [self ad_colorWithHex:hexColor alpha:1.0f];
}
@end
