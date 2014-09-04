//
//  Earthquake.h
//  EQNZ
//
//  Created by Tom Henderson on 3/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Earthquake : NSObject <MKAnnotation> {

}

@property (nonatomic, copy) NSString *daysAgo;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSDate *dateTime;
@property (nonatomic, copy) NSString *magnitude;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) NSString *time;
@property (nonatomic, readonly) NSString *depth;
@property (nonatomic, readonly) NSString *region;
@property (nonatomic, readonly) NSString *regionDetails;

@end
