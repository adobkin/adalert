//
// Created by Anton Dobkin on 20.09.15.
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

#import <AudioToolbox/AudioServices.h>
#import "ADAlertControllerTextField.h"
#import "ADAlertControllerDefaultColors.h"
#import "ADAlertControllerCommonFunctions.h"

static const CGFloat kPadding = 5.0f;

@interface ADAlertControllerTextField () {
    UIColor *_invalidTextColor;
    NSString *_placeholder;
}
@property(strong, nonatomic, readwrite, nullable) NSMutableArray <ADAlertControllerTextValidator *> *mutableValidators;
@property(strong, nonatomic, readwrite) UIColor *originalBorderColor;
@property(strong, nonatomic, readwrite) NSDictionary *placeholderAttributes;
@end

@implementation ADAlertControllerTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __ad_initialize];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __ad_initialize];
    }
    return self;
}

#pragma mark -

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self __ad_rectForBounds:[super textRectForBounds:bounds]];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self __ad_rectForBounds:[super editingRectForBounds:bounds]];
}

#pragma mark -

- (void)addValidator:(ADAlertControllerTextValidator *)validator {
    if (!self.mutableValidators) {
        self.mutableValidators = [NSMutableArray array];
    }
    if (![self.validators containsObject:validator]) {
        [self.mutableValidators addObject:validator];
    }
}

- (void)addValidators:(NSArray<ADAlertControllerTextValidator *> *)validators {
    for (ADAlertControllerTextValidator *validator in validators) {
        [self addValidator:validator];
    }
}

- (void)invalidValue {
    if (self.invalidTextColor) {
        if (!self.originalBorderColor) {
            self.originalBorderColor = [UIColor colorWithCGColor:self.layer.borderColor];
        }
        self.layer.borderColor = self.invalidTextColor.CGColor;
    }
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [self __ad_shake:3 direction:-1 currentTimes:0 delta:2.0f];
}

- (void)validValue {
    if (self.originalBorderColor) {
        self.layer.borderColor = self.originalBorderColor.CGColor;
        self.originalBorderColor = nil;
    }
}

- (BOOL)isValidText {
    BOOL __block isValid = YES;
    if ([self.validators count]) {
        for (ADAlertControllerTextValidator *validator in self.mutableValidators) {
            if (![validator isValidText:self.text]) {
                isValid = NO;
                break;
            }
        }
    }
    if (isValid) {
        [self validValue];
    } else {
        [self invalidValue];
    }
    return isValid;
}

#pragma mark - Properties

- (NSArray <ADAlertControllerTextValidator *> *)validators {
    return [self.mutableValidators copy];
}

- (void)setInvalidTextColor:(UIColor *)invalidTextColor {
    if (_invalidTextColor != invalidTextColor) {
        _invalidTextColor = invalidTextColor;
    }
}

- (UIColor *)invalidTextColor {
    return _invalidTextColor ? _invalidTextColor : kColorTextFieldInvalidText;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![_placeholder isEqualToString:placeholder]) {
        _placeholder = [placeholder copy];
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:self.placeholderAttributes];
        self.attributedPlaceholder = attributedPlaceholder;
    }
}

#pragma mark - Other methods (Private)

- (void)__ad_initialize {
    self.clearButtonMode = UITextFieldViewModeAlways;
    self.clearsOnInsertion = YES;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDone;
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:17.0f];
    self.tintColor = kColorTextFieldText;
    self.textColor = kColorTextFieldText;
    self.layer.borderColor = [kColorTextFieldText colorWithAlphaComponent:0.3f].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 2.0f;
    self.placeholderAttributes = @{
            NSForegroundColorAttributeName : kColorTextFieldPlaceholder,
            NSFontAttributeName : [UIFont systemFontOfSize:17.0f]
    };
}

- (CGRect)__ad_rectForBounds:(CGRect)bounds {
    CGRect rect = CGRectInset(bounds, kPadding, kPadding);
    return rect;
}

- (void)__ad_shake:(NSInteger)numberOfShakes direction:(int)direction currentTimes:(int)current delta:(CGFloat)delta {
    ad_shakeView(self, numberOfShakes, direction, current, delta);
}

@end
