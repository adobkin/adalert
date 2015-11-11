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

#import "ADAlertControllerAnimationDefault.h"
#import "ADAlertViewControllerAnimationContext.h"

@implementation ADAlertControllerAnimationDefault

- (instancetype)init {
    self = [super init];
    if (self) {
        self.duration = 0.35;
    }
    return self;
}

- (void)alertViewControllerPresent:(ADAlertControllerAnimationContext *)context {
    context.alertView.alpha = 0;
    context.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);

    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        context.alertView.transform = CGAffineTransformIdentity;
        context.alertView.alpha = 1.0;
    }                completion:^(BOOL finished) {
        if (finished) {
            context.completionHandler(YES);
        }
    }];
}

- (void)alertViewControllerDismiss:(ADAlertControllerAnimationContext *)context {
    [UIView animateWithDuration:self.duration animations:^{
        context.alertView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        context.alertView.alpha = 0.0f;
    }                completion:^(BOOL finished) {
        if (finished) {
            context.completionHandler(YES);
        }
    }];
}

@end
