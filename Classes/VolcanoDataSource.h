//
//  VolcanoDataSource.h
//  EQNZ
//
//  Created by Tom Henderson on 9/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Volcano;

@interface VolcanoDataSource : NSObject <NSXMLParserDelegate, MKMapViewDelegate> {
	// Data Storage
	NSMutableArray *volcanoes;
	
	// NSURLConnection
	NSURLConnection *connectionInProgress;
	NSMutableData *xmlData;
	
	// NSXMLParser
	NSString *elementPath;
	NSMutableString *elementContent;	
	Volcano *currentVolcano;
}

+ (VolcanoDataSource *)sharedVolcanoData;
- (void)loadVolcanoData;
- (NSArray *)volcanoes;

@end
