//
//  DAKeyboardManager.m
//
//  Created by David Levi on 8/15/13.
//  Copyright (c) 2013 Double Apps Inc. All rights reserved.
//

#import "DAKeyboardManager.h"

@interface DAKeyboardManager ()
- (void) keyboardWillShow:(NSNotification*)notification;
- (void) keyboardDidShow:(NSNotification*)notification;
- (void) keyboardWillHide:(NSNotification*)notification;
@end

@implementation DAKeyboardManager
{
	NSMutableArray* viewControllers;
}

+ (DAKeyboardManager*) sharedManager
{
	static dispatch_once_t pred = 0;
	__strong static DAKeyboardManager* s_sharedManager = nil;
	dispatch_once(&pred, ^{
		s_sharedManager = [[DAKeyboardManager alloc] init];
	});
	return s_sharedManager;
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		_keyboardVisible = NO;
		viewControllers = [NSMutableArray array];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardDidShow:)
													 name:UIKeyboardDidShowNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification object:nil];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) registerViewController:(UIViewController*)controller
{
	if (![viewControllers containsObject:controller]) {
		[viewControllers addObject:controller];
	}
}

- (void) deregisterViewController:(UIViewController*)controller
{
	[viewControllers removeObject:controller];
}

- (CGSize) availableSize:(CGRect)viewFrame
{
	viewFrame.size.height -= self.keyboardSize.height;
	return viewFrame.size;
}


#pragma mark - DAKeyboardManager ()

- (void) keyboardWillShow:(NSNotification*)notification
{
	_keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	if (viewControllers.count > 0) {
		UIViewController* controller = (UIViewController*)[viewControllers lastObject];
		if (UIInterfaceOrientationIsLandscape(controller.interfaceOrientation)) {
			_keyboardSize = CGSizeMake(_keyboardSize.height, _keyboardSize.width);
		}
	}
	if (_keyboardVisible) {
		for (UIViewController* controller in viewControllers) {
			if ([controller respondsToSelector:@selector(keyboardWillChange:)]) {
				[controller performSelector:@selector(keyboardWillChange:) withObject:notification];
			}
		}
	} else {
		for (UIViewController* controller in viewControllers) {
			if ([controller respondsToSelector:@selector(keyboardWillShow:)]) {
				[controller performSelector:@selector(keyboardWillShow:) withObject:notification];
			}
		}
	}
}

- (void) keyboardDidShow:(NSNotification*)notification
{
	BOOL keyboardWasVisible = _keyboardVisible;
	_keyboardVisible = YES;
	if (keyboardWasVisible) {
		for (UIViewController* controller in viewControllers) {
			if ([controller respondsToSelector:@selector(keyboardDidChange:)]) {
				[controller performSelector:@selector(keyboardDidChange:) withObject:notification];
			}
		}
	} else {
		for (UIViewController* controller in viewControllers) {
			if ([controller respondsToSelector:@selector(keyboardDidShow:)]) {
				[controller performSelector:@selector(keyboardDidShow:) withObject:notification];
			}
		}
	}
}

- (void) keyboardWillHide:(NSNotification*)notification
{
	_keyboardVisible = NO;
	for (UIViewController* controller in viewControllers) {
		if ([controller respondsToSelector:@selector(keyboardWillHide:)]) {
			[controller performSelector:@selector(keyboardWillHide:) withObject:notification];
		}
	}
}

@end
