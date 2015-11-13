//
//  WeatherAPIClient.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/13/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "WeatherAPIClient.h"
#import "Helper.h"
#import "WeatherCondition.h"

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

- (void)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate completionHandler:(void (^)(WeatherCondition *weatherCondition, CLLocationCoordinate2D position, NSError *error))completionHandler {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric&APPID=%@",coordinate.latitude, coordinate.longitude, OPEN_WEATHER_MAP_API_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSError *jsonError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (!jsonError) {
                WeatherCondition *weatherConditions =[[WeatherCondition alloc] initWithDictionary:json];
                completionHandler(weatherConditions, coordinate, nil);
            } else {
                completionHandler(nil, coordinate, error);
            }
        } else {
                // 2
                NSLog(@"ERROR! %@", [error localizedDescription]);
                
            }
    }];
    
    [dataTask resume];
}

@end
