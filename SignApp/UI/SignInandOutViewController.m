//
//  SignInandOutViewController.m
//  SignApp
//
//  Created by Genius on 2017/9/26.
//  Copyright © 2017年 Xue. All rights reserved.
//

#import "SignInandOutViewController.h"
#import "AttendanceRecordTableViewController.h"
#import "BaseStationRequest.h"
#import "SignInRequest.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "DailyRecordRequest.h"

@interface SignInandOutViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic,strong) AttendanceRecordTableViewController *attendanceRecordTableView; // 考勤页面
@property (nonatomic,strong) BaseStationRequest *request; // 获取基站信息请求
@property (nonatomic,strong) SignInRequest *signRequest; // 签到请求
@property (nonatomic,strong) DailyRecordRequest *dailyRequest; // 今日考勤信息请求
@property (nonatomic,strong) NSMutableArray *baseStationInfoArray; // 基站信息数组
@property (nonatomic,strong) NSDictionary *currentBaseStationInfo; // 当前基站信息
@property (nonatomic,strong) CLLocation *currentLocation; // 当前位置坐标
@property (weak, nonatomic) IBOutlet UIView *mapBaseView; // 百度地图BaseView
@property (nonatomic,strong) BMKMapView *mapView; // 百度地图View
@property (nonatomic,strong) BMKLocationService *locService; // 百度地图定位
@property (nonatomic,strong) MBProgressHUD *hud; // 加载框
@property (weak, nonatomic) IBOutlet UIButton *signInBtn; // 签到按钮
@property (weak, nonatomic) IBOutlet UILabel *workTime; // 上班时间标签
@property (weak, nonatomic) IBOutlet UILabel *leaveTime; // 下班时间标签

@end

@implementation SignInandOutViewController

- (BaseStationRequest *)request {
    if (!_request) {
        _request = [BaseStationRequest request];
    }
    return _request;
}

- (SignInRequest *)signRequest {
    if (!_signRequest) {
        _signRequest = [SignInRequest request];
    }
    return _signRequest;
}

- (DailyRecordRequest *)dailyRequest {
    if (!_dailyRequest) {
        _dailyRequest = [DailyRecordRequest request];
    }
    return _dailyRequest;
}

- (NSMutableArray *)baseStationInfoArray {
    if (!_baseStationInfoArray) {
        _baseStationInfoArray = [NSMutableArray array];
    }
    return _baseStationInfoArray;
}

