//
//  DAKeyboardManager.h
//
//  Created by David Levi on 8/15/13.
//  Copyright (c) 2013 Double Apps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAKeyboardManager : NSObject

@property (readonly) BOOL keyboardVisible;
@property (readonly) CGSize keyboardSize;

+ (DAKeyboardManager*) sharedManager;

- (void) registerViewController:(UIViewController*)controller;
- (void) deregisterViewController:(UIViewController*)controller;

- (CGSize) availableSize:(CGRect)viewFrame;

@end
