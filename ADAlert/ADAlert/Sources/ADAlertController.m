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

#import "ADAlertController.h"
#import "ADAlertControllerTextField.h"
#import "ADAlertControllerTextView.h"
#import "ADAlertControllerAction.h"
#import "ADAlertControllerButton.h"
#import "ADAlertControllerAnimatedTransitioning.h"
#import "ADAlertControllerPresentationController.h"
#import "ADAlertControllerAnimationDefault.h"
#import "ADAlertControllerAnimationActionsSheetDefault.h"
#import "ADAlertControllerDefaultColors.h"

#import "UIView+AutoLayout.h"
#import "NSArray+AutoLayout.h"
#import "NSLayoutConstraint+AutoLayout.h"

const CGFloat kContentCornerRadius = 3.0f;

@interface ADAlertController () <UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate> {
    UIView *_containerView;
    UIView *_buttonsView;
    UIScrollView *_contentView;
    UIView *_contentInnerView;
    UIView *_customContentView;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    NSArray <ADAlertControllerTextField *> *_textFields;
    NSArray <ADAlertControllerTextView *> *_textViews;
}
@property(assign, nonatomic, readwrite) ADAlertControllerStyle style;

@property(strong, nonatomic, readonly) UILabel *titleLabel;
@property(strong, nonatomic, readonly) UILabel *messageLabel;
@property(strong, nonatomic, readonly) UIView *containerView;
@property(strong, nonatomic, readonly) UIScrollView *contentView;
@property(strong, nonatomic, readonly) UIView *contentInnerView;
@property(strong, nonatomic, readonly) UIView *buttonsView;
@property(strong, nonatomic, readonly) UIView *customContentView;
@property(strong, nonatomic, readwrite) NSLayoutConstraint *contentHeight;
@property(assign, nonatomic, readwrite) BOOL keyboardVisible;
@property(assign, nonatomic, readwrite) CGFloat keyboardHeight;
@property(strong, nonatomic, readwrite) NSLayoutConstraint *alertViewYConstraint;

@property(assign, nonatomic, readwrite) BOOL hasCancelAction;
@property(strong, nonatomic, readwrite, nullable) NSMutableArray <ADAlertControllerButton *> *buttons;
@property(strong, nonatomic, readwrite, nullable) NSMutableArray <UIView *> *customViews;
@property(strong, nonatomic, readwrite, nullable) NSMutableArray <UIView <UITextInputTraits> *> *textFieldsAndViews;
@property(assign, nonatomic, readwrite) UIEdgeInsets screenInsets;

@property(assign, nonatomic, readwrite) NSInteger textFieldsNextTag;
@end

@implementation ADAlertController

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message style:(ADAlertControllerStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.headerInsets = UIEdgeInsetsZero;
        self.contentInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        self.screenInsets = (style == ADAlertControllerStyleAlert) ? UIEdgeInsetsMake(25.0f, 25.0f, 25.0f, 25.0f) : UIEdgeInsetsZero;
 
        self.title = title;
        self.message = message;
        self.customViews = [NSMutableArray array];
        self.textFieldsAndViews = [NSMutableArray array];
        self.buttons = [NSMutableArray array];
        self.style = style;
        self.transitioningDelegate = self;
        self.disableBlurEffects = NO;
        self.blurStyle = UIBlurEffectStyleExtraLight;

        if (style == ADAlertControllerStyleActionSheet && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            super.modalPresentationStyle = UIModalPresentationPopover;
            self.popoverPresentationController.delegate = self;
        } else {
            super.modalPresentationStyle = UIModalPresentationCustom;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__ad_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__ad_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    return [self initWithTitle:title message:message style:ADAlertControllerStyleAlert];
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    return [self initWithTitle:nil message:nil];
}

- (instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    return [self initWithTitle:nil message:nil];
}

- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self __ad_resignFirstResponders];
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:UIScreen.mainScreen.applicationFrame];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.containerView];
    
    UIView * contentSuperview = nil;
    if (self.disableBlurEffects) {
        self.containerView.backgroundColor = [UIColor whiteColor];
        contentSuperview = self.containerView;
    } else {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.blurStyle];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.containerView addSubview:blurView];
        [[blurView ad_pinAllEdgesToSameEdgesOfSuperView] ad_installConstraints];
        contentSuperview = blurView.contentView;
    }
    
    if (self.style == ADAlertControllerStyleAlert) {
        [self __ad_setupAlertLayout];
    } else {
        [self __ad_setupActionsSheetLayout];
    }
    
    [self __ad_layoutContentView:contentSuperview];
    [self __ad_setupUI];
    [self __ad_setupMotion];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    return nil;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.contentInnerView updateConstraintsIfNeeded];
    [self.contentInnerView layoutIfNeeded];
    
    CGFloat width = CGRectGetWidth(self.contentInnerView.bounds);
    if(self.message) {
        self.messageLabel.preferredMaxLayoutWidth = width;
    }
    if(self.title) {
        self.titleLabel.preferredMaxLayoutWidth = width;
    }
    
    [self.contentInnerView updateConstraintsIfNeeded];
    [self.contentInnerView layoutIfNeeded];
    
    CGFloat height = [self __ad_contentHeight];
    self.contentHeight.constant = height;
    
    if(self.modalPresentationStyle == UIModalPresentationPopover) {
        CGSize size = [self.containerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
        self.preferredContentSize = size;
    }
    
    [super viewDidLayoutSubviews];
}

