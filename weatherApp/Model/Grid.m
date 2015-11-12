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
    CGFloat width = rect.size.width - HORIZONTAL_OFFSET * 2;
    CGFloat heigth = rect.size.height - VERTICAL_OFFSET * 2;
    
    
    //If zoom hight show only one wheather pin
    if (zoom > 10) {
        return @[[NSValue valueWithCGRect:rect]];
    }
    
    //Calcilate grid step based on map zoom
    CGFloat gridStep = MIN(ceilf(GRID_STEP  + 10 * zoom), 140);
    
    NSMutableArray *array = [NSMutableArray new];
    
    int rows = heigth / gridStep;
    int colums = width / gridStep;
    
    //Cetner grids in recr
    CGFloat deltaX =  ceilf((width - colums * gridStep) / (colums - 1));
    int deltaY = ceilf((heigth - rows * gridStep) / (rows - 1));
    
    for (int y = 0; y < rows; y++) {
        //Calculate initil Y position
        int initY = deltaY * y + VERTICAL_OFFSET;
        for (int x = 0; x < colums; x++) {
            //Calculate initil X position
            int initX = deltaX * x + HORIZONTAL_OFFSET;
            
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
