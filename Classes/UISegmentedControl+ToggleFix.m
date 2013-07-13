//
//  UISegmentedControl+ToggleFix.m
//  Changes
//
//  Created by Ivan Moscoso on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UISegmentedControl+ToggleFix.h"


@implementation UISegmentedControl(ToggleControl)

@dynamic toggleWhenTwoSegments;

/*
 * Fix required for < 3.0 to avoid 'toggle' behavior
 * when segmented control only has two segments
 */
- (BOOL)toggleWhenTwoSegments {
    return (_segmentedControlFlags.dontAlwaysToggleForTwoSegments == 0);
}

- (void)setToggleWhenTwoSegments:(BOOL)flag {
    _segmentedControlFlags.dontAlwaysToggleForTwoSegments = (flag ? 0 : 1);
}

@end



