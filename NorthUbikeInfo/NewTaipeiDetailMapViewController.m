//
//  NewTaipeiDetailMapViewController.m
//  NorthUbikeInfo
//
//  Created by Wei on 2016/9/26.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "NewTaipeiDetailMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NewTaipeiDetailMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *detailMapViewNTPC;

@end

@implementation NewTaipeiDetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D annotationCoordinate;
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotationCoordinate.latitude = [_infoNTPC[@"lat"] floatValue];
    annotationCoordinate.longitude = [_infoNTPC[@"lng"] floatValue];
    
    annotation.coordinate = annotationCoordinate;
    annotation.title = [NSString stringWithFormat:@"站名:%@",_infoNTPC[@"sna"]];
    annotation.subtitle = [NSString stringWithFormat:@"總停車格:%@ 可借數量:%@ 空位數量:%@",_infoNTPC[@"tot"],_infoNTPC[@"sbi"],_infoNTPC[@"bemp"]];
    
    [_detailMapViewNTPC addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(annotationCoordinate, span);
    [_detailMapViewNTPC setRegion:region animated:true];
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
