//
//  EditWikiViewController.m
//  Changes
//
//  Created by Ivan Moscoso on 5/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditWikiViewController.h"
#import "UserInfo.h"
#import "Constants.h"

#import "NSString+Extras.h"

@interface EditWikiViewController(Private)

-(void)stopActivityIndicator;
-(void)startActivityIndicator;

@end


@implementation EditWikiViewController

- (void)viewDidLoad {
	validator = [[WikiSiteValidator alloc] initWithDelegate:self];
	detailCells = [[NSArray arrayWithObjects:serverCell, accountCell, passwordCell, nil] retain];
	[self.navigationItem setTitle:@"Settings"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	// Reset text fields
	[textFields resetFields];

	[center addObserver:self
			   selector:@selector(keyboardWasShown:)
				   name:UIKeyboardDidShowNotification object:nil];
	
	[center addObserver:self
			   selector:@selector(keyboardWillBeHidden:)
				   name:UIKeyboardWillHideNotification object:nil];
	
	// Initialize number of articles to fetch
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	switch ([defaults integerForKey:WIKI_NUMBER_OF_ARTICLES]) {
		case 10:
			[selectSizeControl setSelectedSegmentIndex:0];
			break;
		case 20:
			[selectSizeControl setSelectedSegmentIndex:1];
			break;
		case 40:
			[selectSizeControl setSelectedSegmentIndex:2];
			break;
		default:
			break;
	}
	
}


- (void)viewWillDisappear:(BOOL)animated {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	keyboardIsShowing = NO;
}


- (IBAction)save:(UIBarButtonItem *)sender {
	if (!textFields.serverField.text) {
		NSDictionary *errorData = [NSDictionary dictionaryWithObject:@"Server is required" 
															  forKey:NSLocalizedDescriptionKey];
		
		[self didFailWithError:[NSError errorWithDomain:@"DASH" 
												   code:1 
											   userInfo:errorData]];
	} else {
		[self startActivityIndicator];
		[validator validate:[NSURL URLWithString:textFields.serverField.text] 
					   user:textFields.accountField.text
				   password:textFields.passwordField.text];
	}
}


- (IBAction)cancel:(id)sender {
	[validator cancel];
	[[self navigationController] dismissModalViewControllerAnimated:YES];
	[self performSelector:@selector(stopActivityIndicator) withObject:nil afterDelay:0.5];
}


- (IBAction)saveSizeOfFeed:(UISegmentedControl *)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	switch ([sender selectedSegmentIndex]) {
		case 0:
			[defaults setInteger:10 forKey:WIKI_NUMBER_OF_ARTICLES];
			break;
		case 1:
			[defaults setInteger:20 forKey:WIKI_NUMBER_OF_ARTICLES];
			break;
		case 2:
			[defaults setInteger:40 forKey:WIKI_NUMBER_OF_ARTICLES];
			break;
		default:
			break;
	}
}

-(void)stopActivityIndicator {
	[[self navigationItem] setRightBarButtonItem:saveButton animated:NO];
}

-(void)startActivityIndicator {
	[[self navigationItem] setRightBarButtonItem:saveProgressItem animated:NO];
}

- (void)dealloc {
	[selectSizeCell release];
	[textFields release];
	[detailCells release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView datasource & delegate methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0) ? 1 : [detailCells count];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	NSString *result;
	switch (section) {
		case 0:
			result = NSLocalizedString(@"Select how many articles to fetch.  Fewer articles will improve response time.", @"Preferences footer asking number of articles to fetch");
			break;
		case 1:
			result = NSLocalizedString(@"The identity you will use when connecting", @"Footer for entering account information");
			break;
		default:
			result = nil;
			break;
	}
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case 0:
			cell = selectSizeCell;
			break;
		case 1:
			cell = [detailCells objectAtIndex:[indexPath row]];
		default:
			break;
	}
	return cell;
}

#pragma mark -
#pragma mark Keyboard events
#pragma mark -

- (void)keyboardWasShown:(NSNotification *)notification {
	if (keyboardIsShowing) {
		return;
	}

    NSDictionary* info = [notification userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

	CGRect viewFrame = [self.tableView frame];
	viewFrame.size.height -= keyboardSize.height;
	self.tableView.frame = viewFrame;
	
	NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:1];
	[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];

	keyboardIsShowing = YES;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
	if (!textFields.activeField) {
		NSDictionary* info = [notification userInfo];
		NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
		CGSize keyboardSize = [aValue CGRectValue].size;
		CGRect viewFrame = [self.tableView frame];
		viewFrame.size.height += keyboardSize.height;
		
		// Animate resizing of frame to match hiding of keyboard
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		self.tableView.frame = viewFrame;
		[UIView commitAnimations];
		keyboardIsShowing = NO;
	}
}

#pragma mark -
#pragma mark WikiSiteValidatorDelegate methods
#pragma mark -

-(void)didPassWithURL:(NSURL *)url {
	[self performSelector:@selector(stopActivityIndicator) withObject:nil afterDelay:0.5];
	[textFields.serverField setText: [url absoluteString]];
	[textFields save];
	[self saveSizeOfFeed:selectSizeControl];

	[[self navigationController] dismissModalViewControllerAnimated:YES];
}


-(void)didFailWithError:(NSError *)error {
	[self stopActivityIndicator];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error"
													 message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
													delegate:nil 
										   cancelButtonTitle:@"Okay" 
										   otherButtonTitles:nil] autorelease];
	[alert show];
}

@end
