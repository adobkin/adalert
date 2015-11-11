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

#import <UIKit/UIkit.h>
#import "ADAlertControllerAnimationProtocol.h"

@class ADAlertControllerAction;
@class ADAlertControllerTextField;
@class ADAlertControllerTextView;

typedef NS_ENUM(NSInteger, ADAlertControllerStyle) {
    ADAlertControllerStyleAlert = 0,
    ADAlertControllerStyleActionSheet
};

NS_ASSUME_NONNULL_BEGIN;

/*!
 * An instance of ADAlertController displays an alert message to the user.
 *
 * The ADAlertController - a replacement for UIAlertController with block-based API. The 
 * ADAlertController displays an alert message to the user and supports two style to display:
 *
 *   - ADAlertControllerStyleAlert - By default an alert displayed modally in center of screen
 *   - ADAlertControllerStyleActionSheet - By default an action sheet displayed modally on bottom of screen
 *
 * After configuring the ADAlertController present it using the presentViewController:animated:completion: method.
 *
 * In addition to displaying a message to a user, you can associate user's actions with your alert controller to give the user
 * a way to respond. Each action is instance of ADAlertControllerAction. To add the action you should use the addAction:
 * or addActions: method. 
 *
 * When you configuring the ADAlertController with the ADAlertControllerStyleAlert style, you can add text fields and text views.
 * To add the text field you should use the addTextField: method, to add the text view - addTextView: method. The ADAlertController
 * lets you provide a block for configuring your text fields prior to display it. The text field is instance of
 * ADAlertControllerTextField, the text view is instance of ADAlertControllerTextView.
 *
 * Additionally, you can add any custom view to the alert controller if used ADAlertControllerStyleAlert style.
 */
@interface ADAlertController : UIViewController

///-----------------------------------------------------------------------------
/// @name Configuring
///-----------------------------------------------------------------------------

/*!
 * The title of the alert controller.
 *
 * The title string is displayed top in the alert controller. You should use this string to get the user’s
 * attention and communicate the reason for displaying the alert.
 */
@property(copy, nonatomic, readwrite, nullable) NSString *title;

/*!
 * The descriptive, which provides more details about the reason for the alert controller.
 *
 * The description string is displayed below the title string. Use this string to provide additional context
 * about the reason for the alert or about the actions that the user might take.
 */
@property(copy, nonatomic, readwrite, nullable) NSString *message;

/*!
 * The style of the alert controller.
 *
 * This value determines how the alert is displayed on screen.
 */
@property(assign, nonatomic, readonly) ADAlertControllerStyle style;

/*!
 * The inset or outset margins for the rectangle around the content view.
 */
@property(assign, nonatomic, readwrite) UIEdgeInsets contentInsets;

/*!
 * Flag used to disable blur effect for content view. Default value is NO.
 */
@property(assign, nonatomic, readwrite) BOOL disableBlurEffects;

/*!
 * Blur style. Default UIBlurEffectStyleExtraLight
 */
@property(assign, nonatomic, readwrite) UIBlurEffectStyle blurStyle;

/*!
 * Background color.
 */
@property(strong, nonatomic, readwrite, nullable) UIColor *backgroundColor;

/*!
 * The Block that will be called upon tapping the background.
 */
@property(copy, nonatomic, readwrite, nullable) void (^backgroundTapHandler)(void);

/*!
 * The animation wich uses to present and dismiss instance of ADAlertController.
 *
 * If is in nil value, will be used default animation. Default is nil.
 */
@property(strong, nonatomic, readwrite, null_resettable) id <ADAlertControllerAnimation> animation;

///-----------------------------------------------------------------------------
/// @name Initializing
///-----------------------------------------------------------------------------

/*!
 * Initializes and returns a new instance.
 *
 * @param title The title string is displayed top in the alert controller. Use this string 
 * 		to get the user’s attention and communicate the reason for the
 * 		alert. Can be nil.
 * @param message The description string is displayed below the title string. Can be nil
 * @param style Determines how the alert controller is displayed on screen.
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                        style:(ADAlertControllerStyle)style NS_DESIGNATED_INITIALIZER;

/*!
 * Initializes and returns a new instance.
 *
 * @param title The title string is displayed top in the alert controller. Use this
 *              string to get the user’s attention and communicate the reason for the
 *              alert. Can be nil.
 * @param message The description string is displayed below the title string. Can be nil
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message;

///-----------------------------------------------------------------------------
/// @name Actions
///-----------------------------------------------------------------------------

/*!
 * Adds an action to the alert controller
 *
 * @param action The action
 */
- (void)addAction:(ADAlertControllerAction *)action;

/*!
 * Adds multiple actions to the alert controller
 *
 * @param actions The Array of actions
 */
- (void)addActions:(NSArray <ADAlertControllerAction *> *)actions;

///-----------------------------------------------------------------------------
/// @name Text Fields & Text Views
///-----------------------------------------------------------------------------

/*!
 * The array of text fields displayed by the alert controller.
 * 
 * Use this property to access the text fields displayed by the alert. The text fields are in 
 * the order in which you added them to the alert controller.
 */
@property(strong, nonatomic, readonly, nullable) NSArray <ADAlertControllerTextField *> *textFields;

/*!
 * The array of text views displayed by the alert controller.
 *
 * Use this property to access the text views displayed by the alert. The text views are in
 * the order in which you added them to the alert controller.
 */
@property(strong, nonatomic, readonly, nullable) NSArray <ADAlertControllerTextView *> *textViews;

/*!
 * Adds a text field to the alert controller.
 *
 * @param configurationHandler A block used to configure the text field. The block takes the text field instance as a parameter,
 * and can modify it properties prior to being displayed.
 */
- (void)addTextField:(nullable void (^)(ADAlertControllerTextField *field))configurationHandler;

/*!
 * Adds a text view to the alert controller.
 *
 * @param configurationHandler A block used to configure the text view. The block takes the text view instance as a parameter,
 * and can modify it properties prior to being displayed.
 */
- (void)addTextView:(nullable void (^)(ADAlertControllerTextView *textView))configurationHandler;

///-----------------------------------------------------------------------------
/// @name Custom Views
///-----------------------------------------------------------------------------

/*!
 * The custom header view that is displayed above the content.
 * Default is nil.
 */
@property(strong, nonatomic, readwrite) UIView *headerView;

/*!
 * The inset or outset margins for the rectangle around the header view.
 */
@property(assign, nonatomic, readwrite) UIEdgeInsets headerInsets;

- (void)addOtherView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END;

