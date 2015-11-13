//
//  Grid.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/12/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

@import UIKit;
#import "Grid.h"



@implementation Grid

+ (NSArray *)gridForRect:(CGRect)rect withZoomFactor:(CGFloat)zoom {
    //If zoom is hight show only one wheather pin
    if (zoom > 10) {
        return @[[NSValue valueWithCGRect:rect]];
    }
    

    CGFloat width = rect.size.width;
    CGFloat heigth = rect.size.height;
    
    //Calcilate grid step based on map zoom
    CGFloat gridStep = MIN(ceilf(GRID_STEP  + 10 * zoom), 140);
    
    NSMutableArray *array = [NSMutableArray new];
    
    int rows = heigth / gridStep;
    int colums = width / gridStep;
    
    //Pretify grid look for current device orientation and zoom level
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        if (zoom > 8.0) {
            colums -= 2;
        } else if (zoom > 7.0) {
            colums -= 1;
        }
        
    } else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        if (zoom > 8.0) {
            rows -= 2;
        } else if (zoom > 7.0) {
            rows -= 1;
        }
    }
    
    //Cetner grids in rect
    CGFloat deltaX =  ceilf((width - colums * gridStep) / (colums + 1));
    CGFloat deltaY = ceilf((heigth - rows * gridStep) / (rows + 1));
    
    for (int y = 0; y < rows; y++) {
        //Calculate initil Y position
        int initY = deltaY + deltaY * y;
        for (int x = 0; x < colums; x++) {
            //Calculate initil X position
            int initX = deltaX + deltaX * x;
            
            //Calculate recr for each element in grid
            CGFloat xPos = initX + gridStep * x;
            CGFloat yPos = initY + gridStep * y;
            
            CGRect rect = CGRectMake(xPos, yPos, gridStep, gridStep);
            [array addObject:[NSValue valueWithCGRect:rect]];
        }
        
    }

    return [array copy];
}

@end
