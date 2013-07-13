//
//  PreferenceFieldDelegate.m
//  Riseer
//
//  Created by Ivan Moscoso on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferenceTextFieldGroup.h"
#import "Constants.h"
#import "UserInfo.h"
#import "NSString+Extras.h"

@implementation PreferenceTextFieldGroup
@synthesize descriptionField, serverField, accountField, passwordField, activeField;

- (void)resetFields {
	for (UITextField *item in [NSArray arrayWithObjects:descriptionField, accountField, serverField, passwordField, nil]) {
		item.clearButtonMode = UITextFieldViewModeWhileEditing;
	}

	serverField.placeholder = @"this field is required";
	accountField.placeholder = @"tap to enter";
	passwordField.placeholder = @"tap to enter";
	
	UserInfo *userInfo = [UserInfo current];
	
	descriptionField.text = userInfo.siteName;
	serverField.text = userInfo.base;
	accountField.text = userInfo.username;
	passwordField.text = userInfo.password;
	
	for (UITextField *item in [NSArray arrayWithObjects:descriptionField, accountField, serverField, passwordField, nil]) {
		[self textFieldShouldEndEditing:item];
	}
}

- (void)dealloc {
	[serverField release];
	[accountField release];
	[passwordField release];
	[super dealloc];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == serverField && (textField.text == nil || [textField.text isBlank])) {
		textField.text = @"http://";
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	activeField = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (textField != passwordField) {
		textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	}

	if (![@"" isEqualToString:textField.text]) {
		textField.font = [UIFont boldSystemFontOfSize:12];
	} else {
		textField.font = [UIFont systemFontOfSize:12];
	}
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == descriptionField) {
		[serverField becomeFirstResponder];
	} else if (textField == serverField) {
		[accountField becomeFirstResponder];
	} else if (textField == accountField) {
		[passwordField becomeFirstResponder];
	} else {
		activeField = nil;
		[passwordField resignFirstResponder];
	}
	return YES;
}

- (void)save {
	UserInfo *entry = [[UserInfo alloc] init];
	entry.siteName  = [descriptionField.text length] > 0 ? descriptionField.text : nil;
	entry.username  = [accountField.text length] > 0 ? accountField.text : nil;
	entry.password  = [passwordField.text length] > 0 ? passwordField.text : nil;
	entry.base      = [serverField.text length] > 0 ? serverField.text : nil;

	[entry save];
	
	[entry release];
}

@end
