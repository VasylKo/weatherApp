//
//  WeatherAPIClient.h
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/13/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherAPIClient : NSObject

- (void)fetchCurrentConditionsForLocation;

@end
