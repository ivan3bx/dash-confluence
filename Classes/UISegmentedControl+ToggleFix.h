//
//  UISegmentedControl+ToggleFix.h
//  Changes
//
//  Created by Ivan Moscoso on 5/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

/*
 * Fix required for < 3.0 to avoid 'toggle' behavior
 * when segmented control only has two segments
 */
@interface UISegmentedControl(ToggleControl)

@property(nonatomic, assign) BOOL toggleWhenTwoSegments;

@end