#pragma mark - Properties

- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
}

- (id <ADAlertControllerAnimation>)animation {
    if (_animation) {
        return _animation;
    }
    if (self.style == ADAlertControllerStyleAlert) {
        _animation = [ADAlertControllerAnimationDefault new];
    } else {
        _animation = [ADAlertControllerAnimationActionsSheetDefault new];
    }
    return _animation;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView ad_viewWithAutoLayout];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UIScrollView *) contentView {
    if(!_contentView) {
        _contentView = [UIScrollView ad_viewWithAutoLayout];
    }
    return _contentView;
}

- (UIView *)contentInnerView {
    if (!_contentInnerView) {
        _contentInnerView = [UIView ad_viewWithAutoLayout];
    }
    return _contentInnerView;
}

- (UIView *)customContentView {
    if(!_customContentView) {
        _customContentView = [UIView ad_viewWithAutoLayout];
        [_customContentView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_customContentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _customContentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel ad_viewWithAutoLayout];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel ad_viewWithAutoLayout];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:13.0f];
        [_messageLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _messageLabel;
}

- (NSArray <ADAlertControllerTextField *> *)textFields {
    if (!_textFields) {
        _textFields = (NSArray <ADAlertControllerTextField *> *)[self.textFieldsAndViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class = %@", [ADAlertControllerTextField class]]];
    }
    return _textFields;
}

- (NSArray <ADAlertControllerTextView *> *)textViews {
    if (!_textViews) {
        _textViews = (NSArray <ADAlertControllerTextView *> *)[self.textFieldsAndViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.class = %@", [ADAlertControllerTextView class]]];
    }
    return _textViews;
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
}

- (NSString *)message {
    return self.messageLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (UIView *)buttonsView {
    if (!_buttonsView) {
        _buttonsView = [UIView ad_viewWithAutoLayout];
        _buttonsView.backgroundColor = [UIColor clearColor];
    }
    return _buttonsView;
}

#pragma mark - Actions

- (void)addAction:(nonnull ADAlertControllerAction *)action {
    NSParameterAssert(action);
    [self __ad_addAction:action];
}

- (void)addActions:(NSArray <ADAlertControllerAction *> *)actions {
    NSParameterAssert(actions);
    for (id item in actions) {
        if ([item isKindOfClass:[ADAlertControllerAction class]]) {
            [self addAction:item];
        }
    }
}

#pragma mark - Text Fields

- (void)addTextField:(nullable void (^)(ADAlertControllerTextField *field))configurationHandler {
    if (self.style == ADAlertControllerStyleAlert) {
        ADAlertControllerTextField *textField = [ADAlertControllerTextField new];
        if (configurationHandler) {
            configurationHandler(textField);
        }
        textField.delegate = self;
        [self __ad_addTextItem:textField];
    }
}

- (void)addTextView:(nullable void (^)(ADAlertControllerTextView *textView))configurationHandler {
    if(self.style == ADAlertControllerStyleAlert) {
        ADAlertControllerTextView *textView = [ADAlertControllerTextView new];
        if (configurationHandler) {
            configurationHandler(textView);
        }
        textView.delegate = self;
        [self __ad_addTextItem:textView];
    }
}

#pragma mark - Custom View

- (void)addOtherView:(UIView *)view {
    NSParameterAssert(view);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.customViews addObject:view];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == self.textFieldsNextTag - 1) {
        [textField resignFirstResponder];
    } else {
        UIView <UITextInputTraits> *nextTextField = self.textFieldsAndViews[(NSUInteger) (textField.tag + 1)];
        [nextTextField becomeFirstResponder];
    }
    return NO;
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.tag == self.textFieldsNextTag - 1) {
            [textView resignFirstResponder];
        } else {
            UIView <UITextInputTraits> *textView = self.textFieldsAndViews[(NSUInteger) (textView.tag + 1)];
            [textView becomeFirstResponder];
        }
    }
    return YES;
}

