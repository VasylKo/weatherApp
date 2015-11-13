//
//  WeatherAPIClient.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/13/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "WeatherAPIClient.h"
@import CoreLocation;
#import "Helper.h"

@interface WeatherAPIClient ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation WeatherAPIClient

- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

//- (void)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate
- (void)fetchCurrentConditionsForLocation {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(50.46012686633918, 30.52173614501953);
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric&APPID=%@",coordinate.latitude, coordinate.longitude, OPEN_WEATHER_MAP_API_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (!jsonError) {
            
            NSLog(@"%@", json);
        }
        else {
            // 2
            NSLog(@"ERROR! %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

@end
