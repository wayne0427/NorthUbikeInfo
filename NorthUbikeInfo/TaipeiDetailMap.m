//
//  TaipeiDetailMap.m
//  NorthUbikeInfo
//
//  Created by Wei on 2016/9/25.
//  Copyright © 2016年 Wei. All rights reserved.
//

#import "TaipeiDetailMap.h"
#import "TaipeiUbikeTableView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TaipeiDetailMap ()
@property (weak, nonatomic) IBOutlet MKMapView *taipeiDetailMapView;

@end

@implementation TaipeiDetailMap


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _taipeiDetailMapContainer = [NSMutableArray new];
    
//    for (int j=0; j<_taipeiDetailMapContainer.count; j++) {
        CLLocationCoordinate2D annotationCoordinate;
        
        //NSDictionary *loop = _info;
        
        MKPointAnnotation * annotation = [MKPointAnnotation new];
    
    annotationCoordinate.latitude = [_info[@"lat"] floatValue];
    annotationCoordinate.longitude = [_info[@"lng"] floatValue];
    
    
        annotation.coordinate = annotationCoordinate;
        annotation.title = [NSString stringWithFormat:@"站名:%@",_info[@"sna"]];
        annotation.subtitle = [NSString stringWithFormat:@"總停車格:%@ 可借數量:%@ 空位數量:%@",_info[@"tot"],_info[@"sbi"],_info[@"bemp"]];

            [_taipeiDetailMapView addAnnotation:annotation];
    
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        MKCoordinateRegion region = MKCoordinateRegionMake(annotationCoordinate, span);
        [_taipeiDetailMapView setRegion:region animated:true];
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
