//
//  MapViewController.m
//  ZombieEscape
//
//  Created by HTWdS User on 22.09.12.
//  Copyright (c) 2012 HTW Saarland. All rights reserved.
//
#import "MapViewController.h"
#import "SocketMessage.h"
#import "GPSLocation.h"
#import "PlayerLocation.h"
#import "NetWorkCom.h"




@implementation MapViewController


@synthesize mapView =_mapView;
@synthesize locationLabel= _locationLabel;
GameOrganizer* gameOrg;
int zoomlvl;



-(void)drawGamers:(NSMutableArray*)locations{
    
    for(PlayerLocation* loc in locations ){
        [ self replacePin:loc.name withLocation:loc.coordinate];
    }

}

-(void)replacePin:(NSString *)gamerName  withLocation:(CLLocationCoordinate2D)location {
    //Find and "decommission" the old pin... (basically flags it for deletion later)
    for (PlayerLocation* annotation in _mapView.annotations) 
    {
            if ([annotation.name isEqualToString:gamerName])
                annotation.decomission = YES;
    }
    
    //add the new pin...
    PlayerLocation *stationPin = nil;
    stationPin = [[PlayerLocation alloc] initWithName:gamerName address:nil coordinate:location];
    [_mapView addAnnotation:stationPin];
}


- (void)viewDidLoad{
    NSLog(@"View Did Load");
    _mapView.mapType = MKMapTypeStandard;
   // _MapView.showsUserLocation = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    // locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation]; 
    [self defineRegion];
    //[self drawPlayer];
    _mapView.delegate=self;
    gameOrg = [GameOrganizer getGameOrganizer];
    [gameOrg startWithDelegate:self];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSLog(@"View WIll Appear");
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    self.locationLabel.text = newLocation.description;
    [gameOrg updateMyLocation:newLocation];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* annotationView = nil;
    
    if ([annotation isKindOfClass:[PlayerLocation class]])
    {
       PlayerLocation* annotation2 = (PlayerLocation*)annotation;
        
        static NSString *identifier = @"MyView";   
            
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        //delete any decommissioned pins...
        [self performSelectorOnMainThread:@selector(deletePin:) withObject:annotation2.name waitUntilDone:NO];
    }
    return annotationView;
    
}

-(void)deletePin:(NSString *)stationCode
{
    for (PlayerLocation *annotation in _mapView.annotations) 
    {
        if ([annotation.name isEqualToString:stationCode])
        {  
            if (annotation.decomission==YES)
            [_mapView removeAnnotation:annotation];
        }
    }
}



-(void)defineRegion{
    MKCoordinateRegion region;
    region.center.latitude = 49.23700;
    region.center.longitude = 6.98000;
    region.span.latitudeDelta =0.005;
    region.span.longitudeDelta =0.005;
    
    [_mapView setRegion:region animated:NO];
}


- (void)viewDidUnload
{
    NSLog(@"View Did Unload");
    [self setMapView:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [gameOrg gamerLeavesGame];
    [super viewWillDisappear:animated];
}

- (void)mapView:(MKMapView *)MapView regionDidChangeAnimated:(BOOL)animated {

}

- (void)mapView:(MKMapView *)MapView regionWillChangeAnimated:(BOOL)animated {

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


@end
