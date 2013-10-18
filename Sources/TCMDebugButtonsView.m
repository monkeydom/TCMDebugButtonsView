//
//  TCMDebugButtonsView.m
//  ZickeZacke
//
//  Created by Dominik Wagner on 07.07.13.
//  Copyright (c) 2013 TheCodingMonkeys. All rights reserved.
//

#import "TCMDebugButtonsView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface TCMDebugButtonsView ()
@property (nonatomic) CGRectEdge edge;
@property (nonatomic, strong) NSMutableArray *elementsArray;
@property (nonatomic, strong) NSMutableArray *buttonBlocks;
@end

@implementation TCMDebugButtonsView

+ (CGRect)buttonBaseBounds {
	return CGRectMake(0, 0, 1024, 36);
}

+ (CGSize)buttonDistance {
	return CGSizeMake(4., 4.);
}

+ (CGSize)gapSize {
	return CGSizeMake(2., 10.);
}

- (void)setAdditionalInsetFromEdge:(CGFloat)additionalInsetFromEdge {
	if (!additionalInsetFromEdge == _additionalInsetFromEdge) {
		
	}
	_additionalInsetFromEdge = additionalInsetFromEdge;
	[self takeInset];
}

- (id)initWithSuperview:(UIView *)aSuperview edge:(CGRectEdge)anEdge {
	CGRect frame = aSuperview.bounds;
	frame.size.height = CGRectGetHeight([self.class buttonBaseBounds]) + [self.class buttonDistance].height * 2;
    self = [super initWithFrame:frame];
    if (self) {
		_elementsArray = [NSMutableArray new];
		_buttonBlocks = [NSMutableArray new];
		_edge = anEdge;
		self.layer.anchorPoint = CGPointMake(0.0,_edge == CGRectMaxYEdge ? 1.0 : 0.0);
		CGPoint position = frame.origin;
		if (_edge == CGRectMaxYEdge) position.y = CGRectGetMaxY(aSuperview.bounds);
		self.layer.position = position;
		frame.origin = CGPointZero;
		self.bounds = frame;
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
		if (anEdge == CGRectMaxYEdge) {
			self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		} else {
			self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		}
		[aSuperview addSubview:self];
		// needs a superview for orientation
		[self addDebugButtonWithTitle:@"Hide" target:self action:@selector(hide:)];
    }
    return self;
}

- (void)takeInset {
	self.transform = CGAffineTransformMakeTranslation(0, (self.edge == CGRectMinYEdge ? 1 : -1) * self.additionalInsetFromEdge);
}

- (void)layoutButtons {
	// workhorse layouter
	CGRect targetBounds = CGRectZero;
	CGSize buttonDistance = self.class.buttonDistance;
	BOOL isMaxYEdge = (self.edge == CGRectMaxYEdge);
	CGRect superBounds = self.superview.bounds;
	CGFloat maxX = CGRectGetMaxX(superBounds) - buttonDistance.width;
	CGFloat minX = CGRectGetMinX(superBounds) + buttonDistance.width;
	CGFloat yStep = CGRectGetHeight(self.class.buttonBaseBounds) + buttonDistance.height;
	if (isMaxYEdge) yStep = -yStep;
	CGPoint startPoint = CGPointMake(minX, isMaxYEdge ? CGRectGetMaxY(self.bounds) - buttonDistance.height : CGRectGetMinY(self.bounds) + buttonDistance.height);
	CGPoint position = startPoint;
	for (UIView *element in self.elementsArray) {
		if (!element.hidden) {
			element.layer.position = position;
			if (CGRectGetMaxX(element.frame) > maxX) {
				targetBounds.size.width = maxX + buttonDistance.width; // if we wrap we need the full width
				position.y += yStep;
				position.x = startPoint.x;
				element.layer.position = position;
			}
			position.x = CGRectGetMaxX(element.frame) + buttonDistance.width;
			targetBounds.size.width = MAX(targetBounds.size.width, position.x);
		}
	}
	targetBounds.size.height = ABS([self.elementsArray[0] layer].position.y -[self.elementsArray.lastObject layer].position.y) + ABS(yStep) + buttonDistance.height;
	self.bounds = targetBounds;
}

- (IBAction)hide:(id)aSender {
	[self.elementsArray enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
		if (idx>0) aView.hidden = YES;
	}];
	UIButton *hideShowButton = self.elementsArray[0];
	[hideShowButton setTitle:@"Show" forState:UIControlStateNormal];
	[hideShowButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
	[hideShowButton addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];

	[self layoutButtons];
	self.alpha = 0.1;
	[hideShowButton setAlpha:0.1];
}