#pragma mark - UIViewController Transitioning Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)__unused presented
                                                                   presentingController:(UIViewController *)__unused presenting
                                                                       sourceController:(UIViewController *)__unused source {

    return [[ADAlertControllerAnimatedTransitioning alloc] initWithAnimation:self.animation transitionType:ADAlertControllerAlertAnimatedTypePresent];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)__unused dismissed {
    return [[ADAlertControllerAnimatedTransitioning alloc] initWithAnimation:self.animation transitionType:ADAlertControllerAlertAnimatedTypeDismiss];
}

#pragma mark - UIPresentationController

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {

    ADAlertControllerPresentationController *presentationController = [[ADAlertControllerPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentationController.backgroundColor = self.backgroundColor;
    return presentationController;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - UIPopoverPresentationController Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    [self __ad_dismiss];
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.containerView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Layouts (Private)

- (void)__ad_setupAlertLayout {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[self.containerView ad_width:290.0f] ad_installConstraint];
        [[self.containerView ad_toAlignOnAxisX] ad_installConstraint];
    } else {
        [[self.containerView ad_width:350.0f] ad_installConstraint];
        [[self.containerView ad_toAlignOnAxisX] ad_installConstraint];
    }
    
    self.alertViewYConstraint = [self.containerView ad_toAlignOnAxisY];
    [self.alertViewYConstraint ad_installConstraint];
}

- (void)__ad_setupActionsSheetLayout {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        [[self.containerView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeBottom withInsets:ADEdgeInsets(10.0f)] ad_installConstraints];
        [[self.containerView ad_width:350.0f] ad_installConstraint];
        [[self.containerView ad_toAlignOnAxisX] ad_installConstraint];
    }
    
    [[self.containerView ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeLeft withInset:self.screenInsets.left] ad_installConstraint];
    [[self.containerView ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeRight withInset:-self.screenInsets.bottom] ad_installConstraint];
    [[self.containerView ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeBottom withInset:-self.screenInsets.right] ad_installConstraint];
}

- (void)__ad_layoutButtonsVertical: (UIView *) buttonsSuperview  {
    UIButton *__block lastButton = nil;
    
    void (^layoutButtons)(ADAlertControllerActionStyle) = ^(ADAlertControllerActionStyle style) {
        NSArray <ADAlertControllerButton *> *buttons = [self __bs_buttonsWithActionStyle:style];
        for (UIButton *button in buttons) {
            [buttonsSuperview addSubview:button];
            [[button ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight] ad_installConstraints];
            if (lastButton) {
                [[button ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:lastButton withInset:8.0f] ad_installConstraint];
                [[button ad_heightEqualToHeightOfView:lastButton] ad_installConstraint];
            }
            lastButton = button;
        }
    };

    layoutButtons(ADAlertControllerActionStyleDefault);
    layoutButtons(ADAlertControllerActionStyleDestructive);
    layoutButtons(ADAlertControllerActionStyleCancel);

    [[[buttonsSuperview.subviews firstObject] ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeTop] ad_installConstraint];
    [[lastButton ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeBottom] ad_installConstraint];
}

