//
//  Volcano.m
//  EQNZ
//
//  Created by Tom Henderson on 9/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Volcano.h"


@implementation Volcano

@synthesize title, latitude, longitude, alertLevel, alertDescription;

- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D location;
	location.latitude = (CLLocationDegrees) [latitude floatValue];
	location.longitude = (CLLocationDegrees) [longitude floatValue];
	
	return location;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%i - %@",alertLevel, alertDescription];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@, %@ Alert: %i - %@", title, latitude, longitude, alertLevel, alertDescription];
}

- (void)dealloc
{
    [title release];
    [latitude release];
    [longitude release];
    [alertDescription release];
    [super dealloc];
}

@end
