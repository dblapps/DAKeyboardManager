//
//  DAKeyboardManager.h
//
//  Created by David Levi on 8/15/13.
//  Copyright (c) 2013 Double Apps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAKeyboardManagerProtocol <NSObject>
@optional
- (void) keyboardWillShow:(NSNotification*)notification;
- (void) keyboardDidShow:(NSNotification*)notification;
- (void) keyboardWillChange:(NSNotification*)notification;
- (void) keyboardDidChange:(NSNotification*)notification;
- (void) keyboardWillHide:(NSNotification*)notification;
@end

@interface DAKeyboardManager : NSObject

@property (readonly) BOOL keyboardVisible;
@property (readonly) CGSize keyboardSize;

+ (DAKeyboardManager*) sharedManager;

- (void) registerViewController:(UIViewController*)controller;
- (void) deregisterViewController:(UIViewController*)controller;
- (void) register:(id<DAKeyboardManagerProtocol>)object;
- (void) deregister:(id<DAKeyboardManagerProtocol>)object;

- (CGSize) availableSize:(CGRect)viewFrame;

@end
