//
//  EQDataSource.m
//  EQNZ
//
//  Created by Tom Henderson on 3/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import "EQDataSource.h"
#import "Earthquake.h"

static EQDataSource *sharedEarthquakeData;

@implementation EQDataSource

#pragma mark -
#pragma mark Singleton Methods & Initialization

+ (EQDataSource *)sharedEarthquakeData
{
	if (!sharedEarthquakeData) {
		//NSLog(@"Creating the shared data source.");
		sharedEarthquakeData = [[EQDataSource alloc] init];
	}
	return sharedEarthquakeData;
}

+ (id)allocWithZone:(NSZone *)zone
{
	if (!sharedEarthquakeData) {
		sharedEarthquakeData = [super allocWithZone:zone];
		return sharedEarthquakeData;
	} else {
		return nil;
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (oneway void)release
{
	// Do nothing.
}

- (id)init
{
	[super init];
	
	earthquakes = [[NSMutableArray alloc] init];
	[self loadEarthquakeData];
	
	return self;
}

- (void)loadEarthquakeData
{	
	NSURL *url = [NSURL URLWithString:@"http://www.geonet.org.nz/quakes/services/felt.rss"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReloadIgnoringCacheData 
										 timeoutInterval:30];
	
	if (connectionInProgress) {
		[connectionInProgress cancel];
		[connectionInProgress release];
	}
	
	[xmlData release];
	xmlData = [[NSMutableData alloc] init];
	
	connectionInProgress = [[NSURLConnection alloc] initWithRequest:request 
														   delegate:self 
												   startImmediately:YES];
}

- (NSArray *)earthquakes
{
	return earthquakes;
}

//TODO: Encode/Decode

#pragma mark -
#pragma mark NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// We are just testing:
	//NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", xmlCheck);
	
	[earthquakes removeAllObjects];
	if (tableView) {
		[tableView reloadData];
	}
	if (mapView) {
		// Remove all the annotations from the map
		NSArray *annotations = [mapView annotations];
		[mapView removeAnnotations:annotations];
	}	
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate:self];
	[parser parse]; // BLOCKING
	[parser release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connectionInProgress release]; connectionInProgress = nil;
	[xmlData release]; xmlData = nil;
	
	NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
	
	NSLog(@"Error getting data: %@", errorString);
}

