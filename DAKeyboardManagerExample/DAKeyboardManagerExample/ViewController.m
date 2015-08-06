//
//  ViewController.m
//  DAKeyboardManagerExample
//
//  Created by David Levi on 10/2/13.
//  Copyright (c) 2013 Double Apps Inc. All rights reserved.
//

#import "ViewController.h"
#import "DAKeyboardManager.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		self.textView.font = [UIFont systemFontOfSize:48.0f];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[DAKeyboardManager sharedManager] registerViewController:self];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[[DAKeyboardManager sharedManager] deregisterViewController:self];
	[super viewWillDisappear:animated];
}


#pragma mark - DAKeyboardManager

- (void) keyboardManagerWillShow:(NSNotification*)notification
{
	self.bottomConstraint.constant = [DAKeyboardManager sharedManager].keyboardEndSize.height;
	[UIView animateWithDuration:0.3f animations:^() {
		[self.textView layoutIfNeeded];
	}];
}

- (void) keyboardManagerWillChange:(NSNotification*)notification
{
	self.bottomConstraint.constant = [DAKeyboardManager sharedManager].keyboardEndSize.height;
	[UIView animateWithDuration:0.3f animations:^() {
		[self.textView layoutIfNeeded];
	}];
}

- (void) keyboardManagerWillHide:(NSNotification*)notification
{
	self.bottomConstraint.constant = 0;
	[UIView animateWithDuration:0.3f animations:^() {
		[self.textView layoutIfNeeded];
	}];
}


#pragma mark - UITextViewDelegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}

@end
