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

#import "NSLayoutConstraint+AutoLayout.h"
#import "UIView+AutoLayout.h"

@implementation NSLayoutConstraint (AutoLayout)

- (void)ad_installWithPriority:(UILayoutPriority)priority {
    self.priority = priority;
    if (self.firstItem && !self.secondItem) {
        [self.firstItem addConstraint:self];
    } else if (self.firstItem && self.secondItem) {
        UIView *commonSuperView = [self.firstItem ad_commonSuperViewWithView:self.secondItem];
        [commonSuperView addConstraint:self];
    }
}

- (void)ad_installConstraint {
    [self ad_installWithPriority:UILayoutPriorityRequired];
}

+ (void)ad_installConstraints:(NSArray <NSLayoutConstraint *> *)constraints {
    for (id object in constraints) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [((NSLayoutConstraint *) object) ad_installConstraint];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [NSLayoutConstraint ad_installConstraints:object];
        }
    }
}

- (void)ad_removeConstraint {
    if (self.secondItem) {
        UIView *commonSuperview = [self.firstItem ad_commonSuperViewWithView:self.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:self]) {
                [commonSuperview removeConstraint:self];
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    } else {
        [self.firstItem removeConstraint:self];
    }
}

+ (void)ad_removeConstraints:(NSArray <NSLayoutConstraint *> *)constraints {
    for (id object in constraints) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [((NSLayoutConstraint *) object) ad_removeConstraint];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [NSLayoutConstraint ad_removeConstraints:object];
        }
    }
}

@end
