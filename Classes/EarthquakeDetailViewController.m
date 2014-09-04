//
//  EarthquakeDetailViewController.m
//  EQNZ
//
//  Created by Tom Henderson on 9/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import "EarthquakeDetailViewController.h"
#import "Earthquake.h"

@implementation EarthquakeDetailViewController


#pragma mark -
#pragma mark Initialization

- (id)init
{
	[super initWithStyle:UITableViewStyleGrouped];
	
	self.tableView.allowsSelection = NO;
	
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 5;
    }
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCellStyle cellStyle;
    NSString *cellIdentifier;
    
    if (indexPath.section == 1 & indexPath.row == 1) {
        cellStyle = UITableViewCellStyleDefault;
        cellIdentifier = @"UITableViewCellStyleValueDefault";
    } else {
        cellStyle = UITableViewCellStyleValue2;
        cellIdentifier = @"UITableViewCellStyleVaule2";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Date";
            cell.detailTextLabel.text = currentEarthquake.date;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Time";
            cell.detailTextLabel.text = currentEarthquake.time;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Magnitude";
            cell.detailTextLabel.text = currentEarthquake.magnitude;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Depth";
            cell.detailTextLabel.text = currentEarthquake.depth;
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = currentEarthquake.region;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0)) {
        return 44.0;
    } else {;
        CGSize textSize = [[currentEarthquake regionDetails] sizeWithFont:[UIFont systemFontOfSize:15] 
                                          constrainedToSize:CGSizeMake([tableView frame].size.width - 20, 500) 
                                              lineBreakMode:UILineBreakModeWordWrap];
        return textSize.height + 15;
    }
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

@synthesize currentEarthquake;

@end

