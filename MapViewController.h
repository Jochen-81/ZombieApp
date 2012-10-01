//
//  MapViewController.h
//  ZombieEscape
//
//  Created by HTWdS User on 22.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GameOrganizer.h"
#import "NetWorkCom.h"


@interface MapViewController :  UIViewController <MKMapViewDelegate,MKAnnotation>{
}

@property (strong, nonatomic) IBOutlet UILabel *healthLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

-(void)drawGamers:(NSMutableArray*)PlayerLocation;
-(void)removeAnnotationOfPlayer:(NSString*)gamerName;
-(void)changetoFightView;
-(void)centerMapOnLocation:(CLLocation *)location;

@end
