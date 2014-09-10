//
//  EQDataSource.h
//  EQNZ
//
//  Created by Tom Henderson on 3/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Earthquake;

@interface EQDataSource : NSObject <NSXMLParserDelegate, UITableViewDataSource, MKMapViewDelegate> {
	// Data Storage
	NSMutableArray *earthquakes;
	
	// NSURLConnection
	NSURLConnection *connectionInProgress;
	NSMutableData *xmlData;
	
	// NSXMLParser
	NSString *elementPath;
	NSMutableString *elementContent;	
	Earthquake *currentQuake;
	
	// References to views
	//FIXME: This is probably not the best way to do this.
	UITableView *tableView;
	MKMapView *mapView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) MKMapView *mapView;

+ (EQDataSource *)sharedEarthquakeData;
- (void)loadEarthquakeData;
- (NSArray *)earthquakes;

// UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
