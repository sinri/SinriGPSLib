//
//  SGTestViewController.m
//  SinriGPSLib
//
//  Created by 倪 李俊 on 14-8-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "SGTestViewController.h"

@interface SGTestViewController ()

@end

@implementation SGTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _man = [[CLLocationManager alloc] init];
    
    // 如果可以利用本地服务时
    if([CLLocationManager locationServicesEnabled]){
        // 接收事件的实例
        _man.delegate = self;
        // 发生事件的的最小距离间隔（缺省是不指定）
        _man.distanceFilter = kCLDistanceFilterNone;
        // 精度 (缺省是Best)
        _man.desiredAccuracy = kCLLocationAccuracyBest;
        // 开始测量
        [_man startUpdatingLocation];
    }
    
    latitudeLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 70, 130, 30))];
    [latitudeLabel setText:@"Latitude"];
    [self.view addSubview:latitudeLabel];
    
    latitudeTF=[[UITextField alloc]initWithFrame:(CGRectMake(150,70, self.view.frame.size.width-160, 30))];
    [latitudeTF setText:@""];
    [self.view addSubview:latitudeTF];
    
    longitudeLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 110, 130, 30))];
    [longitudeLabel setText:@"Longitude"];
    [self.view addSubview:longitudeLabel];
    
    longitudeTF=[[UITextField alloc]initWithFrame:(CGRectMake(150,110, self.view.frame.size.width-160, 30))];
    [longitudeTF setText:@""];
    [self.view addSubview:longitudeTF];
    
    altitudeLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 150, 130, 30))];
    [altitudeLabel setText:@"Altitude"];
    [self.view addSubview:altitudeLabel];
    
    altitudeTF=[[UITextField alloc]initWithFrame:(CGRectMake(150,150, self.view.frame.size.width-160, 30))];
    [altitudeTF setText:@""];
    [self.view addSubview:altitudeTF];
    
    accuracyLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 190, 130, 30))];
    [accuracyLabel setText:@"Accuracy +/-m"];
    [self.view addSubview:accuracyLabel];
    
    accuracyTF=[[UITextField alloc]initWithFrame:(CGRectMake(150,190, self.view.frame.size.width-160, 30))];
    [accuracyTF setText:@""];
    [self.view addSubview:accuracyTF];
    
    datetimeLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 230, 130, 30))];
    [datetimeLabel setText:@"Date Time"];
    [self.view addSubview:datetimeLabel];
    
    datetimeTF=[[UITextField alloc]initWithFrame:(CGRectMake(150,230, self.view.frame.size.width-160, 30))];
    [datetimeTF setText:@""];
    [self.view addSubview:datetimeTF];
    
    distanceLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 270, 130, 30))];
    [distanceLabel setText:@"Distance"];
    [self.view addSubview:distanceLabel];
    
    distanceTF=[[UITextField alloc]initWithFrame:(CGRectMake(150,270, self.view.frame.size.width-160, 30))];
    [distanceTF setText:@""];
    [self.view addSubview:distanceTF];
    
    historyView = [[UITextView alloc]initWithFrame:(CGRectMake(10, 310, self.view.frame.size.width-20, 120))];
    [historyView setText:@""];
    [historyView setEditable:NO];
    [self.view addSubview:historyView];
    
    
    gpsLib = [[SGGPSLib alloc]init];
    [gpsLib startUpdatingHeadingIsForOnce:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 如果GPS测量成果以下的函数被调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
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
    
    // 以下面的格式输出 format: <latitude>, <longitude>> +/- <accuracy>m @ <date-time>
    NSLog(@"以下面的格式输出 format: <latitude>, <longitude>> +/- <accuracy>m @ <date-time>=%@",[newLocation description]);
    
    // 与上次测量地点的间隔距离
    CLLocationDistance d =0;
    if(oldLocation != nil){
        d = [newLocation getDistanceFrom:oldLocation];
        NSLog(@"与上次测量地点的间隔距离=%f", d);
    }
    // 取得经纬度
    [latitudeTF setText:[NSString stringWithFormat:@"%f",latitude]];
    [longitudeTF setText:[NSString stringWithFormat:@"%f",longitude]];
    // 取得高度
    [altitudeTF setText:[NSString stringWithFormat:@"%f",altitude]];
    // 取得精度
    [accuracyTF setText:[NSString stringWithFormat:@"H%.1f V%.1f",horizontal,vertical]];
     // 取得时刻
    [datetimeTF setText:[NSString stringWithFormat:@"%@",timestamp]];
    // 与上次测量地点的间隔距离
    [distanceTF setText:[NSString stringWithFormat:@"%f",d]];
    
    [historyView setText:[[historyView text] stringByAppendingString:[newLocation description]]];
    
}

// 如果GPS测量失败了，下面的函数被调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"locationManager didFailWithError:%@",[error localizedDescription]);
}

@end
