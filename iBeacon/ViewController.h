//
//  ViewController.h
//  iBeacon
//
//  Created by raviranjan on 01/07/14.
//  Copyright (c) 2014 NK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