- (void)__ad_layoutButtonsHorizontal: (UIView *) buttonsSuperview {
    ADAlertControllerButton *leftButtonView = [self.buttons firstObject];
    ADAlertControllerButton *rightButtonView = [self.buttons lastObject];

    if (rightButtonView.action.style == ADAlertControllerActionStyleCancel || rightButtonView.action.style == ADAlertControllerActionStyleDestructive) {
        ADAlertControllerButton *tmp = leftButtonView;
        leftButtonView = rightButtonView;
        rightButtonView = tmp;
    }

    [buttonsSuperview addSubview:leftButtonView];
    [buttonsSuperview addSubview:rightButtonView];

    [[leftButtonView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeTop | UIRectEdgeBottom] ad_installConstraints];
    [[rightButtonView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeRight | UIRectEdgeTop | UIRectEdgeBottom] ad_installConstraints];
    [[rightButtonView ad_pinEdge:UIRectEdgeLeft toEdge:UIRectEdgeRight ofView:leftButtonView withInset:8.0f] ad_installConstraint];
    [[rightButtonView ad_widthEqualToWidthOfView:leftButtonView] ad_installConstraint];
    [[rightButtonView ad_heightEqualToHeightOfView:leftButtonView] ad_installConstraint];
}

- (void) __ad_layoutButtons: (UIView *) buttonsSuperview {
    if ([self.buttons count] == 2 && self.style == ADAlertControllerStyleAlert) {
        [self __ad_layoutButtonsHorizontal: buttonsSuperview];
    } else {
        [self __ad_layoutButtonsVertical:buttonsSuperview];
    }
}

- (void) __ad_layoutCustomViews: (UIView *) customViewsSuperview {
    if([self.customViews count] > 0) {
        UIView *topCustomView = nil;
        for (UIView *customView in self.customViews) {
            [customViewsSuperview addSubview:customView];
            [[customView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight] ad_installConstraints];
            if (topCustomView) {
                [[topCustomView ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:topCustomView withInset:5.0f] ad_installConstraint];
            }
            topCustomView = customView;
        }
    } else {
        UIView <UITextInputTraits> *lastField = nil;
        for (UIView <UITextInputTraits> *field in self.textFieldsAndViews) {
            [customViewsSuperview addSubview:field];
            [[field ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight] ad_installConstraints];
            if ([field isKindOfClass:[ADAlertControllerTextView class]]) {
                [[field ad_height:[self __ad_textViewHeight]] ad_installConstraint];
            } else {
                [[field ad_height:40.0f] ad_installConstraint];
            }
            if (lastField) {
                [[field ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:lastField withInset:5.0f] ad_installConstraint];
            }
            lastField = field;
        }
    }
    
    [[[customViewsSuperview.subviews firstObject] ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeTop] ad_installConstraint];
    [[[customViewsSuperview.subviews lastObject] ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeBottom] ad_installConstraint];
}

