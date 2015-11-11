//
// Created by Anton Dobkin on 31.10.15.
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

#import "ADAlertControllerAnimationActionsSheetDefault.h"
#import "ADAlertViewControllerAnimationContext.h"

@implementation ADAlertControllerAnimationActionsSheetDefault

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 0.35;
    }
    return self;
}

- (void)alertViewControllerPresent:(ADAlertControllerAnimationContext *)context {
    CGRect toFrame = context.containerView.frame;
    CGRect currentFrame = context.containerView.frame;
    currentFrame.origin.y = CGRectGetHeight(context.containerView.frame);

    context.alertView.frame = currentFrame;
    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         context.alertView.frame = toFrame;
                     } completion:^(BOOL finished) {
                if (finished) {
                    context.completionHandler(YES);
                }
            }];
}

- (void)alertViewControllerDismiss:(ADAlertControllerAnimationContext *)context {
    CGRect toFrame = context.alertView.frame;
    toFrame.origin.y += toFrame.size.height;

    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         context.alertView.frame = toFrame;
                     } completion:^(BOOL finished) {
                if (finished) {
                    context.completionHandler(YES);
                }
            }];
}
@end

