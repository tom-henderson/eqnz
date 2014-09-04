//
//  EarthquakesMapViewController.h
//  EQNZ
//
//  Created by Tom Henderson on 4/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class EQDataSource;

@interface EarthquakesMapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	EQDataSource *earthquakeData;
}

- (void)loadAnnotations;

@end
