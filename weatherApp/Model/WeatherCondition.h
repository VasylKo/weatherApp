//
//  WeatherCondition.h
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/8/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherCondition : NSObject

@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *icon;

- (NSString *)imageName;

- (id)initWithDictionary:(NSDictionary *)dictionaryValue;
@end
