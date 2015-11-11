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

#import "ADAlertControllerAction.h"

@interface ADAlertControllerAction ()
@property(copy, nonatomic, readwrite) NSString *title;
@property(assign, nonatomic, readwrite) ADAlertControllerActionStyle style;
@end

@implementation ADAlertControllerAction

- (instancetype)initWithTitle:(NSString *)title style:(ADAlertControllerActionStyle)style handler:(nullable ADAlertControllerActionHandler)handler {
    NSParameterAssert(title);
    self = [super init];
    if (self) {
        self.style = style;
        self.handler = handler;
        self.title = title;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title handler:(nullable ADAlertControllerActionHandler)handler {
    return [self initWithTitle:title style:ADAlertControllerActionStyleDefault handler:handler];
}

- (instancetype)init {
    return [self initWithTitle:@"Button" style:ADAlertControllerActionStyleDefault handler:nil];
}

+ (instancetype)actionWithTitle:(NSString *)title style:(ADAlertControllerActionStyle)style handler:(nullable ADAlertControllerActionHandler)handler {
    return [[ADAlertControllerAction alloc] initWithTitle:title style:style handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title handler:(nullable ADAlertControllerActionHandler)handler {
    return [[ADAlertControllerAction alloc] initWithTitle:title style:ADAlertControllerActionStyleDefault handler:handler];
}

- (BOOL)isEqualToAction:(ADAlertControllerAction *)otherAction {
    if (self == otherAction) {
        return YES;
    }
    return self.style == otherAction.style && [self.title isEqualToString:otherAction.title];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToAction:object];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    ADAlertControllerAction *action = (ADAlertControllerAction *) [[[super class] allocWithZone:zone] init];
    action.style = _style;
    action.title = [_title copy];
    action.handler = [_handler copy];
    return action;
}

@end