- (AttendanceRecordTableViewController *)attendanceRecordTableView {
    if (!_attendanceRecordTableView) {
        _attendanceRecordTableView = [[AttendanceRecordTableViewController alloc] init];
    }
    return _attendanceRecordTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化加载框
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    // 签到按钮设计
    self.signInBtn.layer.cornerRadius = 50.0;
    
    // 添加百度地图View
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.zoomLevel = 18.1; // 地图缩放等级
    self.mapView.showsUserLocation = YES; // 显示我的位置蓝点
    self.mapView.userTrackingMode = BMKUserTrackingModeNone; // 普通定位模式
    [self.mapBaseView addSubview:self.mapView];
    
    // 添加百度地图定位功能
    self.locService = [[BMKLocationService alloc] init];
    [self.locService startUserLocationService];
    
    // 获取今日签到信息
    [self getDailyRecordInfo];
    
    // 获取基站信息
    [self getBaseStationInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    _mapView.delegate = self;
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

// 设置View尺寸
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect mapFrame = CGRectMake(0, 0, self.mapBaseView.frame.size.width, self.mapBaseView.frame.size.height);
    self.mapView.frame = mapFrame;
    
    [self.view layoutSubviews];
}

// 获取当日签到信息
- (void)getDailyRecordInfo {
    [self.hud showAnimated:YES];
    self.dailyRequest.userId = @"3";
    [self.dailyRequest sendRequestWithRequestType:SANetworkingRequestTypeGet finishBlock:^(NSURLSessionDataTask *task, SAResponseEntity *responseObject) {
        [self.hud hideAnimated:YES];
        if (responseObject.success) {
            
        }
    }];
}

// 获取基站信息
- (void)getBaseStationInfo {
    [self.hud showAnimated:YES];
    [self.request sendRequestWithRequestType:SANetworkingRequestTypeGet finishBlock:^(NSURLSessionDataTask *task, SAResponseEntity *responseObject) {
        [self.hud hideAnimated:YES];
        if (responseObject.success) {
            id data = [responseObject valueForKey:@"data"];
            if (data) {
                self.baseStationInfoArray = data;
            }
        } else {
            NSLog(@"失败");
        }
    }];
}

// 点击签到按钮
- (IBAction)signInBtnTapped:(UIButton *)sender {
    if ([self isApprovedWithCurrentLocation]) {
        // 当前位置可以签到
        [self approvedWithCurrentLocation];
    } else {
        // 当前位置不可签到
        [self unapprovedWithCurrentLocation];
    }
}

// 当前位置可以签到
- (void)approvedWithCurrentLocation {
    
    // 设置请求格式
    self.signRequest.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 设置参数
    self.signRequest.userID = @"3";
    self.signRequest.stationName = [self.currentBaseStationInfo valueForKey:@"StationName"];
    self.signRequest.longitude = [self.currentBaseStationInfo valueForKey:@"Longitude"];
    self.signRequest.dimensions = [self.currentBaseStationInfo valueForKey:@"Dimensions"];
    self.signRequest.signinTime = [self getCurrentTimesWithDateFormate:@"JSON"];
    if ([self.signInBtn.titleLabel.text isEqualToString:@"签到"]) {
        self.signRequest.type = @"1";
    } else {
        self.signRequest.type = @"0";
    }
    
    [self.hud showAnimated:YES];
    [self.signRequest sendRequestWithRequestType:SANetworkingRequestTypePost finishBlock:^(NSURLSessionDataTask *task, SAResponseEntity *responseObject) {
        [self.hud hideAnimated:YES];
        if (responseObject.success) {
            if ([self.signInBtn.titleLabel.text isEqualToString:@"签到"]) {
                [self alertWithMessage:@"签到成功"];
                [self.signInBtn setTitle:@"签退" forState:UIControlStateNormal];
                self.workTime.text = [NSString stringWithFormat:@"上班：%@", [self getCurrentTimesWithDateFormate:@"HH:mm"]];
            } else {
                [self alertWithMessage:@"签退成功"];
//                [sender setTitle:@"签退" forState:UIControlStateNormal];
                self.leaveTime.text = [NSString stringWithFormat:@"下班：%@", [self getCurrentTimesWithDateFormate:@"HH:mm"]];
            }
        } else {
            if ([self.signInBtn.titleLabel.text isEqualToString:@"签到"]) {
                [self alertWithMessage:@"签到失败"];
            } else {
                [self alertWithMessage:@"签退失败"];
            }
        }
    }];
}

// 当前位置不可签到
- (void)unapprovedWithCurrentLocation {
    
}

// 点击考勤记录按钮
- (IBAction)record2BtnTapped:(id)sender {
    if (self.attendanceRecordTableView) {
        [self.navigationController pushViewController:self.attendanceRecordTableView animated:YES];
    }
}

// 判断位置是否可以签到
- (BOOL)isApprovedWithCurrentLocation {
    
    BMKMapPoint currentPoint = BMKMapPointForCoordinate(self.currentLocation.coordinate);
    for (NSDictionary *dic in self.baseStationInfoArray) {
        float latitude = [[dic valueForKey:@"Dimensions"] floatValue];
        float longitude = [[dic valueForKey:@"Longitude"] floatValue];
        BMKMapPoint baseStationPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
        
        CLLocationDistance distance = BMKMetersBetweenMapPoints(currentPoint, baseStationPoint);
        
        if (distance <= [[dic valueForKey:@"Radius"] floatValue]) {
            self.currentBaseStationInfo = dic;
            return YES;
            break;
        }
    }
    return NO;
}

// 获取当前时间
- (NSString *)getCurrentTimesWithDateFormate:(NSString *)dateFormate {
    
    if ([dateFormate isEqualToString:@"JSON"]) {
        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
        
        long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
        
        NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
        
        return [NSString stringWithFormat:@"\/Date(%@+0800)\/", curTime];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:dateFormate];
        
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        
        return currentTimeString;
    }
}

// 弹框提醒
- (void)alertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - <BMKLocationServiceDelegate>

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (userLocation.location) {
        self.currentLocation = userLocation.location;
    }
    
    [self.mapView updateLocationData:userLocation];
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.locService stopUserLocationService];
}

@end
