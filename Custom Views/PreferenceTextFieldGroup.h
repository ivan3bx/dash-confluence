//
//  PreferenceFieldDelegate.h
//  Riseer
//
//  Created by Ivan Moscoso on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface PreferenceTextFieldGroup : NSObject<UITextFieldDelegate> {
	IBOutlet UITextField *descriptionField;
	IBOutlet UITextField *serverField;
	IBOutlet UITextField *accountField;
	IBOutlet UITextField *passwordField;
	
	UITextField *activeField;
}

/*
 * Reset all fields to their default (saved) values
 */
- (void)resetFields;

/*
 * Persists the value of all fields
 */
- (void)save;


/*
 * Field which is currently being edited, or nil if no such field
 */
@property(readonly) UITextField *activeField;

@property(readonly) UITextField *descriptionField;
@property(readonly) UITextField *serverField;
@property(readonly) UITextField *accountField;
@property(readonly) UITextField *passwordField;

@end
