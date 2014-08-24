//
//  SGAppDelegate.h
//  SinriGPSLib
//
//  Created by 倪 李俊 on 14-8-24.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGTestViewController.h"

@interface SGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property SGTestViewController * testVC;
@property UINavigationController *navVC;
@end
