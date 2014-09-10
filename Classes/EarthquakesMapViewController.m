//
//  EarthquakesMapViewController.m
//  EQNZ
//
//  Created by Tom Henderson on 4/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import "EarthquakesMapViewController.h"
#import "EQDataSource.h"
#import "Earthquake.h"

@implementation EarthquakesMapViewController

- (id)init 
{
	// Call the superclass's designated initializer:
	[super initWithNibName:@"MapViewController" bundle:nil];
	
	// Set up the tab bar item:
	UITabBarItem *tbi = [self tabBarItem];
	[tbi setTitle:@"Earthquakes"];
	UIImage *i = [UIImage imageNamed:@"103-map.png"];
	[tbi setImage:i];
	
	earthquakeData = [EQDataSource sharedEarthquakeData];
	
	return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Whole of new zealand:
	// Center (-41.820455, 172.254883), Span (15.055888, 14.062499)

	MKCoordinateRegion region;
	region.center.latitude = (CLLocationDegrees) -41.820455;
	region.center.longitude = (CLLocationDegrees) 172.254883;
	region.span.longitudeDelta = (CLLocationDegrees) 15.055888;
	region.span.latitudeDelta = (CLLocationDegrees) 14.062499;
	
	[mapView setRegion:region animated:YES];
    
	//NSLog(@"Setting map view");
	[earthquakeData setMapView:mapView];
    [mapView setDelegate:earthquakeData];
	
	[self loadAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self loadAnnotations];
}

- (void)loadAnnotations
{
	for (NSMutableArray *section in [earthquakeData earthquakes])
	{
		[mapView addAnnotations:section];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
