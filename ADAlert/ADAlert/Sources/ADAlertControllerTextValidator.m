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

#import "ADAlertControllerTextValidator.h"

@interface ADAlertControllerTextValidator ()
@property(strong, nonatomic, readwrite, nullable) NSRegularExpression *expression;
@property(copy, nonatomic, readwrite, nullable) ADAlertControllerTextValidateBlock validateBlock;
@end

@implementation ADAlertControllerTextValidator

- (instancetype)initWithRegexp:(NSRegularExpression *)expression {
    self = [super init];
    if (self) {
        self.expression = expression;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unavailable. Use +[[%@ alloc] %@] instead", NSStringFromClass([self class]), NSStringFromSelector(@selector(initWithRegexp:))] userInfo:nil];
}

- (instancetype)initWithValidateBlock:(ADAlertControllerTextValidateBlock)validateBlock {
    NSParameterAssert(validateBlock);
    self = [super init];
    if (self) {
        self.validateBlock = validateBlock;
    }
    return self;
}

- (BOOL)isValidText:(NSString *)text {
    if (text) {
        if (self.expression) {
            return [self.expression numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)] != 0;
        } else if (self.validateBlock) {
            return self.validateBlock(text);
        }
    }
    return NO;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    ADAlertControllerTextValidator *validator = (ADAlertControllerTextValidator *) [[[self class] allocWithZone:zone] init];
    validator->_expression = (_expression) ? [_expression copy] : nil;
    validator->_validateBlock = (_validateBlock) ? [_validateBlock copy] : nil;
    return validator;
}

@end
