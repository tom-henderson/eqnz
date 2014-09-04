//
//  EarthquakeDetailViewController.h
//  EQNZ
//
//  Created by Tom Henderson on 9/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Earthquake;

@interface EarthquakeDetailViewController : UITableViewController {
	Earthquake *currentEarthquake;
}

@property (nonatomic, assign) Earthquake *currentEarthquake;

@end
