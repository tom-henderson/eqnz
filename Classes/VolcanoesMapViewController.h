//
//  VolcanoesMapViewController.h
//  EQNZ
//
//  Created by Tom Henderson on 4/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class VolcanoDataSource;

@interface VolcanoesMapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	VolcanoDataSource *volcanoData;
}

- (void)loadAnnotations;

@end
