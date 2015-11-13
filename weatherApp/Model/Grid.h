//
//  Grid.h
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/12/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import <Foundation/Foundation.h>


#define GRID_STEP 60.0
#define VERTICAL_OFFSET 20.0
#define HORIZONTAL_OFFSET 20.0
#define VERTICAL_SPACEING 10.0

@interface Grid : NSObject
+ (NSArray *)gridForRect:(CGRect)rect withZoomFactor:(CGFloat)zoom;
@end
