//
//  EarthquakesTableViewController.h
//  EQNZ
//
//  Created by Tom Henderson on 3/10/10.
//  Copyright 2010 Tom Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EQDataSource;

@interface EarthquakesTableViewController : UITableViewController {
	EQDataSource *earthquakeData;
}

@end