- (void) __ad_layoutContentView: (UIView *) contentSuperview {
    [contentSuperview addSubview:self.contentView];
    [[self.contentView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom withInsets:UIEdgeInsetsMake(0.0f, self.contentInsets.left, -self.contentInsets.bottom, -self.contentInsets.right)] ad_installConstraints];
    
    if(self.headerView) {
        [contentSuperview addSubview:self.headerView];
        [[self.headerView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeTop withInsets:UIEdgeInsetsMake(self.headerInsets.top, self.headerInsets.left, 0.0f, -self.headerInsets.right)] ad_installConstraints];
        [[self.contentView ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:self.headerView withInset:10.0f] ad_installConstraint];
    } else {
        [[self.contentView ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeTop withInset:self.contentInsets.top] ad_installConstraint];
    }
    
    [self.contentView addSubview:self.contentInnerView];
    [[self.contentInnerView ad_pinAllEdgesToSameEdgesOfSuperView] ad_installConstraints];
    [[self.contentInnerView ad_widthEqualToWidthOfView:self.contentView] ad_installConstraint];

    UIView *bottomView = nil;
    
    if (self.title) {
        self.titleLabel.text = self.title;
        [self.contentInnerView addSubview:self.titleLabel];
        [[self.titleLabel ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight] ad_installConstraints];
        bottomView = self.titleLabel;
    }
    
    if (self.message) {
        self.messageLabel.text = self.message;
        [self.contentInnerView addSubview:self.messageLabel];
        [[self.messageLabel ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight] ad_installConstraints];
        if (bottomView) {
            [[self.messageLabel ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:bottomView withInset:10.0f] ad_installConstraint];
        }
        bottomView = self.messageLabel;
    }
    
    if([self.customViews count] > 0 || [self.textFieldsAndViews count] > 0) {
        [self.contentInnerView addSubview:self.customContentView];
        [[self.customContentView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeRight] ad_installConstraints];
        if (bottomView) {
            [[self.customContentView ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:bottomView withInset:10.0f] ad_installConstraint];
        }
        bottomView = self.customContentView;
        [self __ad_layoutCustomViews:self.customContentView];
    }
    
    if([self.buttons count] > 0) {
        [self.contentInnerView addSubview:self.buttonsView];
        [[self.buttonsView ad_pinEdgesToSameEdgesOfSuperView:UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight] ad_installConstraints];
        if(bottomView) {
            [[self.buttonsView ad_pinEdge:UIRectEdgeTop toEdge:UIRectEdgeBottom ofView:bottomView withInset:10.0f] ad_installConstraint];
        }
        bottomView = self.buttonsView;
        [self __ad_layoutButtons:self.buttonsView];
    }
    
    [[bottomView ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeBottom] ad_installConstraint];
    [[[self.contentInnerView.subviews firstObject] ad_pinEdgeToSameEdgeOfSuperView:UIRectEdgeTop] ad_installConstraint];
    
    self.contentHeight = [self.contentView ad_height:0.0f];
    [self.contentHeight ad_installConstraint];
}

#pragma mark - Notifications (Private)

- (void)__ad_keyboardWillShow:(NSNotification *)notification {
    if (!self.keyboardVisible) {
        CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        self.keyboardHeight = CGRectGetHeight(keyboardFrame);
        
        self.alertViewYConstraint.constant -= CGRectGetHeight(keyboardFrame) / 2.0f;
        
        NSNumber *durationValue = [notification userInfo][UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = durationValue.doubleValue;
        NSNumber *curveValue = [notification userInfo][UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) curveValue.intValue;

        self.keyboardVisible = YES;
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(UIViewAnimationOptions) (animationCurve << 16)
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:nil];

    }
}

