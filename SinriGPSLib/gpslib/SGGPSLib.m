//
//  SGGPSLib.m
//  SinriGPSLib
//
//  Created by 倪 李俊 on 14-8-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "SGGPSLib.h"

@implementation SGGPSLib

-(id)init{
    self=[super init];
    if(self){
        _man = [[CLLocationManager alloc] init];
        _UpdatedHeadingNotification=SGGPSLibUpdatedHeadingNotification;
        _UpdatedLocationNotification=SGGPSLibUpdatedLocationNotification;
    }
    return self;
}

#pragma mark delegate

// 如果GPS测量成果以下的函数被调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    /*
     // 取得经纬度
     CLLocationCoordinate2D coordinate = newLocation.coordinate;
     CLLocationDegrees latitude = coordinate.latitude;
     CLLocationDegrees longitude = coordinate.longitude;
     // 取得精度
     CLLocationAccuracy horizontal = newLocation.horizontalAccuracy;
     CLLocationAccuracy vertical = newLocation.verticalAccuracy;
     // 取得高度
     CLLocationDistance altitude = newLocation.altitude;
     // 取得时刻
     NSDate *timestamp = [newLocation timestamp];
     */
    // 以下面的格式输出 format: <latitude>, <longitude>> +/- <accuracy>m @ <date-time>
    NSLog(@"以下面的格式输出 format: <latitude>, <longitude>> +/- <accuracy>m @ <date-time>=%@",[newLocation description]);
    
    // 与上次测量地点的间隔距离
    CLLocationDistance d =0;
    if(oldLocation != nil){
        d = [newLocation getDistanceFrom:oldLocation];
        NSLog(@"与上次测量地点的间隔距离=%f", d);
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:_UpdatedLocationNotification
     object:@{
              @"location":newLocation,
              @"distance":[NSNumber numberWithDouble:d]
              }
     ];
    
    if(_isRunOnce){
        [_man stopUpdatingLocation];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    /*
    CLLocationDirection magneticHeading=newHeading.magneticHeading;
    CLLocationDirection trueHeading= newHeading.trueHeading;
    CLLocationDirection headingAccuracy=newHeading.headingAccuracy;
    CLHeadingComponentValue x=newHeading.x;
    CLHeadingComponentValue y=newHeading.y;
    CLHeadingComponentValue z=newHeading.z;
    NSDate * timestamp = newHeading.timestamp;
    */
    NSLog(@"locationManager didUpdateHeading:%@",newHeading);
    [[NSNotificationCenter defaultCenter]postNotificationName:_UpdatedHeadingNotification object:newHeading];
}

// 如果GPS测量失败了，下面的函数被调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"locationManager didFailWithError:%@",[error localizedDescription]);
    if(_isRunOnce){
        [_man stopUpdatingLocation];
    }
}

@end

@implementation SGGPSLib (updateLocation)

-(BOOL)startUpdatingLocation{
    return [self startUpdatingLocationByDelegate:self withDistanceFilter:kCLDistanceFilterNone withDesiredAccuracy:kCLLocationAccuracyBest runOnceOnly:NO];
}

-(BOOL)startUpdatingLocationIsForOnce:(BOOL)runOnce{
    return [self startUpdatingLocationByDelegate:self withDistanceFilter:kCLDistanceFilterNone withDesiredAccuracy:kCLLocationAccuracyBest runOnceOnly:runOnce];
}

-(BOOL)startUpdatingLocationByDelegate:(id<CLLocationManagerDelegate>)delegate withDistanceFilter:(CLLocationDistance)filter withDesiredAccuracy:(CLLocationAccuracy)accuracy runOnceOnly:(BOOL)runOnce{
    _man = [[CLLocationManager alloc] init];
    _isRunOnce=runOnce;
    
    // 如果可以利用本地服务时
    if([CLLocationManager locationServicesEnabled]){
        // 接收事件的实例
        _man.delegate = delegate;
        // 发生事件的的最小距离间隔（缺省是不指定）
        _man.distanceFilter = filter;
        // 精度 (缺省是Best)
        _man.desiredAccuracy = accuracy;
        // 开始测量
        [_man startUpdatingLocation];
        
        return YES;
    }else{
        return NO;
    }
}

-(void)stopGPS{
    [_man stopUpdatingLocation];
}

@end

@implementation SGGPSLib (updateHeading)

-(BOOL)startUpdatingHeadingIsForOnce:(BOOL)runOnce{
    if([CLLocationManager locationServicesEnabled]){
        // 接收事件的实例
        _man.delegate = self;
        // 发生事件的的最小距离间隔（缺省是不指定）
        _man.distanceFilter = kCLDistanceFilterNone;
        // 精度 (缺省是Best)
        _man.desiredAccuracy = kCLLocationAccuracyBest;
        // 开始测量
        [_man startUpdatingHeading];
        return YES;
    }else{
        return NO;
    }
}
-(void)stopUpdatingHeading{
    [_man stopUpdatingHeading];
}

@end
