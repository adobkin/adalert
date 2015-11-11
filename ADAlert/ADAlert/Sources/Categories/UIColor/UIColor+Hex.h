//
// Created by Anton Dobkin on 15.02.15.
// Copyright © 2015 Anton Dobkin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN;

@interface UIColor (Hex)
+ (instancetype)ad_colorWithHex:(NSString *)hexColor alpha:(float)alpha;
+ (instancetype)ad_colorWithHex:(NSString *)hexColor;
@end

NS_ASSUME_NONNULL_END;
