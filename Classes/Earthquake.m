//
//  Earthquake.m
//  EQNZ
//
//  Created by Tom Henderson on 3/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import "Earthquake.h"


@implementation Earthquake

@synthesize daysAgo, URL, details, latitude, longitude, dateTime, magnitude;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Lat %f, Long %f", self.coordinate.latitude, self.coordinate.longitude];
}

- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D location;
	location.latitude = (CLLocationDegrees) [latitude floatValue];
	location.longitude = (CLLocationDegrees) [longitude floatValue];
	
	return location;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@, %@ deep", magnitude, self.depth];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%@ at %@", self.date, self.time];
}

- (NSString *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSString *result = [dateFormatter stringFromDate:self.dateTime];
	[dateFormatter release];
	
	return result;
}

- (NSString *)time
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *result = [dateFormatter stringFromDate:self.dateTime];
	[dateFormatter release];

	return result;
}

- (NSString *)depth
{
	NSRange range = [self.details rangeOfString:@"Focal Depth</b></td><td>"];
	NSString *trimmedString = [self.details substringFromIndex:(range.location + range.length)];
	range = [trimmedString rangeOfString:@" km"];
	trimmedString = [trimmedString substringToIndex:(range.location + range.length)];
	return trimmedString;
}

- (NSString *)region
{
	NSRange range = [self.details rangeOfString:@"Location</b></td><td>"];
	NSString *trimmedString = [self.details substringFromIndex:(range.location + range.length)];
	range = [trimmedString rangeOfString:@"</td>"];
	trimmedString = [trimmedString substringToIndex:(range.location)];		
	return trimmedString;
	
}

- (NSString *)regionDetails
{
    return @"";
    NSRange range = [self.details rangeOfString:@"Location"];
    NSString *trimmedString = [self.details substringFromIndex:(range.location + range.length)];
    range = [trimmedString rangeOfString:@". "];
    trimmedString = [trimmedString substringFromIndex:(range.location + range.length)];
    return trimmedString;
}

//TODO: Encode/Decode

- (void)dealloc
{
	[daysAgo release];
	[URL release];
	[details release];
	[latitude release];
	[longitude release];
	[dateTime release];
	[magnitude release];
	[super dealloc];
}

@end
