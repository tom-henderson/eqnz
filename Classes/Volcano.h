//
//  Volcano.h
//  EQNZ
//
//  Created by Tom Henderson on 9/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Volcano : NSObject <MKAnnotation> {
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, assign) int alertLevel;
@property (nonatomic, copy) NSString *alertDescription;

@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@end
