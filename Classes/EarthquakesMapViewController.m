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
	[tbi setTitle:@"Earthquake Map"];
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
	// -41.162114, 172.529297, 14.062500, 13.589921

	MKCoordinateRegion region;
	region.center.latitude = (CLLocationDegrees) -41.162114;
	region.center.longitude = (CLLocationDegrees) 173.529297;
	region.span.longitudeDelta = (CLLocationDegrees) 14.062500;
	region.span.latitudeDelta = (CLLocationDegrees) 13.589921;
	
	[mapView setRegion:region animated:YES];
	
	//NSLog(@"Setting map view");
	[earthquakeData setMapView:mapView];
    //[[earthquakeData mapView] setDelegate:earthquakeData];
    
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
