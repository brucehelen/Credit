//
//  AppDelegate.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/27.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate ()

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configIQKeyBoardManager];
    [self configSVHUD];
    [self configNavBarColor];

    // 推送配置
    [self configJPushWithOption:launchOptions];
    // 检查当前的语言
    [self checkCurrentCountry];
    // 处理推送消息
    [self checkRemotePushMsg:launchOptions];

    // 地图配置
//    member.userMapType = KM_USER_MAP_TYPE_BAIDU;
	member.userMapType = KM_USER_MAP_TYPE_GOOGLE;
    [self configMap];

    // 下拉刷新控件
    [self configMJRefresh];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str = [NSString stringWithFormat:@"%@", deviceToken];

    // 去掉空格和<>
    NSString *newString = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@">" withString:@""];
    DMLog(@"## deviceToken: %@", newString);

    member.deviceToken = newString;

    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kmReceiveRemoteNotification"
                                                        object:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kmReceiveRemoteNotification"
                                                        object:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - 配置键盘样式
- (void)configIQKeyBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldShowTextFieldPlaceholder = YES;
    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
}

#pragma mark - 配置HUD
- (void)configSVHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

#pragma mark - 设置全局导航栏背景颜色
- (void)configNavBarColor
{
    // 背景灰色，文字白色
    UIColor *color = [UIColor colorWithRed:163.0/255.0 green:163/255.0 blue:163/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor:color];

    // 设置线条的颜色为白色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
}

#pragma mark - 设置JPush推送
- (void)configJPushWithOption:(NSDictionary *)launchOptions
{
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
}

#pragma mark - 检查用户在哪个国家
- (void)checkCurrentCountry
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
}

#pragma mark - 配置MJRefresh显示字符串
- (void)configMJRefresh
{
    MJRefreshHeaderIdleText = kLoadStringWithKey(@"MJRefresh_Pull_down_refresh");
    MJRefreshHeaderPullingText = kLoadStringWithKey(@"MJRefresh_Refresh_Now");
    MJRefreshHeaderRefreshingText = kLoadStringWithKey(@"MJRefresh_Refreshing_data");
}

#pragma mark - 根据用户的选择配置地图
- (void)configMap
{
    switch (member.userMapType) {
        case KM_USER_MAP_TYPE_BAIDU:
            [self configBaiduMap];
            break;
        default:
            break;
    }
}

#pragma mark - 百度地图初始化
- (void)configBaiduMap
{
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:kBaiduMapKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"*** baidu map start failed ***");
    }
}

#pragma mark - 检查是否有推送消息
/**
 *  检查用户是否点击推送消息进入APP，如果是则保存为pushNotificationKey
 *  在ViewController中进行统一处理
 *
 *  @param launchOptions launchOptions
 */
- (void)checkRemotePushMsg:(NSDictionary *)launchOptions
{
    // 检查用户是否通过通知进入程序
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushNotificationKey) {
            // 先保存，登录成功后在KMMainVC中处理推送消息
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:pushNotificationKey forKey:@"pushNotificationKey"];
        }
    }
}

@end
