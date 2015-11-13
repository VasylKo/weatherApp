//
//  WeatherAPIClient.h
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/13/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeatherCondition;
@import CoreLocation;

@interface WeatherAPIClient : NSObject

- (void)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate completionHandler:(void (^)(WeatherCondition *weatherCondition, CLLocationCoordinate2D position, NSError *error))completionHandler;

@end
