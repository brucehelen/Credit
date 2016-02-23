//
//  KMPushMsgModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/31.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  消息推送数据模型
 */
@interface KMPushMsgModel : NSObject

@property (nonatomic, copy) NSString *alert;

/**
 *  sos/bg/bp/battery/shutdown/startup
 *  sos go to sos location page
 *  bg/bp go to glucose/blood pressure page
 *  others go to main page
 */
@property (nonatomic, copy) NSString *type;
/**
 *  发生SOS警报的IMEI
 */
@property (nonatomic, copy) NSString *imei;
/**
 *  high / mid / low
 */
@property (nonatomic, copy) NSString *level;
/**
 *  Go to sos location page
 */
@property (nonatomic, copy) NSString *battery;
/**
 *  latitude
 */
@property (nonatomic, copy) NSString *lat;
/**
 *  longitude
 */
@property (nonatomic, copy) NSString *lon;

@property (nonatomic, copy) NSString *glucose;

@property (nonatomic, copy) NSString *plasma;
/**
 *  Systolic blood pressure
 */
@property (nonatomic, copy) NSString *sbp;
/**
 *  Diastolic blood pressure
 */
@property (nonatomic, copy) NSString *dbp;

@property (nonatomic, copy) NSString *pluse;

@property (nonatomic, copy) NSString *date;

@end
