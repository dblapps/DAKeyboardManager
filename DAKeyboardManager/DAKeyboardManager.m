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
	NSMutableArray* registeredViewControllers;
	NSMutableArray* registeredObjects;
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
		registeredViewControllers = [NSMutableArray array];
		registeredObjects = [NSMutableArray array];
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
	if (![registeredViewControllers containsObject:controller]) {
		[registeredViewControllers addObject:controller];
	}
}

- (void) deregisterViewController:(UIViewController*)controller
{
	[registeredViewControllers removeObject:controller];
}

- (void) register:(id<DAKeyboardManagerProtocol>)object
{
	if (![registeredObjects containsObject:object]) {
		[registeredObjects addObject:object];
	}
}

- (void) deregister:(id<DAKeyboardManagerProtocol>)object
{
	[registeredObjects removeObject:object];
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
	if (registeredViewControllers.count > 0) {
		UIViewController* controller = (UIViewController*)[registeredViewControllers lastObject];
		if (UIInterfaceOrientationIsLandscape(controller.interfaceOrientation)) {
			_keyboardSize = CGSizeMake(_keyboardSize.height, _keyboardSize.width);
		}
	}
	if (_keyboardVisible) {
		for (UIViewController* controller in registeredViewControllers) {
			if ([controller respondsToSelector:@selector(keyboardWillChange:)]) {
				[controller performSelector:@selector(keyboardWillChange:) withObject:notification];
			}
		}
		for (id<DAKeyboardManagerProtocol> object in registeredObjects) {
			if ([object respondsToSelector:@selector(keyboardWillChange:)]) {
				[object performSelector:@selector(keyboardWillChange:) withObject:notification];
			}
		}
	} else {
		for (UIViewController* controller in registeredViewControllers) {
			if ([controller respondsToSelector:@selector(keyboardWillShow:)]) {
				[controller performSelector:@selector(keyboardWillShow:) withObject:notification];
			}
		}
		for (id<DAKeyboardManagerProtocol> object in registeredObjects) {
			if ([object respondsToSelector:@selector(keyboardWillShow:)]) {
				[object performSelector:@selector(keyboardWillShow:) withObject:notification];
			}
		}
	}
}

- (void) keyboardDidShow:(NSNotification*)notification
{
	BOOL keyboardWasVisible = _keyboardVisible;
	_keyboardVisible = YES;
	_keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	if (keyboardWasVisible) {
		for (UIViewController* controller in registeredViewControllers) {
			if ([controller respondsToSelector:@selector(keyboardDidChange:)]) {
				[controller performSelector:@selector(keyboardDidChange:) withObject:notification];
			}
		}
		for (id<DAKeyboardManagerProtocol> object in registeredObjects) {
			if ([object respondsToSelector:@selector(keyboardDidChange:)]) {
				[object performSelector:@selector(keyboardDidChange:) withObject:notification];
			}
		}
	} else {
		for (UIViewController* controller in registeredViewControllers) {
			if ([controller respondsToSelector:@selector(keyboardDidShow:)]) {
				[controller performSelector:@selector(keyboardDidShow:) withObject:notification];
			}
		}
		for (id<DAKeyboardManagerProtocol> object in registeredObjects) {
			if ([object respondsToSelector:@selector(keyboardDidShow:)]) {
				[object performSelector:@selector(keyboardDidShow:) withObject:notification];
			}
		}
	}
}

- (void) keyboardWillHide:(NSNotification*)notification
{
	_keyboardVisible = NO;
	for (UIViewController* controller in registeredViewControllers) {
		if ([controller respondsToSelector:@selector(keyboardWillHide:)]) {
			[controller performSelector:@selector(keyboardWillHide:) withObject:notification];
		}
	}
	for (id<DAKeyboardManagerProtocol> object in registeredObjects) {
		if ([object respondsToSelector:@selector(keyboardWillHide:)]) {
			[object performSelector:@selector(keyboardWillHide:) withObject:notification];
		}
	}
}

@end
