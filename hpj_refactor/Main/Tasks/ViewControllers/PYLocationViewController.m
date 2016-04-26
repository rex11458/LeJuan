//
//  PYLocationViewController.m
//  hpj_refactor
//
//  Created by LiuRex on 16/3/19.
//  Copyright © 2016年 Shanghai Youyou Finance Information Technology Co.,Ltd. All rights reserved.
//

#import "PYLocationViewController.h"
@interface PYLocationViewController ()<MKMapViewDelegate>
{

}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PYLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    @try {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = _coordinate;
        [self.mapView addAnnotation:annotation];
        [self.mapView setRegion:[self.mapView regionThatFits:MKCoordinateRegionMake(_coordinate, MKCoordinateSpanMake(.004, .004))] animated:NO];
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    
    [super viewWillAppear:animated];
}

#pragma mark - map view delegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView_ viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *pinView = nil;
        static NSString *defaultPinID = @"myAnnotation";
        pinView = (MKPinAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
            pinView.pinColor = MKPinAnnotationColorPurple;
            pinView.canShowCallout = YES;
        }
        
        return pinView;
    }
    return nil;
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
