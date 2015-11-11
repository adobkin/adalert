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

#import "ADAlertControllerAnimationRotate.h"
#import "ADAlertViewControllerAnimationContext.h"

#define __AD_ANGLE_RADIANS(__angle) \
    ((CGFloat)(((__angle) * M_PI)/180.0f))


@implementation ADAlertControllerAnimationRotate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 0.8;
        self.rotateAngle = 40.0f;
    }
    return self;
}

- (void)alertViewControllerPresent:(ADAlertControllerAnimationContext *)context {
    CGFloat initY = (CGRectGetHeight(context.containerView.frame) + CGRectGetHeight(context.alertView.frame)) / 2.0f;
    context.alertView.layer.transform = CATransform3DRotate(
            CATransform3DMakeTranslation(0.0f, -initY, 0.0f),
            __AD_ANGLE_RADIANS(self.rotateAngle),
            0.0f,
            0.0f,
            1.0f);

    [UIView animateWithDuration:self.duration delay:0.0
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         context.alertView.layer.transform = CATransform3DIdentity;
                         context.alertView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                if (finished) {
                    context.completionHandler(YES);
                }
            }];
}

- (void)alertViewControllerDismiss:(ADAlertControllerAnimationContext *)context {
    [UIView animateWithDuration:self.duration delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         context.alertView.layer.transform = CATransform3DRotate(
                                 CATransform3DMakeTranslation(0.0f, CGRectGetHeight(context.containerView.frame), 0.0f),
                                 __AD_ANGLE_RADIANS(-self.rotateAngle), 0.0f, 0.0f, 1.0f);
                     } completion:^(BOOL finished) {
                if (finished) {
                    context.completionHandler(YES);
                }
            }];
}

@end
