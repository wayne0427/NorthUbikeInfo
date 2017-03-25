//
//  NewTaipeiMainMap.m
//  NorthUbikeInfo
//
//  Created by Wei on 2016/9/25.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "NewTaipeiMainMap.h"
#import "NewTaipeiUbikeTableViewTableViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NewTaipeiMainMap ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMapViewNTPC;

@end

@implementation NewTaipeiMainMap
{
    CLLocationManager *locationNTPC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationNTPC = [CLLocationManager new];
    [locationNTPC requestWhenInUseAuthorization];
    locationNTPC.desiredAccuracy = kCLLocationAccuracyBest;
    locationNTPC.activityType = CLActivityTypeAutomotiveNavigation;
    locationNTPC.delegate = self;
    [locationNTPC startUpdatingLocation];

}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray<CLLocation *> *)locations {
    
    CLLocation * currentLocation = locations.lastObject;
    static dispatch_once_t changeRegionToken = 0;
    dispatch_once(&changeRegionToken, ^{
        MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
        MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, span);
        
        [_mainMapViewNTPC setRegion:region animated:true];
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://data.ntpc.gov.tw/od/data/api/54DDDC93-589C-4858-9C95-18B2046CC1FC?$format=json"];
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
        NSString *jsonValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Json: %@",jsonValue);
        NSArray *finalJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _ubikeInfoNTPC = [NSMutableArray arrayWithArray:finalJson];
        
        CLLocationCoordinate2D annotationCoordinate;
        
        for (int i = 0; i<_ubikeInfoNTPC.count;i++) {
            NSDictionary *each = _ubikeInfoNTPC[i];
            annotationCoordinate.latitude = [each[@"lat"] doubleValue];
            annotationCoordinate.longitude = [each[@"lng"] doubleValue];
            MKPointAnnotation * annotation = [MKPointAnnotation new];
            annotation.coordinate = annotationCoordinate;
            annotation.title = [NSString stringWithFormat:@"站名:%@",each[@"sna"]];
            annotation.subtitle = [NSString stringWithFormat:@"總停車格:%@ 可借數量:%@ 空位數量:%@",each[@"tot"],each[@"sbi"],each[@"bemp"]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mainMapViewNTPC addAnnotation:annotation];
                });
            }
        }];
        [task resume];
    });
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NewTaipeiUbikeTableViewTableViewController *vc2 = segue.destinationViewController;
    vc2.containerNTPC = self.ubikeInfoNTPC;
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
