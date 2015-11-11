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

#import "ADAlertControllerAnimatedTransitioning.h"
#import "ADAlertViewControllerAnimationContext.h"

@interface ADAlertControllerAnimatedTransitioning ()
@property(assign, nonatomic, readwrite) ADAlertControllerAlertAnimatedType transitionType;
@property(strong, nonatomic, readwrite) id <ADAlertControllerAnimation> animation;
@end

@implementation ADAlertControllerAnimatedTransitioning

- (instancetype)initWithAnimation:(id <ADAlertControllerAnimation>)animation transitionType:(ADAlertControllerAlertAnimatedType)transitionType {
    self = [super self];
    if (self) {
        self.transitionType = transitionType;
        self.animation = animation;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unavailable. Use +[[%@ alloc] %@] instead", NSStringFromClass([self class]), NSStringFromSelector(@selector(initWithAnimation:transitionType:))] userInfo:nil];
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];

    if (self.transitionType == ADAlertControllerAlertAnimatedTypePresent) {
        ADAlertControllerAnimationContext *context = [[ADAlertControllerAnimationContext alloc] initWithAlertView:toView containerView:containerView completionHandler:^(BOOL didComplete) {
            [transitionContext completeTransition:didComplete];
        }];
        [self.animation alertViewControllerPresent:context];
    } else {
        ADAlertControllerAnimationContext *context = [[ADAlertControllerAnimationContext alloc] initWithAlertView:fromView containerView:containerView completionHandler:^(BOOL didComplete) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:didComplete];
        }];
        [self.animation alertViewControllerDismiss:context];
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return [self.animation duration];
}

@end
