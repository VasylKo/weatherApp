//
//  ViewController.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/8/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "ViewController.h"
@import GoogleMaps;
#import "Grid.h"

@interface ViewController () <GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) UIView *gridView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:50.46012686633918
                                                            longitude:30.52173614501953
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self.mapView setDelegate:self];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;
    
    //Listen for device did change orientation
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMS Map View Delegate
-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    NSLog(@"__________CAMERA STOP________");
    NSLog(@"Camera zoom level = %f", position.zoom);
    
    [self.mapView clear];
   
    
    [self.gridView removeFromSuperview];
    self.gridView = nil;
    
    NSArray *rectArray = [Grid gridForRect:self.view.bounds withZoomFactor:position.zoom];
    int count = 0;
    for (NSValue *rectVal in rectArray) {
        CGRect rect = [rectVal CGRectValue];
        //NSLog(@"%@", NSStringFromCGRect(rect));
        [self createMarkerForRect:rect];
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.alpha = 0.5;
        
        UIColor *color;
        if (count % 2 == 0) {
            color = [UIColor blueColor];
        } else {
            color = [UIColor greenColor];
        }
        
        view.backgroundColor = color;
        count++;
        view.userInteractionEnabled = NO;
        
        [self.gridView addSubview:view];
    }
    
    [self.view addSubview:self.gridView];

}

- (void)createMarkerForRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CLLocationCoordinate2D position = [self.mapView.projection coordinateForPoint:center];
    
    // Creates a marker in the center of the map.
     GMSMarker *marker = [[GMSMarker alloc] init];
     marker.position = position;
     marker.title = @"Sydney";
     marker.snippet = @"Australia";
     marker.map = self.mapView;
    
}

- (UIView *)gridView {
    if (!_gridView) {
        _gridView = [[UIView alloc] initWithFrame:self.view.bounds];
        _gridView.userInteractionEnabled = NO;
    }
    
    return _gridView;
}

- (void)orientationChanged:(NSNotification *)aNotification {
    //Update camera to trigger map view delegate and update grid
    [self.mapView moveCamera:[GMSCameraUpdate zoomBy:0.001]];
}



@end
