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
#import "AudioPlayer.h"




@implementation MapViewController


@synthesize mapView =_mapView;
GameOrganizer* gameOrg;



//////////////////////////////// Draw Annotation Methods //////////////////////

-(void)removeAnnotationOfPlayer:(NSString*)gamerName{
    for (PlayerLocation* annotation in _mapView.annotations){
        if ([annotation.name isEqualToString:gamerName])
            annotation.decomission = YES;
    }
    [self performSelectorOnMainThread:@selector(deletePin:) withObject:gamerName waitUntilDone:NO];
}

-(void)drawGamers:(NSMutableArray*)locations{
    for(PlayerLocation* loc in locations ){
        [ self replacePin:loc.name status:loc.gamerStatus withLocation:loc.coordinate];
    }
}

-(void)replacePin:(NSString *)gamerName  status:(int)status withLocation:(CLLocationCoordinate2D)location {
    // flag Location for deletion later
    for (PlayerLocation* annotation in _mapView.annotations){
        if ([annotation.name isEqualToString:gamerName])
            annotation.decomission = YES;
    }
    //add new Location
    PlayerLocation *pLoc = nil;
    pLoc = [[PlayerLocation alloc] initWithName:gamerName status: status coordinate:location];
    [_mapView addAnnotation:pLoc];
    [_mapView selectAnnotation:pLoc animated:true];
    [_mapView selectedAnnotations];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapV viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView* annotationView = nil;
    if ([annotation isKindOfClass:[PlayerLocation class]]){
       PlayerLocation* annotation2 = (PlayerLocation*)annotation;
        static NSString *identifier = @"MyView";   
        annotationView = (MKAnnotationView *) [mapV dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        UIImage * im;
        if(annotation2.gamerStatus==1){
            im = [UIImage imageNamed:@"Z.png"];
        }else {
            im = [UIImage imageNamed:@"H.png"];
        }
        annotationView.image = im;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        //delete the flagged Locations
        [self performSelectorOnMainThread:@selector(deletePin:) withObject:annotation2.name waitUntilDone:NO];
    }
    
    return annotationView;
}

-(void)deletePin:(NSString *)stationCode{
    for (PlayerLocation *annotation in _mapView.annotations) {
        if ([annotation.name isEqualToString:stationCode]){  
            if (annotation.decomission==YES)
            [_mapView removeAnnotation:annotation];
        }
    }
}

////////////////////////////////////////// Map Region Methods //////////////////////


-(void)defineRegion{
    MKCoordinateRegion region;
    region.center.latitude = 49.23700;
    region.center.longitude = 6.98000;
    region.span.latitudeDelta =0.005;
    region.span.longitudeDelta =0.005;
    [_mapView setRegion:region animated:NO];
}

///////////////////////////// View Load & Unload Methodes ///////////////////////////

- (void)viewDidUnload{
    NSLog(@"View Did Unload");
    [self setMapView:nil];
    [super viewDidUnload];    
}

- (void)viewWillDisappear:(BOOL)animated{
    if(!gameOrg.inFight){
        [gameOrg gamerLeavesGame];
    }
    [gameOrg stopSendingMyLocation];
    [super viewWillDisappear:animated];
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad{
    _mapView.mapType = MKMapTypeSatellite; //MKMapTypeStandard;
    [self defineRegion];
    _mapView.delegate=self;
    gameOrg = [GameOrganizer getGameOrganizer];
    [gameOrg startWithDelegate:self];
    [gameOrg startSendingMyLocation];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v3.png"]];
   // [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[AudioPlayer getAudioPlayer] pausePlaying];

}

/////////////////////////////////// Misc /////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return NO;
}

-(void) changetoFightView{
    [gameOrg setdelegateMapView:nil];
    [gameOrg stopSendingMyLocation];
    [self performSegueWithIdentifier: @"segMapViewToFightView" sender: self];
    
}


@end
