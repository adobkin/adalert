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
#import "ADAlertControllerTextView.h"
#import "ADAlertControllerDefaultColors.h"
#import "ADAlertControllerCommonFunctions.h"

#import "UIColor+Hex.h"

static const CGFloat kLabelPadding = 5.0f;

@interface ADAlertControllerTextView () {
    UIColor *_invalidTextColor;
    UILabel *_placeholderLabel;
    NSString *_placeholder;
}
@property(strong, nonatomic, readwrite) NSDictionary *placeholderAttributes;
@property(strong, nonatomic, readwrite, nullable) NSMutableArray <ADAlertControllerTextValidator *> *mutableValidators;
@property(strong, nonatomic, readwrite) UIColor *originalBorderColor;
@end

@implementation ADAlertControllerTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __ad_initialize];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainerInset = [self __ad_textContainerInset];
    [self __ad_setPlaceholderLabelFrame];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (NSArray <ADAlertControllerTextValidator *> *)validators {
    return [self.mutableValidators copy];
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

- (void)setInvalidTextColor:(UIColor *)invalidTextColor {
    if (_invalidTextColor != invalidTextColor) {
        _invalidTextColor = invalidTextColor;
    }
}

- (UIColor *)invalidTextColor {
    return _invalidTextColor ? _invalidTextColor : kColorTextFieldInvalidText;
}

#pragma mark - Properties

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.userInteractionEnabled = NO;
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![_placeholder isEqualToString:placeholder]) {
        _placeholder = [placeholder copy];

        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:self.placeholderAttributes];
        self.placeholderLabel.attributedText = attributedPlaceholder;
    }
    [self layoutSubviews];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsLayout];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

#pragma mark - Other Methods (Private)

- (void)__ad_initialize {
    self.userInteractionEnabled = YES;
    self.scrollEnabled = YES;

    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDone;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 2.0f;
    self.textContainer.lineFragmentPadding = 0.0f;
    self.layoutManager.allowsNonContiguousLayout = YES;
    self.tintColor = kColorTextFieldText;
    self.textColor = kColorTextFieldText;
    self.layer.borderColor = [kColorTextFieldText colorWithAlphaComponent:0.3f].CGColor;
    self.font = [UIFont systemFontOfSize:17.0f];

    self.placeholderAttributes = @{
            NSForegroundColorAttributeName : kColorTextFieldPlaceholder,
            NSFontAttributeName : [UIFont systemFontOfSize:17.0f]
    };

    [self addSubview:self.placeholderLabel];
    [self sendSubviewToBack:self.placeholderLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__ad_textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (UIEdgeInsets)__ad_textContainerInset {
    UIEdgeInsets insets = UIEdgeInsetsMake(kLabelPadding, kLabelPadding, kLabelPadding, kLabelPadding);
    return insets;
}

- (void)__ad_setPlaceholderLabelFrame {
    CGSize placeholderSize = [self.placeholderLabel sizeThatFits:self.bounds.size];
    CGRect frame = self.placeholderLabel.frame;
    frame.origin.x = self.textContainerInset.left;
    frame.origin.y = self.textContainerInset.top;
    frame.size.width = CGRectGetWidth(self.bounds) - (self.textContainerInset.left + self.textContainerInset.right);
    frame.size.height = placeholderSize.height;
    self.placeholderLabel.frame = frame;
}

- (void)__ad_shake:(NSInteger)numberOfShakes direction:(int)direction currentTimes:(int)current delta:(CGFloat)delta {
    ad_shakeView(self, numberOfShakes, direction, current, delta);
}

#pragma mark - Notifications (Private)

- (void)__ad_textDidChange:(NSNotification *)notification {
    self.placeholderLabel.hidden = [self.text length] > 0;
}

@end
