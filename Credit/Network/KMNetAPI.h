//
//  KMNetAPI.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMUserRegisterModel;
@class KMDeviceSettingModel;

/*
 * code: 请求是否成功，0成功，其他失败
 *  res: 从网络获取到的数据
 */
typedef void (^KMRequestResultBlock)(int code, NSString *res);

@interface KMNetAPI : NSObject

+ (instancetype)manager;

@end



