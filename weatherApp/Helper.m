//
//  Helper.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/12/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "Helper.h"
@import UIKit;

@implementation Helper

#pragma mark - Show alert
+ (void)showOKAlertWithTitle:(nullable NSString *)title andMessage:(nullable NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActin = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil];
    
    [alertController addAction:okActin];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
