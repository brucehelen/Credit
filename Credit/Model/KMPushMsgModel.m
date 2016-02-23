//
//  KMPushMsgModel.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/31.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMPushMsgModel.h"

@implementation KMPushMsgModel

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];

    [string appendFormat:@"\ntype: %@\n", self.type];
    [string appendFormat:@"alert: %@\n", self.alert];
    if (self.imei) [string appendFormat:@"imei: %@\n", self.imei];
    if (self.level) [string appendFormat:@"level: %@\n", self.level];
    if (self.battery) [string appendFormat:@"battery: %@\n", self.battery];
    if (self.lat) [string appendFormat:@"lat: %@\n", self.lat];
    if (self.lon) [string appendFormat:@"lon: %@\n", self.lon];
    if (self.glucose) [string appendFormat:@"glucose: %@\n", self.glucose];
    if (self.plasma) [string appendFormat:@"plasma: %@\n", self.plasma];
    if (self.sbp) [string appendFormat:@"sbp: %@\n", self.sbp];
    if (self.dbp) [string appendFormat:@"dbp: %@\n", self.dbp];
    if (self.pluse) [string appendFormat:@"pluse: %@\n", self.pluse];

    return string;
}

@end
