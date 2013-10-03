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
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void) adjustViewForAvailableSize:(CGSize)availableSize
{
	[UIView animateWithDuration:0.3f animations:^() {
		CGRect rect = self.textView.frame;
		rect.size.height = availableSize.height;
		self.textView.frame = rect;
	}];
}

- (void) keyboardWillShow:(NSNotification*)notification
{
	[self adjustViewForAvailableSize:[[DAKeyboardManager sharedManager] availableSize:self.view.bounds]];
}

- (void) keyboardWillHide:(NSNotification*)notification
{
	[self adjustViewForAvailableSize:self.view.bounds.size];
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
