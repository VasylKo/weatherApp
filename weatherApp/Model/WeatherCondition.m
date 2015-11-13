//
//  WeatherCondition.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/8/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "WeatherCondition.h"

@interface WeatherCondition ()
@property(nonatomic, strong) NSArray *conditions;
@end

@implementation WeatherCondition  

+ (NSDictionary *)imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

- (NSString *)imageName {
    return [WeatherCondition imageMap][self.icon];
}

- (id)initWithDictionary:(NSDictionary *)dictionaryValue {
    self = [super init];
    
    if (self != nil) {
        //Parse weather dictionary
        NSDictionary *dic = dictionaryValue[@"sys"];
        NSString *country = dic[@"country"];
        NSString *placeName = dictionaryValue[@"name"];
        
        _locationName = [NSString stringWithFormat:@"%@, (%@)", placeName, country];
        
        dic = dictionaryValue[@"main"];
        NSNumber *tempNum = dic[@"temp"];
        double temp = [tempNum doubleValue];
        _temperature = [NSString stringWithFormat:@"%.2f", temp];
        
        dic = [dictionaryValue[@"weather"] firstObject];
        _icon = dic[@"icon"];
        
    }
    
    return self;
}



@end
