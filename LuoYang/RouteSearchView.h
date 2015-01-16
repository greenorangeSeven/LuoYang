//
//  RouteSearchView.h
//  NewWorld
//
//  Created by Seven on 14-7-20.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RouteSearchView : UIViewController<BMKMapViewDelegate, BMKRouteSearchDelegate>
{
    IBOutlet BMKMapView* _mapView;
    BMKRouteSearch* _routesearch;
    MBProgressHUD *hud;
}

@property (strong, nonatomic) NSString *storeTitle;
@property CLLocationCoordinate2D startCoor;
@property CLLocationCoordinate2D endCoor;

@end
