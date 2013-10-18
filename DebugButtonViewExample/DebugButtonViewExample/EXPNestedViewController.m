//
//  EXPNestedViewController.m
//  DebugButtonViewExample
//
//  Created by Dominik Wagner on 18.10.13.
//  Copyright (c) 2013 TheCodingMonkeys. All rights reserved.
//

#import "EXPNestedViewController.h"

@interface EXPNestedViewController ()

@end

@implementation EXPNestedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIColor *)initialBackgroundColor {
	CGFloat whiteLevel = 1.0;
	UIViewController *vc = self.presentingViewController;
	while (vc) {
		whiteLevel *= 0.9;
		vc = vc.presentingViewController;
	}
	return [UIColor colorWithWhite:whiteLevel alpha:1.0];
}

- (void)viewDidLoad
{
	self.view.backgroundColor = [self initialBackgroundColor];
	// want the debug view to be on the top
	[self.view TCM_addDebugButtonsViewOnEdge:CGRectMinYEdge];
	
	// add inset to compensate for status bar
	self.view.TCM_debugButtonsView.additionalInsetFromEdge = 20.0;
	
	// add debug button to change dismiss
	// remember to only use weak references, to not cause implicid retains with blocks
	__weak __typeof__(self) self_weak = self;
	[self.view TCM_addDebugButtonWithTitle:@"Dismiss"  block:^{
		[self_weak dismissViewControllerAnimated:YES
									  completion:NULL];
	}];
	
	
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
