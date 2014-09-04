//
//  VolcanoesMapViewController.m
//  EQNZ
//
//  Created by Tom Henderson on 9/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VolcanoesMapViewController.h"
#import "VolcanoDataSource.h"
#import "Volcano.h"

@implementation VolcanoesMapViewController

- (id)init 
{
	// Call the superclass's designated initializer:
	[super initWithNibName:@"MapViewController" bundle:nil];
	
	// Set up the tab bar item:
	UITabBarItem *tbi = [self tabBarItem];
	[tbi setTitle:@"Volcanoes"];
	UIImage *i = [UIImage imageNamed:@"73-radar.png"];
	[tbi setImage:i];
	
	volcanoData = [VolcanoDataSource sharedVolcanoData];
	
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
	//-41.162114, 172.529297, 14.062500, 13.589921
    
	MKCoordinateRegion region;
	region.center.latitude = (CLLocationDegrees) -41.162114;
	region.center.longitude = (CLLocationDegrees) 173.529297;
	region.span.longitudeDelta = (CLLocationDegrees) 14.062500;
	region.span.latitudeDelta = (CLLocationDegrees) 13.589921;
	
	[mapView setRegion:region animated:YES];

    [mapView setDelegate:volcanoData];
    
	[self loadAnnotations];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[self loadAnnotations];
}

- (void)loadAnnotations
{
    [mapView addAnnotations:[volcanoData volcanoes]];
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