//
//  SGGPSLib.h
//  SinriGPSLib
//
//  Created by 倪 李俊 on 14-8-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define SGGPSLibUpdatedLocationNotification @"SGGPSLibUpdatedLocationNotification"
#define SGGPSLibUpdatedHeadingNotification @"SGGPSLibUpdatedHeadingNotification"

@interface SGGPSLib : NSObject
<CLLocationManagerDelegate>

@property(nonatomic, retain) CLLocationManager *man;

@property NSString * UpdatedHeadingNotification;
@property NSString * UpdatedLocationNotification;

@property BOOL isRunOnce;

@end

@interface SGGPSLib (updateLocation)
-(BOOL)startUpdatingLocation;
-(BOOL)startUpdatingLocationIsForOnce:(BOOL)runOnce;
-(BOOL)startUpdatingLocationByDelegate:(id<CLLocationManagerDelegate>)delegate withDistanceFilter:(CLLocationDistance)filter withDesiredAccuracy:(CLLocationAccuracy)accuracy runOnceOnly:(BOOL)runOnce;
@end

@interface SGGPSLib (updateHeading)
-(BOOL)startUpdatingHeadingIsForOnce:(BOOL)runOnce;
-(void)stopUpdatingHeading;
@end
