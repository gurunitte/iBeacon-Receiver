//
//  ViewController.m
//  iBeacon
//
//  Created by raviranjan on 01/07/14.
//  Copyright (c) 2014 NK. All rights reserved.
//

#import "ViewController.h"

static NSString * uuid = @"8CF62DF5-A317-4A90-B90D-2829D1D5985B";
static NSString * testId = @"com.test.beaconTest";
static CLBeaconMajorValue majorID = 1;
static CLBeaconMinorValue minorIDPayment = 1;
static CLBeaconMinorValue minorIDOffer = 2;
static CLBeaconMinorValue previousMinorID = 0;
@interface ViewController ()

    // transmitter properties
@property CLBeaconRegion * beaconRegion;
@property CBPeripheralManager * peripheralManager;
@property NSMutableDictionary * peripheralData;

    // receiver properties
@property CLLocationManager * locationManager;
@property CLProximity previousProximity;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
        // Regardless of whether the device is a transmitter or receiver, we need a beacon region.
    NSUUID * uid = [[NSUUID alloc] initWithUUIDString:uuid];
    // for receiver
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uid
                                                                major:majorID
                                                           identifier:testId];
        // When set to YES, the location manager sends beacon notifications when the user turns on
        // the display and the device is already inside the region.
    [self.beaconRegion setNotifyEntryStateOnDisplay:YES];
    [self.beaconRegion setNotifyOnEntry:YES];
    [self.beaconRegion setNotifyOnExit:YES];
   
    [self configureReceiver];
}



-(void)configureReceiver {
        // Location manager.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



    // CLLocationManager delegate methods
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
        // See if we've entered the region.
    if ([region.identifier isEqualToString:testId]) {
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Welcome. You have entered beacon region.";
        notification.soundName = @"arrr.caf";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
        // See if we've exited a treasure region.
    if ([region.identifier isEqualToString:testId]) {
        UILocalNotification * notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Bye Bye.";
        notification.soundName = @"arrr.caf";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }  
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] == 0)
        return;
    
    NSString * message;
    UIColor * bgColor;
    //CLBeacon * beacon = [beacons firstObject];
    for (CLBeacon *beacon in beacons){
        NSNumber *majorValue = beacon.major;
        NSNumber *minorValue = beacon.minor;
        
        NSLog(@" Beacon major ID: %d", [majorValue intValue]);
        NSLog(@" Beacon minor ID: %d", [minorValue intValue]);
        
        if (beacon.proximity==CLProximityNear) {
            
            if([majorValue intValue] == majorID && [minorValue intValue] == minorIDPayment) {
                // Payment beacon
                NSLog(@"Payment beacon!");
                // load payment scren
                message = @"Payment beacon detected.";
                bgColor = [UIColor blueColor];
                //[self speak:message];
            }
            if([majorValue intValue] == majorID && [minorValue intValue] == minorIDOffer) {
                // Offers beacon
                NSLog(@"Offer beacon!");
                // load offer screen
                message = @"Offer beacon detected.";
                bgColor = [UIColor orangeColor];
                //[self speak:message];
            }
            
            if ([minorValue intValue] != previousMinorID) {
                [self.statusLabel setText:message];
                UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Found a Beacon"
                                                              message:message
                                                             delegate:NULL
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
                [av show];
                [self.statusLabel setText:message];
                [self.view setBackgroundColor:bgColor];
                previousMinorID = [minorValue intValue];
            }
        }
    }
}

@end
