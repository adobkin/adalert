//
// Created by Anton Dobkin on 14.03.15.
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

#import "ADAlertControllerButton.h"
#import "ADAlertControllerAction.h"
#import "ADAlertControllerDefaultColors.h"

@interface ADAlertControllerButton () {
    BOOL _highlighted;
    ADAlertControllerAction *_action;
}
@end

@implementation ADAlertControllerButton

- (instancetype)initWithAction:(ADAlertControllerAction *)action {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self __ad_initialize];
        self.action = action;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __ad_initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self __ad_initialize];
    }
    return self;
}

#pragma mark - Properties

- (void)setAction:(ADAlertControllerAction *)action {
    if (![_action isEqualToAction:action]) {
        _action = action;
        [self __ad_setBackgroundColor];
        [self __ad_setTitle];
    }
}

- (ADAlertControllerAction *)action {
    return _action;
}

#pragma mark -

- (void)setHighlighted:(BOOL)highlighted {
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        [UIView animateWithDuration:0.1f animations:^{
            self.alpha = (highlighted) ? 0.3f : 1.0f;
        }];
    }
}

- (BOOL)isHighlighted {
    return _highlighted;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) - self.imageEdgeInsets.right + self.imageEdgeInsets.left;
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    return frame;
}

#pragma mark - Private Methods

- (void)__ad_initialize {
    [self setContentEdgeInsets:UIEdgeInsetsMake(10.0f, 20.0f, 10.0f, 20.0f)];
    self.layer.cornerRadius = 0.0f;
    self.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.exclusiveTouch = YES;
    _highlighted = NO;
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)__ad_setBackgroundColor {
    UIColor *backgroundColor = nil;
    if (self.action.style == ADAlertControllerActionStyleCancel) {
        backgroundColor = kColorButtonCancelBackground;
    } else if (self.action.style == ADAlertControllerActionStyleDestructive) {
        backgroundColor = kColorButtonDangerBackground;
    }
    self.backgroundColor = backgroundColor ?: kColorButtonDefaultBackground;
}

- (void)__ad_setTitle {
    [self setTitle:self.action.title forState:UIControlStateNormal];

    UIColor *textColor = nil;
    UIFont *textFont = (self.action.style == ADAlertControllerActionStyleCancel)
            ? [UIFont boldSystemFontOfSize:15.0f]
            : [UIFont systemFontOfSize:14.0f];

    if (self.action.style == ADAlertControllerActionStyleCancel) {
        textColor = kColorButtonCancelTitle;
    } else if (self.action.style == ADAlertControllerActionStyleDestructive) {
        textColor = kColorButtonDangerTitle;
    }

    textColor = textColor ?: kColorButtonDefaultTitle;

    self.titleLabel.font = textFont;
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end
