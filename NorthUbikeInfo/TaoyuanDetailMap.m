//
//  TaoyuanDetailMap.m
//  NorthUbikeInfo
//
//  Created by Wei on 2016/9/26.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "TaoyuanDetailMap.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TaoyuanDetailMap ()
@property (weak, nonatomic) IBOutlet MKMapView *mapViewTaoyuan;

@end

@implementation TaoyuanDetailMap

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D annotationCoordinate;
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotationCoordinate.latitude = [_infoTaoy[@"lat"] floatValue];
    annotationCoordinate.longitude = [_infoTaoy[@"lng"] floatValue];
    
    annotation.coordinate = annotationCoordinate;
    annotation.title = [NSString stringWithFormat:@"站名:%@",_infoTaoy[@"sna"]];
    annotation.subtitle = [NSString stringWithFormat:@"總停車格:%@ 可借數量:%@ 空位數量:%@",_infoTaoy[@"tot"],_infoTaoy[@"sbi"],_infoTaoy[@"bemp"]];
    
    [_mapViewTaoyuan addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(annotationCoordinate, span);
    [_mapViewTaoyuan setRegion:region animated:true];
    
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
