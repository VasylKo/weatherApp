//
//  ViewController.m
//  weatherApp
//
//  Created by Vasyl Kotsiuba on 11/8/15.
//  Copyright © 2015 Vasyl Koysiuba. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;
#import "Grid.h"
#import "Helper.h"
#import "WeatherAPIClient.h"
#import "WeatherCondition.h"

@interface MapViewController () <GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) UIView *gridView; //for visula debug
@property (nonatomic, strong) WeatherAPIClient *weatheClient;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherTempLabel;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.weatheClient = [[WeatherAPIClient alloc] init];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate at zoom level 6.
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
   
    //For visual debug
    [self.gridView removeFromSuperview];
    self.gridView = nil;
    
    //Create grid
    NSArray *rectArray = [Grid gridForRect:self.view.bounds withZoomFactor:position.zoom];
 
    for (NSValue *rectVal in rectArray) {
        CGRect rect = [rectVal CGRectValue];
        //NSLog(@"%@", NSStringFromCGRect(rect));
        [self createMarkerForRect:rect];
        
        if (SHOW_GRID_VIEWS_FOR_VISUAL_DEBUG) {
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.alpha = 0.5;
            
            UIColor *color;
            if ([rectArray indexOfObject:rectVal] % 2 == 0) {
                color = [UIColor blueColor];
            } else {
                color = [UIColor greenColor];
            }
            
            view.backgroundColor = color;
            view.userInteractionEnabled = NO;
            
            [self.gridView addSubview:view];
        }
        
    }
    
    [self.view addSubview:self.gridView];

}

- (void)createMarkerForRect:(CGRect)rect {
    
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    center.y += 30; // to center weather pin view in grid rect. Weather pin view size is (60,60)
    
    //Conver point on view to coordinates on map
    CLLocationCoordinate2D position = [self.mapView.projection coordinateForPoint:center];
    
    [self.weatheClient fetchCurrentConditionsForLocation:position completionHandler:^(WeatherCondition *weatherCondition, CLLocationCoordinate2D position, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = position;
                marker.title = weatherCondition.locationName;
                marker.icon = [self weatheIcon:weatherCondition.imageName withTemp:weatherCondition.temperature];
                marker.map = self.mapView;
            } else {
                NSLog(@"ERROR! %@", [error localizedDescription]);
            }
        });
        
        
    }];
    
    
    
}

- (UIView *)gridView {
    if (!_gridView) {
        _gridView = [[UIView alloc] initWithFrame:self.view.bounds];
        _gridView.userInteractionEnabled = NO;
    }
    
    return _gridView;
}

- (UIImage *)weatheIcon:(NSString *)imageName withTemp:(NSString *)temp {
     UIView *weatherView =  [[[NSBundle mainBundle] loadNibNamed:@"weatherPinView" owner:self options:nil] objectAtIndex:0];
    self.weatherImageView.image = [UIImage imageNamed:imageName];
    self.weatherTempLabel.text = [NSString stringWithFormat:@"%@°", temp];
    
    [weatherView layoutIfNeeded];
    
    weatherView.layer.cornerRadius = 5.0;
    
    UIGraphicsBeginImageContext(weatherView.bounds.size);
    [weatherView drawViewHierarchyInRect:weatherView.bounds afterScreenUpdates:YES];
    //[weatherView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)orientationChanged:(NSNotification *)aNotification {
    //Update camera to trigger map view delegate and update grid
    [self.mapView moveCamera:[GMSCameraUpdate zoomBy:0.001]];
}

//Disable camera move to tapped marker
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    mapView.selectedMarker = marker;
    return YES;
}

- (void)mapView:(GMSMapView *)mapView
didChangeCameraPosition:(GMSCameraPosition *)position {
    [mapView clear];
    NSArray *rectArray = [Grid gridForRect:self.view.bounds withZoomFactor:position.zoom];
    for (NSValue *rectVal in rectArray) {
        CGRect rect = [rectVal CGRectValue];
        //NSLog(@"%@", NSStringFromCGRect(rect));
        [self createPinMarkerForRect:rect];
    }
    
}

- (void)createPinMarkerForRect:(CGRect)rect {
    
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    center.y += 30; // to center weather pin view in grid rect. Weather pin view size is (60,60)
    
    //Conver point on view to coordinates on map
    CLLocationCoordinate2D position = [self.mapView.projection coordinateForPoint:center];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = position;

    marker.map = self.mapView;
    
}


@end
