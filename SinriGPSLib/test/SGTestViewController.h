//
//  SGTestViewController.h
//  SinriGPSLib
//
//  Created by 倪 李俊 on 14-8-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SGGPSLib.h"
@interface SGTestViewController : UIViewController
<CLLocationManagerDelegate>
{
    UILabel * latitudeLabel;
    UITextField * latitudeTF;
    
    UILabel * longitudeLabel;
    UITextField * longitudeTF;
    
    UILabel * altitudeLabel;
    UITextField * altitudeTF;
    
    UILabel * accuracyLabel;
    UITextField * accuracyTF;
    
    UILabel * datetimeLabel;
    UITextField * datetimeTF;
    
    UILabel * distanceLabel;
    UITextField * distanceTF;
    
    UITextView * historyView;
    
    SGGPSLib * gpsLib;
}

@property(nonatomic, retain) CLLocationManager *man;

@end
