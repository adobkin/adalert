//
// Created by Anton Dobkin on 15.02.15.
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

#import <UIKit/UIKit.h>

UIKIT_STATIC_INLINE UIEdgeInsets ADEdgeInsets(CGFloat inset) {
    return (UIEdgeInsets) {inset, inset, -inset, -inset};
}

UIKIT_STATIC_INLINE UIEdgeInsets ADEdgeDefaultInsets() {
    return UIEdgeInsetsMake(15.0f, 15.0f, -15.0f, -15.0f);
}

typedef NS_OPTIONS(NSInteger, ADAxis) {
    ADAxisY = 1 << 0,
    ADAxisX = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN;

@interface UIView (AutoLayout)

+ (instancetype)ad_viewWithAutoLayout;
- (NSLayoutConstraint *)ad_pinEdge:(UIRectEdge)edge toEdge:(UIRectEdge)toEdge ofView:(UIView *)view withInset:(CGFloat)inset relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)ad_pinEdge:(UIRectEdge)edge toEdge:(UIRectEdge)toEdge ofView:(UIView *)view withInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_pinEdge:(UIRectEdge)edge toEdge:(UIRectEdge)toEdge ofView:(UIView *)view;
- (NSArray *)ad_pinEdges:(UIRectEdge)edges toSameEdgesOfView:(UIView *)view withInsets:(UIEdgeInsets)insets;
- (NSArray *)ad_pinEdgesToSameEdgesOfSuperView:(UIRectEdge)edges withInsets:(UIEdgeInsets)insets;
- (NSArray *)ad_pinEdgesToSameEdgesOfSuperView:(UIRectEdge)edges;
- (NSArray *)ad_pinAllEdgesToSameEdgesOfSuperView:(UIEdgeInsets)insets;
- (NSArray *)ad_pinAllEdgesToSameEdgesOfSuperView;
- (NSArray *)ad_pinAllEdgesToSameEdgesOfView:(UIView *)view withInsets:(UIEdgeInsets)insets;
- (NSArray *)ad_pinAllEdgesToSameEdgesOfView:(UIView *)view;
- (NSLayoutConstraint *)ad_pinEdgeToSameEdgeOfSuperView:(UIRectEdge)edge withInset:(CGFloat)inset relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)ad_pinEdgeToSameEdgeOfSuperView:(UIRectEdge)edge withInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_pinEdgeToSameEdgeOfSuperView:(UIRectEdge)edge;
- (NSLayoutConstraint *)ad_toAlignOnAxis:(ADAxis)axis withInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_toAlignOnAxisYWithInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_toAlignOnAxisXWithInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_toAlignOnAxisY;
- (NSLayoutConstraint *)ad_toAlignOnAxisX;
- (NSLayoutConstraint *)ad_toAlignAxisXToAxisXOfView:(UIView *)view withInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_toAlignAxisXToAxisXOfView:(UIView *)view;
- (NSLayoutConstraint *)ad_toAlignAxisYToAxisYOfView:(UIView *)view withInset:(CGFloat)inset;
- (NSLayoutConstraint *)ad_toAlignAxisYToAxisYOfView:(UIView *)view;
- (NSArray *)ad_toAlignToCenterOfSuperView;
- (NSLayoutConstraint *)ad_height:(CGFloat)height relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)ad_height:(CGFloat)height;
- (NSLayoutConstraint *)ad_width:(CGFloat)width relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)ad_width:(CGFloat)width;
- (NSLayoutConstraint *)ad_heightEqualToHeightOfView:(UIView *)view relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)ad_heightEqualToHeightOfView:(UIView *)view;
- (NSLayoutConstraint *)ad_widthEqualToWidthOfView:(UIView *)view relation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)ad_widthEqualToWidthOfView:(UIView *)view;
- (UIView *)ad_commonSuperViewWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END;
