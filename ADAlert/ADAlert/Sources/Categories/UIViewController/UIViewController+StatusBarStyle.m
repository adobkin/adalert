//
// Created by Anton Dobkin on 15.02.15.
// Copyright © 2015 Anton Dobkin. All rights reserved.
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

#import <objc/runtime.h>
#import "UIViewController+StatusBarStyle.h"

@implementation UIViewController (StatusBarStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(preferredStatusBarStyle);
        SEL swizzledSelector = @selector(__dw_preferredStatusBarStyle);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class, originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

//// Relative luminance in colorimetric spaces - http://en.wikipedia.org/wiki/Luminance_(relative)
- (UIStatusBarStyle)__dw_preferredStatusBarStyle {
    UIStatusBarStyle style = UIStatusBarStyleDefault;
    UIColor *color = nil;
    CGFloat red = 0.0f, green = 0.0f, blue = 0.0f;

    if (self.navigationController) {
        color = self.navigationController.navigationBar.barTintColor;
    } else {
        color = self.view.backgroundColor;
    }

    if (color) {
        [color getRed:&red green:&green blue:&blue alpha:nil];
        red *= 0.2126;
        green *= 0.7152;
        blue *= 0.0722;
        if (green >= 0.5f && green < 0.6f) {
            style = UIStatusBarStyleLightContent;
        } else {
            if ((red + green + blue) <= 0.5f) {
                style = UIStatusBarStyleLightContent;
            }
        }
    }
    return style;
}

@end
