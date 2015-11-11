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

#import <Foundation/Foundation.h>

@class ADAlertControllerAction;
@class UIColor;
@class UIFont;

/*!
 * Actions styles. 
 * Use to determine the display style and position of the actinon's button
 */
typedef NS_ENUM(NSInteger, ADAlertControllerActionStyle) {
    /*! Default style to the action's button. */
	ADAlertControllerActionStyleDefault = 0,
    /*! This style indicates the action might change or delete data. */
	ADAlertControllerActionStyleDestructive = 1,
     /*! This style indicates the action cancels the operation and leaves things unchanged. */
	ADAlertControllerActionStyleCancel,
};

NS_ASSUME_NONNULL_BEGIN;

typedef void (^ADAlertControllerActionHandler)(ADAlertControllerAction *);

/*!
 * The ADAlertControllerAction instance represents an action. For each action ADAlertController 
 * creates and configures a button. When the user taps that button, the alert controller executes 
 * the block wich you specified when creating the action instance.
 *
 * You should use this class to add information about an action, including the title and style of button,
 * and a handler to execute when the user taps the button. After creating the action, add it to the ADAlertController
 * instance before displaying it.
 */
@interface ADAlertControllerAction : NSObject <NSCopying>

/*!
 * The title of action
 */
@property(copy, nonatomic, readonly) NSString *title;

/*!
 * The style of action
 */
@property(assign, nonatomic, readonly) ADAlertControllerActionStyle style;

/*!
 * The Block that will be called upon tapping the action.
 */
@property(copy, nonatomic, readwrite, nullable) ADAlertControllerActionHandler handler;

///-----------------------------------------------------------------------------
/// @name Creating && Initializing
///-----------------------------------------------------------------------------

/*!
 * Initializes and returns a new instance of action.
 *
 * @param title The title string is displayed on the button.
 * @param style The style information to convey the type of action that is performed by the button.
 * @param handler A block that called when the user selects the action.
 */
- (instancetype)initWithTitle:(NSString *)title
                        style:(ADAlertControllerActionStyle)style
                      handler:(nullable ADAlertControllerActionHandler)handler NS_DESIGNATED_INITIALIZER;

/*!
 * Initializes and returns a new instance of action with default style.
 *
 * @param title The title string is displayed on the button.
 * @param handler A block that called when the user selects the action.
 */
- (instancetype)initWithTitle:(NSString *)title
                      handler:(nullable ADAlertControllerActionHandler)handler;

/*!
 * Creates, initializes and returns a new instance of action.
 *
 * @param title The title string is displayed on the button.
 * @param style The style information to convey the type of action that is performed by the button.
 * @param handler A block that called when the user selects the action.
 */
+ (instancetype)actionWithTitle:(NSString *)title
                          style:(ADAlertControllerActionStyle)style
                        handler:(nullable ADAlertControllerActionHandler)handler;

/*!
 * Creates, initializes and returns a new instance of action with default style.
 *
 * @param title The title string is displayed on the button.
 * @param handler A block that called when the user selects the action.
 */
+ (instancetype)actionWithTitle:(NSString *)title handler:(nullable ADAlertControllerActionHandler)handler;

///-----------------------------------------------------------------------------
/// @name Comparing Actions
///-----------------------------------------------------------------------------

/*!
 * Returns a Boolean value that indicates whether a given action is equal the receiver.
 *
 * @param otherAction The action with which to compare the receiver.
 * @return YES if otherAction is equivalent to the receiver, otherwise NO.
 */
- (BOOL)isEqualToAction:(ADAlertControllerAction *)otherAction;

@end

NS_ASSUME_NONNULL_END;
