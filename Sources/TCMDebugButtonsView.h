//
//  TCMDebugButtonsView.h
//  ZickeZacke
//
//  Created by Dominik Wagner on 07.07.13.
//  Copyright (c) 2013 TheCodingMonkeys. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
	Puropose: provide an easy to use mechanism to add grouped overlay buttons to views, to facilitate quick adding of debug functionality on demand
 */

@interface TCMDebugButtonsView : UIView

/** @param anEdge supports only CGRectMinYEdge and CGRectMaxYEdge
 */
- (id)initWithSuperview:(UIView *)aSuperview edge:(CGRectEdge)anEdge;

- (UIButton *)addDebugButtonWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anActionSelector;
- (UIButton *)addDebugButtonWithTitle:(NSString *)aTitle block:(dispatch_block_t)aBlock;
- (void)addDebugButtonGap;

- (IBAction)hide:(id)aSender;
- (IBAction)show:(id)aSender;

/** use e.g. 20.0 to show below the status bar if on top */
@property (nonatomic) CGFloat additionalInsetFromEdge;

@end

@interface UIView (TCMDebugButtonAdditions)
/** call this if you want the edge not to be bottom (CGRectMaxYEdge) */
- (TCMDebugButtonsView *)TCM_addDebugButtonsViewOnEdge:(CGRectEdge)anEdge;

/** gives you a debug buttons view, creates one if the view doesn't have one yet */
- (TCMDebugButtonsView *)TCM_debugButtonsView;

/** adding a debug button was never easier - debug button view is created if necessary */
- (UIButton *)TCM_addDebugButtonWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anActionSelector;
/** the block is executed on touch of button */
- (UIButton *)TCM_addDebugButtonWithTitle:(NSString *)aTitle block:(dispatch_block_t)aBlock;
- (void)TCM_addDebugButtonGap;
@end
