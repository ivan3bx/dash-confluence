//
//  SpaceNavigationController.m
//  WikiBrowser
//
//  Created by Ivan Moscoso on 12/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SpaceNavigationController.h"
#import "CJSONDeserializer.h"
#import "WikiPage.h"
#import "WikiContent.h"
#import "WikiContentViewControl.h"
#import "LoadWikiSpace.h"

@implementation SpaceNavigationController

- (id) initWithContent: (WikiSpace *)input {
	return [self initWithSpace:input atPage:nil];
}

- (id) initWithSpace: (WikiSpace *)aSpace atPage: (WikiPage *)aPage {
	if (self =  [super initWithNibName:@"SpaceNavigationController" bundle:[NSBundle mainBundle]]) {
		space = [aSpace retain];
		currentPage = aPage;
	}
	return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSArray *operationCount = [change valueForKey:NSKeyValueChangeNewKey];
	if (0 == [operationCount count]) {
		currentPage = [space home];
		[self.tableView reloadData];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (currentPage == nil) {
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		[queue addObserver:self forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:[queue operations]];
		[queue addOperation: [[LoadWikiSpace alloc] initWithSpace:space andQueue:queue]];
	}
	WikiContentViewControl *contentControl = [[[WikiContentViewControl alloc] init] autorelease];
	[contentControl addTarget:self action:@selector(switchContentView:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = contentControl;
}

/*
 * Callback for WikiContentViewControl when the user changes
 * the perspective (i.e. from 'navigation' to 'view' or 'edit'
 */
- (void)switchContentView: (WikiContentViewControl *)action {
	UIView *superView = [self.view superview];
	WikiPage *page = (WikiPage *)currentPage;
	
	switch ([action selectedSegmentIndex]) {
		case 0:
			NSLog(@"Selected 'Browse'");
			[webView removeFromSuperview];
			[superView addSubview:[self tableView]];
			break;
		case 1:
			NSLog(@"Selected 'View'");
			[webView setBounds: super.tableView.bounds];
			[webView removeFromSuperview];
			[superView addSubview:webView];

			[webView loadRequest:[[[[ConfluenceAdapter alloc] init] autorelease] prepareRequestFor:page.contentHREF]];
			break;
		case 2:
			NSLog(@"Selected 'Edit'");
			break;
		default:
			break;
	}
	NSLog(@"Switching to content view for action [%@]", action );
}

- (void)viewWillAppear:(BOOL)animated {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self 
					  name:NSUserDefaultsDidChangeNotification 
					object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self 
			   selector:@selector(defaultsDidChange:) 
				   name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)defaultsDidChange:(NSNotification *)notification {
	[self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark Table view methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentPage.children count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		[cell setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0]];
    }
    
	WikiPage *childPage = [currentPage.children objectAtIndex:[indexPath row]];
	[cell setText: [childPage title]];
	if ([childPage hasChildren]) {
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	WikiPage *nextPage = [currentPage.children objectAtIndex: [indexPath row]];
	SpaceNavigationController *spaceNavController = [[SpaceNavigationController alloc] initWithSpace:space atPage:nextPage];
	[self.navigationController pushViewController:spaceNavController animated:YES];
	[spaceNavController release];
}

- (void)dealloc {
	[space release];
    [super dealloc];
}


@end

