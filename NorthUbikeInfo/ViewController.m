//
//  ViewController.m
//  appFirst
//
//  Created by Wei on 2016/9/25.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "ViewController.h"
#import "TaipeiUbikeTableView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *MapViewTpUbike;



@end

@implementation ViewController
{
    CLLocationManager *locationManager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray<CLLocation *> *)locations {
    
    CLLocation * currentLocation = locations.lastObject;
    //_mapInfoOne = [NSMutableArray new];
    //[_mapInfoOne addObject:currentLocation];
    
    static dispatch_once_t changeRegionToken = 0;
    dispatch_once(&changeRegionToken, ^{
        MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
        MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, span);
        
        [_MapViewTpUbike setRegion:region animated:true];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://data.taipei/youbike"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^
                                  (NSData * _Nullable data,
                                   NSURLResponse * _Nullable response,
                                   NSError * _Nullable error)
    {
        if(error){
            NSLog(@"Error: %@",error.description);
            return;
        }
        //NSString *jsonValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Json: %@",jsonValue);
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *abc = json[@"retVal"];
        NSArray * finalJsonInfo = abc.allValues;
        _ubikeLocInfo = [NSMutableArray arrayWithArray:finalJsonInfo];
        //NSLog(@"test %@",_ubikeLocInfo);
        
        for (int i=0; i<_ubikeLocInfo.count; i++) {
            CLLocationCoordinate2D annotationCoordinate;
            
            NSDictionary *each = _ubikeLocInfo[i];
            annotationCoordinate.latitude = [each[@"lat"] doubleValue];
            annotationCoordinate.longitude = [each[@"lng"] doubleValue];
            
            MKPointAnnotation * annotation = [MKPointAnnotation new];
            annotation.coordinate = annotationCoordinate;
            annotation.title = [NSString stringWithFormat:@"站名:%@",each[@"sna"]];
            annotation.subtitle = [NSString stringWithFormat:@"總停車格:%@ 可借數量:%@ 空位數量:%@",each[@"tot"],each[@"sbi"],each[@"bemp"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_MapViewTpUbike addAnnotation:annotation];
            });
        }
    }];
    [task resume];
    });
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    TaipeiUbikeTableView * vc2 = segue.destinationViewController;
    vc2.taipeiTableContainer = self.ubikeLocInfo;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end





