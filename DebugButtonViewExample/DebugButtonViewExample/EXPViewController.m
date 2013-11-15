//
//  EXPViewController.m
//  DebugButtonViewExample
//
//  Created by Dominik Wagner on 18.10.13.
//  Copyright (c) 2013 TheCodingMonkeys. All rights reserved.
//

#import "EXPViewController.h"
#import "EXPNestedViewController.h"

@interface EXPViewController ()

@end

@implementation EXPViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// the first call to TCM_addDebugButton… creates the debug button view implicidly
	
	// example one: add debug button to change the background color using blocks
	// remember to only use weak references, to not cause implicit retains with blocks
	__weak __typeof__(self) self_weak = self;
	[self.view TCM_addDebugButtonWithTitle:@"Red Background"  block:^{
		self_weak.view.backgroundColor = [UIColor redColor];
	}];
	
	// example two: add debug button to change the background back to white using target/action
	[self.view TCM_addDebugButtonWithTitle:@"White Background" target:self action:@selector(whiteBackgroundAction)];
	
	
	// example three: add debug button do present a view controller
	[self.view TCM_addDebugButtonWithTitle:@"Present View Controller"  block:^{
		[self_weak presentViewController:[[EXPNestedViewController alloc] init] animated:YES completion:NULL];
	}];
	
}

- (void)whiteBackgroundAction {
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
