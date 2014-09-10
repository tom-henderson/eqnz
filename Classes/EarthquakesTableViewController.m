//
//  EarthquakesTableViewController.m
//  EQNZ
//
//  Created by Tom Henderson on 3/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import "EarthquakesTableViewController.h"
#import "EarthquakeDetailViewController.h"
#import "EQDataSource.h"
#import "Earthquake.h"

@implementation EarthquakesTableViewController


#pragma mark -
#pragma mark Initialization

- (id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set up nav bar
	[[self navigationItem] setTitle:@"Recent Earthquakes"];
    
	UIBarButtonItem *reload = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:earthquakeData action:@selector(loadEarthquakeData)] autorelease];
	self.navigationItem.rightBarButtonItem = reload;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	earthquakeData = [EQDataSource sharedEarthquakeData];
    
	[[self tableView] setDataSource:earthquakeData];
	[earthquakeData setTableView:[self tableView]];

}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	EarthquakeDetailViewController *detailViewController = [[EarthquakeDetailViewController alloc] init];

	[detailViewController setCurrentEarthquake:[[[earthquakeData earthquakes] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];

	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

