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

#import "ADAlertControllerPresentationController.h"
#import "ADAlertControllerDefaultColors.h"
#import "ADAlertController.h"

#import "UIView+AutoLayout.h"
#import "NSArray+AutoLayout.h"

@interface ADAlertControllerPresentationController () {
    UIView *_backgroundView;
}
@property(strong, nonatomic, readonly) UIView *backgroundView;
@end

@implementation ADAlertControllerPresentationController

- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = kColorBackground;
    }
    return _backgroundColor;
}

#pragma mark - Properties

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView ad_viewWithAutoLayout];
    }
    return _backgroundView;
}

#pragma mark -

- (void)presentationTransitionWillBegin {
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.backgroundView.alpha = 0.0f;

    [self.containerView insertSubview:self.backgroundView atIndex:0];
    [[self.backgroundView ad_pinAllEdgesToSameEdgesOfSuperView] ad_installConstraints];

    [self.containerView addSubview:self.presentedViewController.view];

    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundView.alpha = 1.0f;
    } completion:nil];
}

- (UIView *)presentedView {
    return self.presentedViewController.view.subviews[0];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.backgroundView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundView.alpha = 0.0f;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.backgroundView removeFromSuperview];
    }
}

- (void)containerViewWillLayoutSubviews {
    self.presentedViewController.view.frame = self.containerView.frame;
    self.backgroundView.frame = self.containerView.frame;
}

@end