- (void)__ad_keyboardWillHide:(NSNotification *)notification {
    if (self.keyboardVisible) {
        self.keyboardHeight = 0.0f;
        self.alertViewYConstraint.constant = 0.0f;
        NSNumber *durationValue = [notification userInfo][UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = durationValue.doubleValue;
        NSNumber *curveValue = [notification userInfo][UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) curveValue.intValue;

        self.keyboardVisible = NO;
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(UIViewAnimationOptions) (animationCurve << 16)
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }
}

#pragma mark - Other Methods (Private)

- (void)__ad_addTextItem:(UIView <UITextInputTraits> *)textItem {
    textItem.tag = self.textFieldsNextTag;
    textItem.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (self.textFieldsNextTag > 0) {
        id <UITextInputTraits> lastObject = [self.textFieldsAndViews lastObject];
        if (lastObject) {
            lastObject.returnKeyType = UIReturnKeyNext;
        }
    }
    [self.textFieldsAndViews addObject:textItem];
    self.textFieldsNextTag++;
}

- (void)__ad_resignFirstResponders {
    [self.textFieldsAndViews enumerateObjectsUsingBlock:^(UIView *textItem, NSUInteger idx, BOOL *stop) {
        if (([textItem isKindOfClass:[ADAlertControllerTextField class]] && ((ADAlertControllerTextField *) textItem).isEditing) ||
            ([textItem isKindOfClass:[ADAlertControllerTextView class]] && ((ADAlertControllerTextView *) textItem).editable)) {
            [textItem resignFirstResponder];
        }
    }];
}

- (void)__ad_addAction:(ADAlertControllerAction *)action {
    if (action.style == ADAlertControllerActionStyleCancel) {
        if (self.hasCancelAction) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"BSAlertViewController can only have one button with a style of ADAlertControllerActionStyleCancel" userInfo:nil];
        }
        self.hasCancelAction = YES;
    }
    
    ADAlertControllerButton *button = [[ADAlertControllerButton alloc] initWithAction:action];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [button addTarget:self action:@selector(__ad_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
}

- (void)__ad_buttonPressed:(ADAlertControllerButton *)button {
    if (button.action.handler) {
        button.action.handler(button.action);
    }
}

- (nullable NSArray <ADAlertControllerButton *> *)__bs_buttonsWithActionStyle:(ADAlertControllerActionStyle)actionStyle {
    return [self.buttons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.action.style = %@", @(actionStyle)]];
}

- (void)__ad_setupUI {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__ad_dismiss)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = self;
    
    [self.view setMultipleTouchEnabled:NO];
    [self.view setExclusiveTouch:YES];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.containerView.layer.cornerRadius = (self.style == ADAlertControllerStyleAlert) ? kContentCornerRadius : 0.0f;
    UIColor *backgroundColor = self.disableBlurEffects ? [UIColor whiteColor] : [UIColor clearColor];
    
    self.containerView.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
    self.contentInnerView.backgroundColor = backgroundColor;
    if(_customContentView) {
        self.customContentView.backgroundColor = backgroundColor;
    }
    if(_buttonsView) {
        self.buttonsView.backgroundColor = backgroundColor;
    }
    
    UIColor *titleColor = nil;
    UIColor *textColor = nil;
    
    if(!self.disableBlurEffects) {
        switch (self.blurStyle) {
            case UIBlurEffectStyleDark:
                titleColor = kColorTitleBlurDark;
                textColor = kColorTextBlurDark;
                break;
            case UIBlurEffectStyleLight:
                titleColor = kColorTitleBlurLight;
                textColor = kColorTextBlurLight;
                break;
            case UIBlurEffectStyleExtraLight:
                break;
        }
    }
    
    titleColor = titleColor ?: kColorTitle;
    textColor = textColor ?: kColorText;
    
    if(_titleLabel) {
        self.titleLabel.textColor = titleColor;
        self.titleLabel.backgroundColor = backgroundColor;

    }
    
    if(_messageLabel) {
        self.messageLabel.textColor = textColor;
        self.messageLabel.backgroundColor = backgroundColor;
    }
}

- (void)__ad_setupMotion {
    if (!UIAccessibilityIsReduceMotionEnabled() && self.style == ADAlertControllerStyleAlert) {
        UIInterpolatingMotionEffect *xMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        UIInterpolatingMotionEffect *yMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        xMotionEffect.maximumRelativeValue = @(10.0f);
        xMotionEffect.minimumRelativeValue = @(-10.0f);
        yMotionEffect.maximumRelativeValue = @(10.0f);
        yMotionEffect.minimumRelativeValue = @(-10.0f);
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[xMotionEffect, yMotionEffect];
        [self.containerView addMotionEffect:group];
    }
}

- (CGFloat)__ad_textViewHeight {
    CGFloat height = 80.0f;
    if (self.textFieldsNextTag == 1) {
        height = 230.0f;
    }
    return height;
}

- (CGFloat) __ad_contentHeight {
    CGFloat maxContentHeight = [self __ad_maxHeight];
    
    CGSize size = [self.contentInnerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
    
    CGFloat height = size.height < maxContentHeight ? size.height : maxContentHeight;
    return height;
}

- (CGFloat)__ad_maxHeight {
    CGFloat maxContentHeight = [UIScreen mainScreen].bounds.size.height - (
                                                                           self.contentInsets.top +
                                                                           self.contentInsets.bottom +
                                                                           self.screenInsets.top +
                                                                           self.screenInsets.bottom);
    if(self.keyboardVisible) {
        maxContentHeight -= self.keyboardHeight;
    }
    
    return maxContentHeight;
}

- (void)__ad_dismiss {
    [self __ad_resignFirstResponders];
    if (self.backgroundTapHandler) {
        self.backgroundTapHandler();
    }
}

@end