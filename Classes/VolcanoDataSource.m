//
//  VolcanoDataSource.m
//  EQNZ
//
//  Created by Tom Henderson on 9/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VolcanoDataSource.h"
#import "Volcano.h"

static VolcanoDataSource *sharedVolcanoData;

@implementation VolcanoDataSource

#pragma mark -
#pragma mark Singleton Methods & Initialization

+ (VolcanoDataSource *)sharedVolcanoData
{
    if (!sharedVolcanoData) {
        sharedVolcanoData = [[VolcanoDataSource alloc] init];
    }
    return sharedVolcanoData;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (!sharedVolcanoData) {
        sharedVolcanoData = [super allocWithZone:zone];
        return sharedVolcanoData;
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
    // Do nothing
}

- (id)init
{
    [super init];
    
    volcanoes = [[NSMutableArray alloc] init];
    [self loadVolcanoData];
    
    return self;
}

- (void)loadVolcanoData
{
    NSURL *url = [NSURL URLWithString:@"http://www.geonet.org.nz/volcano/services/volcanic-alert.rss"];
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

- (NSArray *)volcanoes
{
    return volcanoes;
}

#pragma mark -
#pragma mark NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Check Data:
    //NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", xmlCheck);
    //[xmlCheck release];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    [parser parse]; // Blocking
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
    elementPath = [elementPath stringByAppendingPathComponent:elementName];
    
    if ([elementPath isEqual:@"rss/channel/item"]) {
        currentVolcano = [[Volcano alloc] init];
        // NSLog(@"New volcano found");
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!elementContent) {
        elementContent = [[NSMutableString alloc] init];
    }
    
    [elementContent appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
    /*
     Volcano Fields
     --------------
     NSString *title;
     NSString *latitude;
     NSString *longitude;
     int alertLevel;
     NSString *alertDescription;
     */
    
    NSString *trimmedString = [elementContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([elementPath isEqualToString:@"rss/channel/item/title"]) {
        // Title looks like:
        // Soandso is at alert level x
        
        NSRange range = [trimmedString rangeOfString:@" is at"];
        trimmedString = [trimmedString substringToIndex:range.location];
        
        [currentVolcano setTitle:trimmedString];
        
    } else if ([elementPath isEqualToString:@"rss/channel/item/geo:lat"]) {
        [currentVolcano setLatitude:trimmedString];
        
    } else if ([elementPath isEqualToString:@"rss/channel/item/geo:long"]) {
        [currentVolcano setLongitude:trimmedString];
        
    } else if ([elementPath isEqualToString:@"rss/channel/item/geoval:alert/geoval:alert-level/geoval:level"]) {
        int alertLevel = [[trimmedString substringFromIndex:11] intValue];
        [currentVolcano setAlertLevel:alertLevel];
        
    } else if ([elementPath isEqualToString:@"rss/channel/item/geoval:alert/geoval:alert-level/geoval:description"]) {
        [currentVolcano setAlertDescription:trimmedString];
        
    } else if ([elementPath isEqualToString:@"rss/channel/item"]) {
        [volcanoes addObject:currentVolcano];
        // NSLog(@"%@", currentVolcano);
        [currentVolcano release]; currentVolcano = nil;
    }
    
    elementPath = [elementPath stringByDeletingLastPathComponent];
    [elementContent release]; elementContent = nil;
}

#pragma mark -
#pragma mark MKMapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *annotationIdentifier = @"normalRedPin";
    
    if ([annotation isKindOfClass:[Volcano class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView) {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
        }
        
        Volcano *volcano = annotation;
        
        if ([volcano alertLevel] == 0) {
            [annotationView setPinColor:MKPinAnnotationColorGreen];
        } else {
            [annotationView setPinColor:MKPinAnnotationColorRed];
        }
        
        [annotationView setAnimatesDrop:YES];
        [annotationView setCanShowCallout:YES];
        
        return annotationView;   
    }
    
    return nil;
}

/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Center (%f, %f), Span (%f, %f)", mapView.region.center.latitude, mapView.region.center.longitude, mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}
*/

@end