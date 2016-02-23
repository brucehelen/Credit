//
//  KMMember.h
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMUserModel.h"

#define member  [KMMemberManager sharedInstance]

typedef NS_ENUM(NSInteger, KMUserWatchType) {
    KM_WATCH_TYPE_GOLD,     // 土豪金
    KM_WATCH_TYPE_BLACK,    // 黑色
    KM_WATCH_TYPE_ORANGE    // 橘红色
};

/**
 *  APP使用的地图，三选一
 */
typedef NS_ENUM(NSInteger, KMUserMapType) {
    /**
     *  iOS自带地图
     */
    KM_USER_MAP_TYPE_IOS,
    /**
     *  iOS自带地图-大陆高德地图(需要纠偏)
     */
    KM_USER_MAP_TYPE_IOS_CHINA,
    /**
     *  百度地图(需要纠偏)
     */
    KM_USER_MAP_TYPE_BAIDU,
    /**
     *  谷歌地图
     */
    KM_USER_MAP_TYPE_GOOGLE
};

//typedef NS_ENUM(NSInteger, KMMapCorrectType) {
//    /**
//     *  无纠偏，直接显示原始坐标
//     */
//    KM_MAP_NO_CORRECT,
//    /**
//     *  高德地图纠偏(iOS大陆自带)纠偏
//     */
//    KM_MAP_CORRECT_TO_GAODE,
//    /**
//     *  百度地图纠偏
//     */
//    KM_MAP_CORRECT_TO_BAIDU
//};

@interface KMMemberManager : NSObject

@property (nonatomic, copy) NSString *loginEmail;
@property (nonatomic, copy) NSString *loginPd;
@property (nonatomic, assign) BOOL rememberLoginFlag;

@property (nonatomic, strong) KMUserModel *userModel;           // 用户成功登录信息

/**
 *  地图类型
 */
@property (nonatomic, assign) KMUserMapType userMapType;

/**
 *  保存获取到的DeviceToken
 */
@property (nonatomic, copy) NSString *deviceToken;

/**
 *  单例
 */
+ (KMMemberManager *)sharedInstance;

// 根据imei来获取用户的头像，如果不存在返回nil
+ (UIImage *)userHeaderImageWithIMEI:(NSString *)imei;
// 设置用户头像
+ (void)addUserHeaderImage:(UIImage *)image IMEI:(NSString *)imei;

// 根据imei来获取用户名字
+ (NSString *)userNameWithIMEI:(NSString *)imei;
+ (void)addUserName:(NSString *)name IMEI:(NSString *)imei;

// 根据imei来获取用户电话号码
+ (NSString *)userPhoneNumberWithIMEI:(NSString *)imei;
+ (void)addUserPhoneNumber:(NSString *)phoneNumber IMEI:(NSString *)imei;

// 根据imei来获取配套手表类型
+ (KMUserWatchType)userWatchTypeWithIMEI:(NSString *)imei;
+ (void)addUserWatchType:(KMUserWatchType)type IMEI:(NSString *)imei;
+ (UIImage *)userWatchImageWithIMEI:(NSString *)imei;
+ (UIImage *)userWatchImageWithType:(KMUserWatchType)type;

@end