- (IBAction)show:(id)aSender {
	[self.elementsArray enumerateObjectsUsingBlock:^(UIView *aView, NSUInteger idx, BOOL *stop) {
		if (idx>0) aView.hidden = NO;
	}];
	UIButton *hideShowButton = self.elementsArray[0];
	[hideShowButton setTitle:@"Hide" forState:UIControlStateNormal];
	[hideShowButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
	[hideShowButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
	
	[self layoutButtons];
	self.alpha = 1.0;
	[hideShowButton setAlpha:1.0];
}

- (UIButton *)buttonWithTitle:(NSString *)aTitle {
	CGRect buttonRect = [self.class buttonBaseBounds];
	UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
	[button setTitle:aTitle forState:UIControlStateNormal];
	button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
	button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:16.0];
	button.titleLabel.shadowColor = [UIColor blackColor];
	button.titleLabel.shadowOffset = CGSizeMake(0,2);
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	[button sizeToFit];
	buttonRect.size.width = CGRectGetWidth(button.frame) + 18.0;
	button.frame = buttonRect;
	
	[button setTitleColor:[UIColor colorWithWhite:0.8 alpha:0.0] forState:UIControlStateHighlighted];
	button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	
	// set anchor and autoresizing according to edge
	if (self.edge == CGRectMaxYEdge) {
		button.layer.anchorPoint = CGPointMake(0.0,1.0);
		button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
	} else {
		button.layer.anchorPoint = CGPointMake(0.0,0.0);
		button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
	}
	return button;
}

- (UIButton *)addDebugButtonWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anActionSelector {
	UIButton *result = [self buttonWithTitle:aTitle];
	[result addTarget:aTarget action:anActionSelector forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:result];
	[self.elementsArray addObject:result];
	[self layoutButtons];
	return result;
}

- (void)blockButtonAction:(UIButton *)aSender {
	NSUInteger index = aSender.tag;
	if (index < self.buttonBlocks.count) {
		dispatch_block_t block = self.buttonBlocks[index];
		if (block) {
			block();
		}
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self layoutButtons];
}

- (UIButton *)addDebugButtonWithTitle:(NSString *)aTitle block:(dispatch_block_t)aBlock {
	UIButton *result = [self buttonWithTitle:aTitle];
	if (aBlock) {
		[result addTarget:self action:@selector(blockButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		result.tag = self.buttonBlocks.count;
		[self.buttonBlocks addObject:aBlock];
	}
	[self addSubview:result];
	[self.elementsArray addObject:result];
	[self layoutButtons];
	return result;
}

- (void)addDebugButtonGap {
	CGRect frame = CGRectZero;
	frame.size = self.class.gapSize;
	UIView *gap = [[UIView alloc] initWithFrame:frame];
	[self.elementsArray addObject:gap];
	[self layoutButtons];
}

@end

static const void *DEBUG_VIEW_ASSOC_KEY;

@implementation UIView (TCMDebugButtonAdditions)
- (TCMDebugButtonsView *)TCM_debugButtonsViewInternal {
	TCMDebugButtonsView *result = objc_getAssociatedObject(self,DEBUG_VIEW_ASSOC_KEY);
	return result;
}
- (void)TCM_setDebugButtonsViewInternal:(TCMDebugButtonsView *)aDebugButtonsView {
	objc_setAssociatedObject(self, DEBUG_VIEW_ASSOC_KEY, aDebugButtonsView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TCMDebugButtonsView *)TCM_addDebugButtonsViewOnEdge:(CGRectEdge)anEdge {
	TCMDebugButtonsView *result = self.TCM_debugButtonsViewInternal;
	if (!result) {
		result = [[TCMDebugButtonsView alloc] initWithSuperview:self edge:anEdge];
		[self TCM_setDebugButtonsViewInternal:result];
	}
	return result;
}

/** gives you a debug buttons view, creates one if the view doesn't have one yet */
- (TCMDebugButtonsView *)TCM_debugButtonsView {
	TCMDebugButtonsView *result = [self TCM_debugButtonsViewInternal];
	if (!result) {
		result = [self TCM_addDebugButtonsViewOnEdge:CGRectMaxYEdge];
	}
	return result;
}

- (UIButton *)TCM_addDebugButtonWithTitle:(NSString *)aTitle target:(id)aTarget action:(SEL)anActionSelector {
	UIButton *button = [self.TCM_debugButtonsView addDebugButtonWithTitle:aTitle target:aTarget action:anActionSelector];
	return button;
}

- (UIButton *)TCM_addDebugButtonWithTitle:(NSString *)aTitle block:(dispatch_block_t)aBlock {
	UIButton *button = [self.TCM_debugButtonsView addDebugButtonWithTitle:aTitle block:aBlock];
	return button;
}

- (void)TCM_addDebugButtonGap {
	[self.TCM_debugButtonsView addDebugButtonGap];
}

@end
