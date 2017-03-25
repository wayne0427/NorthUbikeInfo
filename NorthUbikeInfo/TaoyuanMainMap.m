//
//  TaoyuanMainMap.m
//  NorthUbikeInfo
//
//  Created by Wei on 2016/9/26.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "TaoyuanMainMap.h"
#import "TaoyuanUbikeTableView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TaoyuanMainMap ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mainMapTaoyuan;

@end

@implementation TaoyuanMainMap
{
    CLLocationManager *locationTaoyuan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationTaoyuan = [CLLocationManager new];
    [locationTaoyuan requestWhenInUseAuthorization];
    locationTaoyuan.desiredAccuracy = kCLLocationAccuracyBest;
    locationTaoyuan.activityType = CLActivityTypeAutomotiveNavigation;
    locationTaoyuan.delegate = self;
    [locationTaoyuan startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray<CLLocation *> *)locations {
    
    CLLocation * currentLocation = locations.lastObject;
    
    static dispatch_once_t changeRegionToken = 0;
    dispatch_once(&changeRegionToken, ^{
        MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
        MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, span);
        
        [_mainMapTaoyuan setRegion:region animated:true];
    
    
    NSString *urlString=[NSString stringWithFormat:@"http://data.tycg.gov.tw/opendata/datalist/datasetMeta/download?id=5ca2bfc7-9ace-4719-88ae-4034b9a5a55c&rid=a1b4714b-3b75-4ff8-a8f2-cc377e4eaa0f"];
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
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *abc = json[@"retVal"];
        NSArray * finalJson = abc.allValues;
        _ubikeInfoTaoy = [NSMutableArray arrayWithArray:finalJson];
        
        CLLocationCoordinate2D annotationCoordinate;
        for (int i = 0; i<_ubikeInfoTaoy.count;i++) {
            
            NSDictionary *each = _ubikeInfoTaoy[i];
            
            annotationCoordinate.latitude = [each[@"lat"] doubleValue];
            
            annotationCoordinate.longitude = [each[@"lng"] doubleValue];
            
            MKPointAnnotation * annotation = [MKPointAnnotation new];
            annotation.coordinate = annotationCoordinate;
            annotation.title = [NSString stringWithFormat:@"站名:%@",each[@"sna"]];
            annotation.subtitle = [NSString stringWithFormat:@"總停車格:%@ 可借數量:%@ 空位數量:%@",each[@"tot"],each[@"sbi"],each[@"bemp"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mainMapTaoyuan addAnnotation:annotation];
            });
        }
    }];
    [task resume];
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    TaoyuanUbikeTableView *vc2 = segue.destinationViewController;
    vc2.containerTaoy = self.ubikeInfoTaoy;
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
