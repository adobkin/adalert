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

#import <UIKit/UIKit.h>
#import "ADAlertControllerTextValidator.h"

NS_ASSUME_NONNULL_BEGIN;

/*!
 * An ADAlertControllerTextView is subclass of UITextView with implementation of
 * validating entered text. The ADAlertControllerTextField for validation of entered
 * text uses the specified validators. Each validator is an instance of 
 * ADAlertControllerTextValidator.
 *
 * Additionally, ADAlertControllerTextView implements the placeholder similar
 * as UITextField
 */
@interface ADAlertControllerTextView : UITextView

///-----------------------------------------------------------------------------
/// @name Placeholder
///-----------------------------------------------------------------------------

/*!
 * The string that is displayed when there is no other text in the text view.
 * Default is nil.
 */
@property(copy, nonatomic, readwrite, nullable) NSString *placeholder;

/*!
 * The styled string that is displayed when there is no other text in the text view.
 * Default is nil.
 */
@property(copy, nonatomic, readwrite, nullable) NSAttributedString *attributedPlaceholder;

///-----------------------------------------------------------------------------
/// @name Validating entered text
///-----------------------------------------------------------------------------

@property(strong, nonatomic, readwrite, nullable) NSArray <ADAlertControllerTextValidator *> *validators;

/*!
 * The color to indicate that the entered text is not valid.
 */
@property(strong, nonatomic, readwrite, null_resettable) UIColor *invalidTextColor;

/*!
 * Adds an validator to the text view
 *
 * @param validator The validator
 */
- (void)addValidator:(ADAlertControllerTextValidator *)validator;

/*!
 * Adds multiple validators to the text view
 *
 * @param validators The array of validators
 */
- (void)addValidators:(NSArray <ADAlertControllerTextValidator *> *)validators;

/*!
 * Returns a Boolean value that indicates whether the entered text is valid.
 * 
 * Checks the entered text against the specified validators. The method returns YES
 * if the text meets all specified validators, otherwise NO.
 * 
 * Additionally, when the text is not valid this method visually highlights the text
 * field, uses shake animation and colores the entered text with invalidTextColor
 *
 * @return YES if text is valid, otherwise NO.
 */
- (BOOL)isValidText;

- (void)invalidValue;
- (void)validValue;

@end

NS_ASSUME_NONNULL_END;
