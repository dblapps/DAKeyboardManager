//
//  DAKeyboardManager.h
//
//  Created by David Levi on 8/15/13.
//  Copyright (c) 2013 Double Apps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAKeyboardManager;
@protocol DAKeyboardManagerProtocol <NSObject>
@optional
- (void) keyboardManagerWillShow:(NSNotification*)notification;
- (void) keyboardManagerDidShow:(NSNotification*)notification;
- (void) keyboardManagerWillChange:(NSNotification*)notification;
- (void) keyboardManagerDidChange:(NSNotification*)notification;
- (void) keyboardManagerWillHide:(NSNotification*)notification;
- (void) keyboardManagerDidHide:(NSNotification*)notification;
@end

@interface DAKeyboardManager : NSObject

@property (readonly) BOOL keyboardVisible;
@property (readonly) CGSize keyboardSize;
@property (readonly) CGSize keyboardBeginSize;
@property (readonly) CGSize keyboardEndSize;

+ (DAKeyboardManager*) sharedManager;

- (void) registerViewController:(UIViewController*)controller;
- (void) deregisterViewController:(UIViewController*)controller;
- (void) register:(id<DAKeyboardManagerProtocol>)object;
- (void) deregister:(id<DAKeyboardManagerProtocol>)object;

- (CGSize) availableSize:(CGRect)viewFrame;
- (CGSize) availableBeginSize:(CGRect)viewFrame;
- (CGSize) availableEndSize:(CGRect)viewFrame;

@end
