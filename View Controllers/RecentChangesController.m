//
//  RecentChangesController.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 1/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RecentChangesController.h"
#import "WikiWebViewController.h"
#import "RecentChange.h"
#import "UISegmentedControl+ToggleFix.h"
#import "UserInfo.h"

#import "CXMLDocument.h"
#import "CXMLNode_XPathExtensions.h"

@interface RecentChangesController(Private)
- (void)startDisplayNetworkActivity;
- (void)stopDisplayNetworkActivity;
@end

@implementation RecentChangesController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Initialize UISegmentedControl
	[sortByControl setToggleWhenTwoSegments:NO];
	
	changesByDate = [[RecentChangesByDate alloc] initWithRecentChanges:[NSArray array]];
	changesByAuthor = [[RecentChangesByAuthor alloc] initWithRecentChanges:[NSArray array]];
	currentlySelectedChanges = changesByDate;
	
	rssFeed = [[RSSFeedBuilder alloc] init];
	confluence = [[ConfluenceAdapter alloc] init];
}


- (IBAction)reload {
	
	UserInfo *userInfo = [UserInfo current];
	if (!userInfo) {
		// UserInfo still not set
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server not set"
														message:@"Enter server information in Settings before beginning." 
													   delegate:nil 
											  cancelButtonTitle:@"Okay"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	
	if ([activityView isAnimating]) {
		return;
	} 

	[self startDisplayNetworkActivity];
	
	// Don't cache any responses or cookies
	[confluence setCachePolicy:NSURLRequestReloadIgnoringCacheData];

	[confluence fetchDataFor:[rssFeed buildFeed]
				   target:self 
				 selector:@selector(loadRSSData:)];
}


- (void)loadRSSData: (NSString *)input {
	NSError *error = nil;
	CXMLDocument *document = [[[CXMLDocument alloc] initWithXMLString:input options:0 error:&error] autorelease];

	[self stopDisplayNetworkActivity];
	
	if (error) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
														message:@"Unable to connect to Confluence.  Check server settings." 
													   delegate:nil 
											  cancelButtonTitle:@"Okay" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		NSLog(@"Error parsing [%@] / %@", [UserInfo current].base, error);
	} else {
		NSArray *allChanges = [NSArray arrayWithArray:[RecentChange parseRecentChanges: document]];
		if (changesByDate) {
			[changesByDate autorelease];
		}
		changesByDate = [[RecentChangesByDate alloc] initWithRecentChanges:allChanges];
		
		if (changesByAuthor) {
			[changesByAuthor autorelease];
		}
		changesByAuthor = [[RecentChangesByAuthor alloc] initWithRecentChanges:allChanges];

		[self sortResults:sortByControl];
		[self.tableView reloadData];
	}
}


- (void)startDisplayNetworkActivity {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityView startAnimating];
}


- (void)stopDisplayNetworkActivity {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[changesByDate release];
	[changesByAuthor release];
	[rssFeed release];
	[confluence release];
    [super dealloc];
}


#pragma mark -
#pragma mark UISegmentedControl methods
#pragma mark -

- (IBAction)sortResults:(UISegmentedControl *)sender {
	
	switch ([sender selectedSegmentIndex]) {
		case 0:
			currentlySelectedChanges = changesByDate;
			break;
		case 1:
			currentlySelectedChanges = changesByAuthor;
			break;
		default:
			break;
	}
	
	[self.tableView reloadData];
}



#pragma mark -
#pragma mark UITableView datasource & delegate methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [currentlySelectedChanges numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [currentlySelectedChanges nameForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentlySelectedChanges numberOfChangesInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:12.0];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	RecentChange *item = [currentlySelectedChanges itemInSection:[indexPath section] row:[indexPath row]];
	cell.textLabel.text = item.title;
	
	if ([sortByControl selectedSegmentIndex] == 0) {
		// Sorting view by Date
		cell.detailTextLabel.text = item.author;
	} else {
		// Sorting view by Author
		cell.detailTextLabel.text = [item publishDateAsString];
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath	animated:YES];
	RecentChange *item = [currentlySelectedChanges itemInSection:[indexPath section] row:[indexPath row]];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"showContent" object:item]];
}

@end

