# TCMDebugButtonView - easily add debug buttons to your iOS app

## Purpose
* speed up the process of providing a user reachable button for features during development
* let it hide itself if it isn't needed so it doesn't interfere with screenshots
* give incentive to add debug facilities to your apps by making adding a rudimentary UI to reach them cheap


## Requirements
* iOS 5.x or later
* ARC

## Example Usage
To use it you just add ``TCMDebugButtonsView.h`` and ``TCMDebugButtonsView.m`` to your project.

Add ``#import TCMDebugButtonsView.h"`` to either your precompiled header, or in every file you want to use it.

Use either ``-[UIView TCM_addDebugButtonWithTitle:(NSString *)aTitle block:(void (^)(void)aBlock)]``

or ``-[UIView TCM_addDebugButtonWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anAction]``

to add named buttons to a view.


```
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// the first call to TCM_addDebugButton… creates the debug button view implicitly
	
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
```
```
	// want the debug view to be on the top
	[self.view TCM_addDebugButtonsViewOnEdge:CGRectMinYEdge];

	// add debug button to change dismiss
	// remember to only use weak references, to not cause implicit retains with blocks
	__weak __typeof__(self) self_weak = self;
	[self.view TCM_addDebugButtonWithTitle:@"Dismiss"  block:^{
		[self_weak dismissViewControllerAnimated:YES
									  completion:NULL];
	}];
```

## How it looks like
![Example Debug Button View](http://f.cl.ly/items/2R3b3r0M1W0O1h0N3p1Z/DebugButtonView.jpg)

## Releases
### 1.0.1
* fixed missing initialization for associated object key - thanks to jou for pointing that out
* fixed mixed spaces/tabs whitespace

### 1.0 
* initial release

## License

* [MIT](http://www.opensource.org/licenses/mit-license.php)

## Created by
@monkeydom [twitter](http://twitter.com/monkeydom) [adn](http://alpha.app.net/monkeydom)
of [TheCodingMonkeys](http://codingmonkeys.de)