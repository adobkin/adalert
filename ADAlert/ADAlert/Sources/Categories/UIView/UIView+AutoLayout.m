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

#import "UIView+AutoLayout.h"

#define __AD_AUTOLAYOUT_ASSERT(__exp, __fmt, ...) \
do {\
    NSAssert((__exp), @"[UIView+AutoLayout]: %@", [NSString stringWithFormat:(__fmt), ##__VA_ARGS__]); \
}while(0);

#define __AD_AUTOLAYOUT_SUPERVIEW_ASSERT() \
    __AD_AUTOLAYOUT_ASSERT(self.superview, @"self.superview is nil")

#define __AD_AUTOLAYOUT_VIEW_ASSERT(__view) \
    __AD_AUTOLAYOUT_ASSERT(__view, @"view is nil")

@implementation UIView (AutoLayout)

+ (instancetype)ad_viewWithAutoLayout {
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (UIView *)ad_commonSuperViewWithView:(UIView *)view {
    __AD_AUTOLAYOUT_VIEW_ASSERT(view)
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([view isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    __AD_AUTOLAYOUT_ASSERT(commonSuperview, @"Common superview not found. Both views must be added into the same view hierarchy.\n\nview1: %@\nview2: %@", self, view);
    return commonSuperview;
}

#pragma mark -

- (NSLayoutConstraint *)ad_pinEdge:(UIRectEdge)edge toEdge:(UIRectEdge)toEdge ofView:(UIView *)view withInset:(CGFloat)inset relation:(NSLayoutRelation)relation {
    __AD_AUTOLAYOUT_VIEW_ASSERT(view)
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:[self __ad_edgeToLayoutAttribute:edge]
                                                                  relatedBy:relation
                                                                     toItem:view
                                                                  attribute:[self __ad_edgeToLayoutAttribute:toEdge]
                                                                 multiplier:1.0f
                                                                   constant:inset];
    return constraint;
}

- (NSLayoutConstraint *)ad_pinEdge:(UIRectEdge)edge toEdge:(UIRectEdge)toEdge ofView:(UIView *)view withInset:(CGFloat)inset {
    return [self ad_pinEdge:edge toEdge:toEdge ofView:view withInset:inset relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)ad_pinEdge:(UIRectEdge)edge toEdge:(UIRectEdge)toEdge ofView:(UIView *)view {
    return [self ad_pinEdge:edge toEdge:toEdge ofView:view withInset:0.0f relation:NSLayoutRelationEqual];
}

- (NSArray *)ad_pinEdges:(UIRectEdge)edges toSameEdgesOfView:(UIView *)view withInsets:(UIEdgeInsets)insets {
    __AD_AUTOLAYOUT_VIEW_ASSERT(view)
    NSMutableArray *constraints = [NSMutableArray array];
    NSLayoutConstraint *constraint = nil;
    if (edges & UIRectEdgeTop) {
        constraint = [self ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeTop ofView:view withInset:insets.top];
        [constraints addObject:constraint];
    }
    if (edges & UIRectEdgeLeft) {
        constraint = [self ad_pinEdge:UIRectEdgeLeft toEdge:UIRectEdgeLeft ofView:view withInset:insets.left];
        [constraints addObject:constraint];
    }
    if (edges & UIRectEdgeBottom) {
        constraint = [self ad_pinEdge:UIRectEdgeBottom toEdge:UIRectEdgeBottom ofView:view withInset:insets.bottom];
        [constraints addObject:constraint];
    }
    if (edges & UIRectEdgeRight) {
        constraint = [self ad_pinEdge:UIRectEdgeRight toEdge:UIRectEdgeRight ofView:view withInset:insets.right];
        [constraints addObject:constraint];
    }
    return constraints;
}

- (NSArray *)ad_pinEdgesToSameEdgesOfSuperView:(UIRectEdge)edges withInsets:(UIEdgeInsets)insets {
    __AD_AUTOLAYOUT_SUPERVIEW_ASSERT()
    return [self ad_pinEdges:edges toSameEdgesOfView:self.superview withInsets:insets];
}

- (NSArray *)ad_pinAllEdgesToSameEdgesOfView:(UIView *)view withInsets:(UIEdgeInsets)insets {
    return [self ad_pinEdges:UIRectEdgeAll toSameEdgesOfView:view withInsets:insets];
}

- (NSArray *)ad_pinAllEdgesToSameEdgesOfView:(UIView *)view {
    return [self ad_pinEdges:UIRectEdgeAll toSameEdgesOfView:view withInsets:UIEdgeInsetsZero];
}

- (NSArray *)ad_pinEdgesToSameEdgesOfSuperView:(UIRectEdge)edges {
    return [self ad_pinEdgesToSameEdgesOfSuperView:edges withInsets:UIEdgeInsetsZero];
}

- (NSArray *)ad_pinAllEdgesToSameEdgesOfSuperView:(UIEdgeInsets)insets {
    return [self ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeAll withInsets:insets];
}

- (NSArray *)ad_pinAllEdgesToSameEdgesOfSuperView {
    return [self ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeAll];
}

- (NSLayoutConstraint *)ad_pinEdgeToSameEdgeOfSuperView:(UIRectEdge)edge withInset:(CGFloat)inset relation:(NSLayoutRelation)relation {
    __AD_AUTOLAYOUT_SUPERVIEW_ASSERT()
    return [self ad_pinEdge:edge toEdge:edge ofView:self.superview withInset:inset relation:relation];
}

- (NSLayoutConstraint *)ad_pinEdgeToSameEdgeOfSuperView:(UIRectEdge)edge withInset:(CGFloat)inset {
    return [self ad_pinEdgeToSameEdgeOfSuperView:edge withInset:inset relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)ad_pinEdgeToSameEdgeOfSuperView:(UIRectEdge)edge {
    return [self ad_pinEdgeToSameEdgeOfSuperView:edge withInset:0.0f];
}

#pragma mark -

- (NSLayoutConstraint *)ad_toAlignOnAxis:(ADAxis)axis withInset:(CGFloat)inset {
    __AD_AUTOLAYOUT_SUPERVIEW_ASSERT()
    return [self __ad_toAlignOnAxis:axis ofView:self.superview withInset:inset];
}

- (NSLayoutConstraint *)ad_toAlignAxisXToAxisXOfView:(UIView *)view {
    return [self __ad_toAlignOnAxis:ADAxisX ofView:view withInset:0.0f];
}

- (NSLayoutConstraint *)ad_toAlignAxisXToAxisXOfView:(UIView *)view withInset:(CGFloat)inset {
    return [self __ad_toAlignOnAxis:ADAxisX ofView:view withInset:inset];
}

- (NSLayoutConstraint *)ad_toAlignAxisYToAxisYOfView:(UIView *)view {
    return [self __ad_toAlignOnAxis:ADAxisY ofView:view withInset:0.0f];
}

- (NSLayoutConstraint *)ad_toAlignAxisYToAxisYOfView:(UIView *)view withInset:(CGFloat)inset {
    return [self __ad_toAlignOnAxis:ADAxisY ofView:view withInset:inset];
}

- (NSLayoutConstraint *)ad_toAlignOnAxisYWithInset:(CGFloat)inset {
    return [self ad_toAlignOnAxis:ADAxisY withInset:inset];
}

- (NSLayoutConstraint *)ad_toAlignOnAxisXWithInset:(CGFloat)inset {
    return [self ad_toAlignOnAxis:ADAxisY withInset:inset];
}

- (NSLayoutConstraint *)ad_toAlignOnAxisY {
    return [self ad_toAlignOnAxis:ADAxisY withInset:0.0f];
}

- (NSLayoutConstraint *)ad_toAlignOnAxisX {
    return [self ad_toAlignOnAxis:ADAxisX withInset:0.0f];
}

- (NSArray *)ad_toAlignToCenterOfSuperView {
    return @[
            [self ad_toAlignOnAxisY],
            [self ad_toAlignOnAxisX]
    ];
}

#pragma mark -

- (NSLayoutConstraint *)ad_height:(CGFloat)height relation:(NSLayoutRelation)relation {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:relation
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0f
                                         constant:height];
}

- (NSLayoutConstraint *)ad_height:(CGFloat)height {
    return [self ad_height:height relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)ad_width:(CGFloat)width relation:(NSLayoutRelation)relation {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:relation
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0f
                                         constant:width];
}

- (NSLayoutConstraint *)ad_width:(CGFloat)width {
    return [self ad_width:width relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)ad_heightEqualToHeightOfView:(UIView *)view relation:(NSLayoutRelation)relation {
    __AD_AUTOLAYOUT_VIEW_ASSERT(view)
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:relation
                                           toItem:view
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.0f
                                         constant:0.0f];
}

- (NSLayoutConstraint *)ad_heightEqualToHeightOfView:(UIView *)view {
    return [self ad_heightEqualToHeightOfView:view relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)ad_widthEqualToWidthOfView:(UIView *)view relation:(NSLayoutRelation)relation {
    __AD_AUTOLAYOUT_VIEW_ASSERT(view)
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:relation
                                           toItem:view
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.0f
                                         constant:0.0f];
}

- (NSLayoutConstraint *)ad_widthEqualToWidthOfView:(UIView *)view {
    return [self ad_widthEqualToWidthOfView:view relation:NSLayoutRelationEqual];
}

#pragma mark - Private Methods

- (NSLayoutConstraint *)__ad_toAlignOnAxis:(ADAxis)axis ofView:(UIView *)view withInset:(CGFloat)inset {
    __AD_AUTOLAYOUT_VIEW_ASSERT(view)
    NSLayoutAttribute attribute = [self __ad_axisToAttribute:axis];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:attribute
                                                                 multiplier:1.0f
                                                                   constant:inset];

    return constraint;
}

- (NSLayoutAttribute)__ad_edgeToLayoutAttribute:(UIRectEdge)edge {
    NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
    switch (edge) {
        case UIRectEdgeLeft:
            attribute = NSLayoutAttributeLeft;
            break;
        case UIRectEdgeRight:
            attribute = NSLayoutAttributeRight;
            break;
        case UIRectEdgeBottom:
            attribute = NSLayoutAttributeBottom;
            break;
        case UIRectEdgeTop:
            attribute = NSLayoutAttributeTop;
            break;
        default:
            break;
    }
    return attribute;
}

- (NSLayoutAttribute)__ad_axisToAttribute:(ADAxis)axis {
    NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
    switch (axis) {
        case ADAxisX:
            attribute = NSLayoutAttributeCenterX;
            break;
        case ADAxisY:
            attribute = NSLayoutAttributeCenterY;
            break;
    }
    return attribute;
}

@end