#pragma mark -
#pragma mark NSXMLParser Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	elementPath = [[NSString alloc] init];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	// Add this element to the path:
	elementPath = [elementPath stringByAppendingPathComponent:elementName];
	
	if ([elementPath isEqual:@"rss/channel/item"]) {
		currentQuake = [[Earthquake alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
	if (!elementContent)
		elementContent = [[NSMutableString alloc] init];
	
	[elementContent appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{	
	NSString *trimmedString = [elementContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//NSLog(@"%@", elementPath);
	
	/* 
	Earthquake Fields:
	------------------
	NSString	*title;
	NSURL		*URL;
	NSString	*description;
	NSString	*latitude;
	NSString	*longitude;
	NSDate		*dateTime;
	NSString	*magnitude; 
	 */
	
	
	if ([elementPath isEqualToString:@"rss/channel/item/title"]) {
		
        // Title looks like:
        // Magnitude 2.3, Friday, September 20 2013 at 12:34:34 pm (NZST), 10 km east of Seddon
        // Magnitude 2.4, Sunday, September 29 2013 at 1:35:50 pm (NZDT), 5 km south-east of Seddon
        
		NSArray *titleElements = [trimmedString componentsSeparatedByString:@", "];
        //NSLog(@"%@", trimmedString);
		
		
		// Magnitude (0)
		[currentQuake setMagnitude:[[[titleElements objectAtIndex:0] componentsSeparatedByString:@" "] objectAtIndex:1]];
		
		
		// Date & Time (2)
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMMM d yyyy 'at' h:mm:ss a"]; //September 28 2010 at 1:56 am
        //NSLog(@"%@", dateFormatter.dateFormat);
        //NSLog(@"%@", [[titleElements objectAtIndex:2] substringToIndex:[[titleElements objectAtIndex:2] length] - 7]);
		[currentQuake setDateTime:[dateFormatter dateFromString:[[titleElements objectAtIndex:2] substringToIndex:[[titleElements objectAtIndex:2] length] - 7]]];
        //NSLog(@"%@", currentQuake.dateTime);
		[dateFormatter release]; dateFormatter = nil;

		NSDate *now = [[NSDate alloc] init];
		NSCalendar *cal = [NSCalendar currentCalendar];
		unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
		NSDateComponents *conversionInfo = [cal components:unitFlags fromDate:[currentQuake dateTime]  toDate:now options:0];
        
        
		//NSLog(@"Conversion: %dmin %dhours %ddays %dmonths",
		//	[conversionInfo minute], [conversionInfo hour], [conversionInfo day], [conversionInfo month]);
		
		if ([conversionInfo month] == 0) {
			if ([conversionInfo day] == 0) {
				if ([conversionInfo hour] == 0) {
					[currentQuake setDaysAgo:[NSString stringWithFormat:@"%d minutes ago", [conversionInfo minute]]];
				} else {
					[currentQuake setDaysAgo:[NSString stringWithFormat:@"%d hours ago", [conversionInfo hour]]];
				}
			} else {
				[currentQuake setDaysAgo:[NSString stringWithFormat:@"%d days ago", [conversionInfo day]]];
			}
		} else {
			[currentQuake setDaysAgo:[NSString stringWithFormat:@"%d months ago", [conversionInfo month]]];
		}

		
		[now release]; now = nil;
		
		
	} else if ([elementPath isEqualToString:@"rss/channel/item/link"]) {
		[currentQuake setURL:[NSURL URLWithString:trimmedString]];
		
	} else if ([elementPath isEqualToString:@"rss/channel/item/content:encoded"]) {
		[currentQuake setDetails:trimmedString];
        //NSLog(@"%@", trimmedString);
		
	} else if ([elementPath isEqualToString:@"rss/channel/item/geo:lat"]) {
		[currentQuake setLatitude:trimmedString];
		
	} else if ([elementPath isEqualToString:@"rss/channel/item/geo:long"]) {
		[currentQuake setLongitude:trimmedString];		
	} else if ([elementPath isEqualToString:@"rss/channel/item"]) {
		// Get the last array added to the array
		
		NSMutableArray *currentSubArray = [earthquakes lastObject];
		
		if (!currentSubArray) {
			// There is no current sub-array: create it
			currentSubArray = [NSMutableArray array];
			// Add the most recent EQ to the new sub-array:
			[currentSubArray addObject:currentQuake];
			// Add the new sub-array to the earthquakes array:
			[earthquakes addObject:currentSubArray];
		} else {
			Earthquake *lastEarthquake = [currentSubArray lastObject];
			if (!lastEarthquake) {
				// There is no earthquake in the sub-array
				// This shouldn't happen.
				NSLog(@"Somehow there is an empty sub-array in the earthquakes data array");
			} else {
				if ([[lastEarthquake date] isEqualToString:[currentQuake date]]) {
					// The date time is the same, add to this sub-array
					[currentSubArray addObject:currentQuake];
				} else {
					// The date time is not the same, create a new sub-array
					NSMutableArray *newSubArray = [NSMutableArray array];
					// Add the new earthquake:
					[newSubArray addObject:currentQuake];
					// Add the new sub-array to the earthquakes array:
					[earthquakes addObject:newSubArray];
				}

			}

		}
		
		[currentQuake release]; currentQuake = nil;
		if (tableView) {
			[tableView reloadData];
		}
	}
	
	// Remove the last path component and continue:
	elementPath = [elementPath stringByDeletingLastPathComponent];
	
	// Get rid of the content data:
	[elementContent release]; elementContent = nil;
}


#pragma mark -
#pragma mark TableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [earthquakes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([earthquakes count] < 1)
		return 0;
	
    return [[earthquakes objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([earthquakes count] < 1)
		return @"No data";
	
	NSMutableArray *thisSection = [earthquakes objectAtIndex:section];
	Earthquake *thisQuake = [thisSection lastObject];
	return [NSString stringWithFormat:@"%@ (%d)", [thisQuake date], [thisSection count]];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Earthquake *thisQuake = [[earthquakes objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:kCFDateFormatterNoStyle];
	[dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    [[cell textLabel] setText:[dateFormatter stringFromDate:[thisQuake dateTime]]];
	[dateFormatter release];
	
	[[cell detailTextLabel] setText:[NSString stringWithFormat:@"Magnitude %@", [thisQuake magnitude]]];
	
    return cell;
}

#pragma mark -
#pragma mark MKMapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *annotationIdentifier = @"normalRedPin";
    
    if ([annotation isKindOfClass:[Earthquake class]]) {
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pin) {
            pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
        }
        
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        
        return pin;   
    }
    
    return nil;
}

@synthesize tableView, mapView;

@end
